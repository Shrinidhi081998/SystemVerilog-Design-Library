// =============================================================================
// tb_pulse_sync.sv
// =============================================================================
`timescale 1ns/1ps
module tb_pulse_sync;

    logic src_clk = 0, dst_clk = 0;
    logic src_rst_n, dst_rst_n;
    logic src_pulse, dst_pulse;

    int src_pulse_count = 0;
    int dst_pulse_count = 0;

    pulse_sync dut (
        .src_clk(src_clk), .src_rst_n(src_rst_n), .src_pulse(src_pulse),
        .dst_clk(dst_clk), .dst_rst_n(dst_rst_n), .dst_pulse(dst_pulse)
    );

    always #2.5 src_clk = ~src_clk;   // fast domain, 5ns period
    always #9.0 dst_clk = ~dst_clk;   // slow domain, 18ns period

    initial begin
        $dumpfile("pulse_sync.vcd");
        $dumpvars(0, tb_pulse_sync);
    end

    // Count pulses seen on each side
    always @(posedge src_clk) if (src_rst_n && src_pulse) src_pulse_count++;
    always @(posedge dst_clk) if (dst_rst_n && dst_pulse) dst_pulse_count++;

    initial begin
        src_pulse = 0;
        src_rst_n = 0; dst_rst_n = 0;
        repeat (3) @(posedge src_clk);
        repeat (3) @(posedge dst_clk);
        src_rst_n = 1; dst_rst_n = 1;
        @(posedge src_clk);

        // Send 15 well-spaced pulses (spaced >= 4 src clocks apart, safely
        // obeying the "let the toggle settle" constraint). Framing the pulse
        // between two negedges guarantees it is stable across exactly one
        // posedge, with no race against the posedge-triggered counter below.
        for (int i = 0; i < 15; i++) begin
            @(negedge src_clk);
            src_pulse = 1;
            @(negedge src_clk);
            src_pulse = 0;
            repeat (4) @(posedge src_clk);   // gap between pulses
        end

        // Let the last pulse fully propagate through the synchronizer
        repeat (10) @(posedge dst_clk);

        $display("--------------------------------------------------");
        $display("PULSE_SYNC: src_pulse_count=%0d dst_pulse_count=%0d", src_pulse_count, dst_pulse_count);
        if (src_pulse_count == dst_pulse_count && src_pulse_count == 15)
            $display("PULSE_SYNC: ALL PULSES CORRECTLY TRANSFERRED (PASS)");
        else
            $display("PULSE_SYNC: MISMATCH -- FAIL");
        $display("--------------------------------------------------");
        #100 $finish;
    end
endmodule
