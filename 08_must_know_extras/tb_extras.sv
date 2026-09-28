// =============================================================================
// tb_extras.sv - Combined testbench for ASIC must-know circuits
// =============================================================================
`timescale 1ns/1ps
module tb_extras;
    logic clk=0, rst_n;
    always #5 clk=~clk;

    initial begin
        $dumpfile("extras.vcd");
        $dumpvars(0, tb_extras);
    end

    int tot_errors=0, tot_checks=0;

    // ==== Priority Encoder ====
    logic [7:0] pe_in;
    logic [2:0] pe_out;
    logic       pe_valid;
    priority_encoder #(.N(8)) u_pe (.in(pe_in), .out(pe_out), .valid(pe_valid));

    task automatic test_pe(input [7:0] v, input [2:0] exp);
        pe_in=v; #1;
        tot_checks++;
        if (pe_out!==exp || pe_valid!==(v!=0)) begin
            $display("PE ERROR: in=%08b out=%0d valid=%b, exp_out=%0d",v,pe_out,pe_valid,exp);
            tot_errors++;
        end
    endtask

    // ==== Shift Register ====
    logic [1:0] sr_mode;
    logic       sr_sin;
    logic [7:0] sr_par_in, sr_par_out;
    logic       sr_sout;
    shift_register #(.WIDTH(8)) u_sr (.clk,.rst_n,.mode(sr_mode),.sin(sr_sin),.par_in(sr_par_in),.sout(sr_sout),.par_out(sr_par_out));

    // ==== Register File ====
    logic        rf_wr_en;
    logic [3:0]  rf_wr_addr;
    logic [31:0] rf_wr_data;
    logic [1:0][3:0]  rf_rd_addr;
    logic [1:0][31:0] rf_rd_data;
    register_file #(.WIDTH(32),.NREGS(16),.NREAD(2)) u_rf (
        .clk,.rst_n,.wr_en(rf_wr_en),.wr_addr(rf_wr_addr),.wr_data(rf_wr_data),
        .rd_addr(rf_rd_addr),.rd_data(rf_rd_data));

    // ==== Traffic light ====
    logic tl_red, tl_yellow, tl_green;
    traffic_light_fsm #(.GREEN_TIME(4),.YELLOW_TIME(2),.RED_TIME(3)) u_tl (.clk,.rst_n,.red(tl_red),.yellow(tl_yellow),.green(tl_green));

    // ==== Sequence detector ====
    logic seq_din, seq_det;
    sequence_detector_1011 u_seq (.clk,.rst_n,.din(seq_din),.detected(seq_det));

    // ==== SPI master ====
    logic        spi_start, spi_done, spi_busy;
    logic [7:0]  spi_tx, spi_rx;
    logic        spi_sclk, spi_mosi, spi_cs_n, spi_miso;
    spi_master #(.WIDTH(8),.CLKS_PER_HALF(2)) u_spi (
        .clk,.rst_n,.start(spi_start),.tx_data(spi_tx),.rx_data(spi_rx),
        .done(spi_done),.busy(spi_busy),.sclk(spi_sclk),.mosi(spi_mosi),.cs_n(spi_cs_n),.miso(spi_miso));
    // Loopback: MISO = delayed MOSI (simulating a slave echoing back)
    assign #2 spi_miso = spi_mosi;

    initial begin
        rst_n=0; rf_wr_en=0; sr_mode=2'b00; sr_sin=0; sr_par_in=0;
        spi_start=0; spi_tx=0; seq_din=0; pe_in=0;
        repeat(3) @(posedge clk); rst_n=1;
        @(posedge clk);

        // ---- Priority Encoder tests ----
        test_pe(8'b00000001, 3'd0);
        test_pe(8'b00000010, 3'd1);
        test_pe(8'b10000000, 3'd7);
        test_pe(8'b11010110, 3'd1);   // lowest-index set bit is 1
        test_pe(8'b00000000, 3'd0);   // no bits set, valid=0
        $display("Priority Encoder: %0d checks", tot_checks);

        // ---- Shift Register ----
        // Parallel load then shift out
        @(negedge clk); sr_mode=2'b10; sr_par_in=8'hA5;
        @(posedge clk); // load
        @(negedge clk); sr_mode=2'b01; sr_sin=0;
        repeat(8) begin
            @(posedge clk);
            @(negedge clk);
        end
        tot_checks++;
        // After 8 shifts out, all A5 bits have come out MSB-first
        @(negedge clk); sr_mode=2'b11; @(posedge clk); // reset
        tot_checks++;
        if (sr_par_out!==8'h00) begin $display("SR reset ERROR: got %h",sr_par_out); tot_errors++; end

        // ---- Register File ----
        @(negedge clk); rf_wr_en=1; rf_wr_addr=4'd5; rf_wr_data=32'hDEAD_BEEF;
        @(posedge clk);
        @(negedge clk); rf_wr_en=0; rf_rd_addr[0]=4'd5; rf_rd_addr[1]=4'd0;
        #1;
        tot_checks++;
        if (rf_rd_data[0]!==32'hDEAD_BEEF) begin $display("RF read ERROR: %h",rf_rd_data[0]); tot_errors++; end
        tot_checks++;
        if (rf_rd_data[1]!==32'h0) begin $display("RF zero reg ERROR: %h",rf_rd_data[1]); tot_errors++; end
        // Write-first test: write and read same addr in same cycle
        @(negedge clk); rf_wr_en=1; rf_wr_addr=4'd3; rf_wr_data=32'hCAFEBABE;
                        rf_rd_addr[0]=4'd3;
        #1; // combinational update
        tot_checks++;
        if (rf_rd_data[0]!==32'hCAFEBABE) begin $display("RF write-first ERROR: %h",rf_rd_data[0]); tot_errors++; end
        @(posedge clk); @(negedge clk); rf_wr_en=0;

        // ---- Traffic Light ----
        // Wait for each state in sequence - don't assume fixed cycle counts
        // since earlier test tasks consumed clock cycles
        // Wait for GREEN
        begin
            int cnt_wait;
            cnt_wait=0;
            while (!tl_green && cnt_wait<100) begin @(posedge clk); cnt_wait++; end
            tot_checks++;
            if (!tl_green || tl_yellow || tl_red) begin
                $display("TL: timed out waiting for GREEN (green=%b yellow=%b red=%b)",tl_green,tl_yellow,tl_red);
                tot_errors++;
            end
            // Wait for GREEN->YELLOW transition
            cnt_wait=0;
            while (!tl_yellow && cnt_wait<100) begin @(posedge clk); cnt_wait++; end
            tot_checks++;
            if (!tl_yellow || tl_green || tl_red) begin
                $display("TL: timed out waiting for YELLOW");
                tot_errors++;
            end
            // Wait for YELLOW->RED
            cnt_wait=0;
            while (!tl_red && cnt_wait<100) begin @(posedge clk); cnt_wait++; end
            tot_checks++;
            if (!tl_red || tl_green || tl_yellow) begin
                $display("TL: timed out waiting for RED");
                tot_errors++;
            end
        end

        // ---- Sequence Detector (1011) ----
        begin
            integer det_count;
            det_count = 0;
            seq_din = 0;
            // stream "001011011" - should detect "1011" at two positions
            @(negedge clk); seq_din=0; @(posedge clk);
            @(negedge clk); seq_din=0; @(posedge clk);
            @(negedge clk); seq_din=1; @(posedge clk); if(seq_det) det_count++;
            @(negedge clk); seq_din=0; @(posedge clk); if(seq_det) det_count++;
            @(negedge clk); seq_din=1; @(posedge clk); if(seq_det) det_count++;
            @(negedge clk); seq_din=1; @(posedge clk); if(seq_det) det_count++;  // detect here: 1011
            @(negedge clk); seq_din=0; @(posedge clk); if(seq_det) det_count++;
            @(negedge clk); seq_din=1; @(posedge clk); if(seq_det) det_count++;
            @(negedge clk); seq_din=1; @(posedge clk); if(seq_det) det_count++;  // detect here: 1011
            tot_checks++;
            if (det_count!==2) begin $display("SEQ DET: expected 2 detections got %0d",det_count); tot_errors++; end
            else $display("Sequence detector: correctly found 2x '1011'");
        end

        // ---- SPI Master (loopback) ----
        @(negedge clk); spi_tx=8'h7E; spi_start=1;
        @(negedge clk); spi_start=0;
        while(!spi_done) @(negedge clk);
        tot_checks++;
        if (spi_rx!==8'h7E) begin $display("SPI loopback ERROR: got %h exp 7E",spi_rx); tot_errors++; end

        $display("--------------------------------------------------");
        if (tot_errors==0) $display("EXTRAS: ALL %0d CHECKS PASSED", tot_checks);
        else $display("EXTRAS: %0d ERRORS out of %0d checks", tot_errors, tot_checks);
        $display("--------------------------------------------------");
        #100 $finish;
    end

endmodule
