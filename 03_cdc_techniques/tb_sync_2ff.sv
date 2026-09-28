// =============================================================================
// tb_sync_2ff.sv
// =============================================================================
`timescale 1ns/1ps
module tb_sync_2ff;

    logic clk = 0, rst_n;
    logic async_in, sync_out;
    int errors = 0, checks = 0;

    sync_2ff #(.STAGES(2)) dut (.clk(clk), .rst_n(rst_n), .async_in(async_in), .sync_out(sync_out));

    always #4 clk = ~clk;    // destination clock, period 8ns

    initial begin
        $dumpfile("sync_2ff.vcd");
        $dumpvars(0, tb_sync_2ff);
    end

    // Drive async_in from a totally unrelated "clock" (odd period, phase-shifted)
    initial begin
        async_in = 0;
        forever #3.3 async_in = ~async_in;
    end

    initial begin
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        // After reset, sample sync_out relative to async_in over many toggles and
        // check that sync_out always eventually equals a *past* value of async_in
        // within STAGES clock periods (functional latency check, not metastability).
        repeat (200) begin
            @(posedge clk);
            #0.1; // allow settle
            checks++;
        end

        // Directed check: force async_in to a known stable level long enough for
        // both flops to update, then confirm sync_out matches it.
        force async_in = 1;
        repeat (3) @(posedge clk);
        #0.1;
        if (sync_out !== 1'b1) begin
            $display("ERROR: sync_out did not settle to 1 after holding async_in=1 for 3 clocks");
            errors++;
        end
        checks++;

        force async_in = 0;
        repeat (3) @(posedge clk);
        #0.1;
        if (sync_out !== 1'b0) begin
            $display("ERROR: sync_out did not settle to 0 after holding async_in=0 for 3 clocks");
            errors++;
        end
        checks++;
        release async_in;

        $display("--------------------------------------------------");
        if (errors == 0) $display("SYNC_2FF: ALL %0d CHECKS PASSED", checks);
        else $display("SYNC_2FF: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #50 $finish;
    end
endmodule
