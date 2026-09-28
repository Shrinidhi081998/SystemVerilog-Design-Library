// =============================================================================
// tb_async_fifo.sv - Self-checking testbench for async_fifo
// Uses two independent, unrelated clock frequencies to genuinely exercise CDC.
// =============================================================================
`timescale 1ns/1ps
module tb_async_fifo;

    localparam int WIDTH = 8;
    localparam int DEPTH = 16;

    logic wr_clk = 0, rd_clk = 0;
    logic wr_rst_n, rd_rst_n;
    logic wr_en, rd_en;
    logic [WIDTH-1:0] wdata, rdata;
    logic full, empty;

    int errors = 0;
    int checks = 0;
    logic [WIDTH-1:0] ref_model [$];

    async_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n), .wr_en(wr_en), .wdata(wdata), .full(full),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n), .rd_en(rd_en), .rdata(rdata), .empty(empty)
    );

    // Deliberately unrelated, non-integer-ratio clock periods to genuinely exercise CDC
    always #3.5 wr_clk = ~wr_clk;
    always #5.5 rd_clk = ~rd_clk;

    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, tb_async_fifo);
    end

    // Safety net in case of an unexpected deadlock/oscillation
    initial begin
        #500000;
        $display("WATCHDOG TIMEOUT at T=%0t -- simulation did not complete in time", $time);
        $finish;
    end

    // ---------------- Write side: drive + push into reference model ----------------
    // Checked the same way the DUT itself gates a write: using the pre-edge
    // (already-settled) value of 'full', sampled right at the posedge.
    always @(posedge wr_clk) begin
        if (wr_rst_n && wr_en && !full) begin
            ref_model.push_back(wdata);
        end
    end

    initial begin
        wr_en = 0; wdata = 0; wr_rst_n = 0;
        repeat (4) @(posedge wr_clk);
        wr_rst_n = 1;

        for (int i = 0; i < 400; i++) begin
            @(negedge wr_clk);
            wr_en = ($urandom_range(0,9) < 7);   // ~70% write attempt rate
            wdata = i[WIDTH-1:0];
        end
        @(negedge wr_clk);
        wr_en = 0;
    end

    // ---------------- Read side: checker samples at posedge (matches NBA/register semantics) ----------------
    always @(posedge rd_clk) begin
        if (rd_rst_n && rd_en && !empty) begin
            checks++;
            if (ref_model.size() == 0) begin
                $display("[%0t] ERROR: read claimed valid data but ref model is empty!", $time);
                errors++;
            end else begin
                logic [WIDTH-1:0] exp;
                exp = ref_model.pop_front();
                if (rdata !== exp) begin
                    $display("[%0t] ERROR: rdata=%0h expected=%0h", $time, rdata, exp);
                    errors++;
                end
            end
        end
    end

    // ---------------- Read side driver ----------------
    initial begin
        rd_en = 0; rd_rst_n = 0;
        repeat (4) @(posedge rd_clk);
        rd_rst_n = 1;

        // Give the write side a head start so the FIFO has data to drain
        repeat (20) @(posedge rd_clk);

        for (int i = 0; i < 600; i++) begin
            @(negedge rd_clk);
            rd_en = ($urandom_range(0,9) < 6);   // ~60% read attempt rate
        end
        @(negedge rd_clk);
        rd_en = 0;

        // Drain whatever remains
        for (int i = 0; i < 300; i++) begin
            @(negedge rd_clk);
            rd_en = !empty;
        end
        @(negedge rd_clk);
        rd_en = 0;

        repeat (5) @(posedge rd_clk);

        $display("--------------------------------------------------");
        if (errors == 0 && ref_model.size() == 0)
            $display("ASYNC FIFO: ALL %0d CHECKS PASSED (reference model fully drained)", checks);
        else
            $display("ASYNC FIFO: %0d ERRORS out of %0d checks, %0d items left un-drained",
                      errors, checks, ref_model.size());
        $display("--------------------------------------------------");
        #100 $finish;
    end

endmodule
