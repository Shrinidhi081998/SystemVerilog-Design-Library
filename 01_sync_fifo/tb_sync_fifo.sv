// =============================================================================
// tb_sync_fifo.sv - Self-checking testbench for sync_fifo
// Reference model: a SystemVerilog queue mirrors expected FIFO contents.
// =============================================================================
`timescale 1ns/1ps
module tb_sync_fifo;

    localparam int WIDTH = 8;
    localparam int DEPTH = 16;

    logic clk = 0;
    logic rst_n;
    logic wr_en, rd_en;
    logic [WIDTH-1:0] wdata, rdata;
    logic full, empty;
    logic [$clog2(DEPTH):0] fill_count;

    int errors = 0;
    int checks = 0;
    logic [WIDTH-1:0] ref_model [$];   // golden reference queue

    sync_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wdata(wdata), .full(full),
        .rd_en(rd_en), .rdata(rdata), .empty(empty),
        .fill_count(fill_count)
    );

    always #5 clk = ~clk;   // 100 MHz

    // ---------------- VCD dump ----------------
    initial begin
        $dumpfile("sync_fifo.vcd");
        $dumpvars(0, tb_sync_fifo);
    end

    // ---------------- Drive + check on every clock ----------------
    always @(posedge clk) begin
        if (rst_n) begin
            // Check that empty flag agrees with the reference model BEFORE any read fires
            if (empty !== (ref_model.size() == 0)) begin
                $display("[%0t] ERROR: empty flag mismatch. dut_empty=%0b ref_size=%0d",
                          $time, empty, ref_model.size());
                errors++;
            end
            checks++;

            // Perform write into reference model
            if (wr_en && !full) ref_model.push_back(wdata);

            // Perform read + check data against reference model
            if (rd_en && !empty) begin
                logic [WIDTH-1:0] exp; exp = ref_model.pop_front();
                if (rdata !== exp) begin
                    $display("[%0t] ERROR: rdata mismatch. dut=%0h exp=%0h", $time, rdata, exp);
                    errors++;
                end
                checks++;
            end
        end
    end

    task automatic do_write(input [WIDTH-1:0] d);
        @(negedge clk);
        wr_en = 1; wdata = d; rd_en = 0;
        @(posedge clk);
        #1 wr_en = 0;
    endtask

    task automatic do_read();
        @(negedge clk);
        rd_en = 1; wr_en = 0;
        @(posedge clk);
        #1 rd_en = 0;
    endtask

    initial begin
        wr_en = 0; rd_en = 0; wdata = 0;
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // --- Test 1: fill completely, verify FULL asserts exactly at DEPTH writes ---
        for (int i = 0; i < DEPTH; i++) do_write(i[WIDTH-1:0]);
        if (!full) begin $display("ERROR: expected FULL after %0d writes", DEPTH); errors++; end
        checks++;

        // --- Test 2: try to write while full -> should be ignored ---
        do_write(8'hFF);
        if (ref_model.size() != DEPTH) begin
            $display("ERROR: write-while-full corrupted FIFO, size=%0d", ref_model.size());
            errors++;
        end
        checks++;

        // --- Test 3: drain completely, verify EMPTY asserts exactly at 0 ---
        for (int i = 0; i < DEPTH; i++) do_read();
        if (!empty) begin $display("ERROR: expected EMPTY after draining"); errors++; end
        checks++;

        // --- Test 4: read while empty -> should be ignored, no crash ---
        do_read();

        // --- Test 5: randomized simultaneous read/write stress ---
        begin
            bit do_w, do_r;
            for (int i = 0; i < 500; i++) begin
                do_w = $urandom_range(0,1);
                do_r = $urandom_range(0,1);
                @(negedge clk);
                wr_en = do_w; wdata = $urandom;
                rd_en = do_r;
                @(posedge clk);
                #1;
            end
        end
        wr_en = 0; rd_en = 0;

        // --- Test 6: drain whatever remains and verify full match ---
        while (ref_model.size() > 0) do_read();

        @(posedge clk);
        $display("--------------------------------------------------");
        if (errors == 0)
            $display("SYNC FIFO: ALL %0d CHECKS PASSED", checks);
        else
            $display("SYNC FIFO: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end

endmodule
