// =============================================================================
// tb_adders_wave.sv - Small curated-vector run of the adders, just to produce
// a clean, human-readable VCD (the exhaustive tb_adders.sv proves correctness
// but its VCD is far too large to be useful in a waveform viewer).
// =============================================================================
`timescale 1ns/1ps
module tb_adders_wave;

    localparam int WIDTH = 8;
    logic [WIDTH-1:0] a, b, sum_rca, sum_cla;
    logic cin, cout_rca, cout_cla;
    logic clk = 0;

    ripple_carry_adder #(.WIDTH(WIDTH)) u_rca (.a(a), .b(b), .cin(cin), .sum(sum_rca), .cout(cout_rca));
    carry_lookahead_adder #(.WIDTH(WIDTH)) u_cla (.a(a), .b(b), .cin(cin), .sum(sum_cla), .cout(cout_cla));

    always #5 clk = ~clk;   // free-running clock purely to give the waveform a readable time grid

    initial begin
        $dumpfile("adders.vcd");
        $dumpvars(0, tb_adders_wave);
    end

    initial begin
        a = 0; b = 0; cin = 0;
        @(posedge clk); a = 8'd15;  b = 8'd10;  cin = 0;   // simple case
        @(posedge clk); a = 8'd200; b = 8'd100; cin = 0;   // sum overflows 8 bits -> cout=1
        @(posedge clk); a = 8'd255; b = 8'd1;   cin = 0;   // max value + 1 -> wraps to 0, cout=1
        @(posedge clk); a = 8'd128; b = 8'd127; cin = 1;   // exercise cin
        @(posedge clk); a = 8'd0;   b = 8'd0;   cin = 1;   // minimal case with carry-in
        @(posedge clk); a = 8'd85;  b = 8'd170; cin = 0;   // alternating bit patterns (0x55 + 0xAA)
        @(posedge clk); a = 8'd255; b = 8'd255; cin = 1;   // worst-case ripple: all bits toggle
        @(posedge clk);
        @(posedge clk);
        $display("Waveform demo complete (see adders.vcd)");
        $finish;
    end
endmodule
