// =============================================================================
// clk_div_odd.sv - Clock Divider for ODD divide ratios (50% duty cycle)
// -----------------------------------------------------------------------------
// Dividing by an ODD number and still getting a clean 50% duty cycle is a
// classic ASIC/FPGA interview question, because the "obvious" single-counter
// approach (toggle at N/2) doesn't work when N/2 isn't a whole number.
//
// THE TRICK: use TWO counters counting the same modulus N -- one clocked on
// the POSEDGE of clk_in, one on the NEGEDGE -- so they are naturally offset
// from each other by exactly half an input clock period. Each counter drives
// a "high for the first half of the count" signal (using H = (N+1)/2, the
// same threshold for both). ANDing the two signals together yields an output
// that is high for exactly N/2 input-clock-periods' worth of time and low for
// the other half -- i.e. a mathematically perfect 50% duty cycle -- even
// though N itself is odd.
//
// Worked example for DIV=3 (H=2):
//   cnt_p (posedge):  0   1   2   0   1   2  ...
//   tmp1 = cnt_p<2:   1   1   0   1   1   0  ...
//   cnt_n (negedge, offset by half a cycle from cnt_p): ... 0  1  2  0 ...
//   tmp2 = cnt_n<2:      1     1     0     1  ...
//   clk_out = tmp1 & tmp2 ends up high for exactly 1.5 input periods and low
//   for exactly 1.5 input periods out of every 3-period cycle -- 50% duty.
// =============================================================================
module clk_div_odd #(
    parameter int DIV = 3                      // must be odd and >= 3
) (
    input  logic clk_in,
    input  logic rst_n,
    output logic clk_out
);

    localparam int H  = (DIV + 1) / 2;         // ceil(DIV/2)
    localparam int CW = $clog2(DIV);

    logic [CW-1:0] cnt_p;   // counts on the rising edge of clk_in
    logic [CW-1:0] cnt_n;   // counts on the falling edge of clk_in (naturally half-period offset)
    logic tmp1, tmp2;

    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n)                cnt_p <= '0;
        else if (cnt_p == DIV - 1) cnt_p <= '0;
        else                       cnt_p <= cnt_p + 1'b1;
    end

    always_ff @(negedge clk_in or negedge rst_n) begin
        if (!rst_n)                cnt_n <= '0;
        else if (cnt_n == DIV - 1) cnt_n <= '0;
        else                       cnt_n <= cnt_n + 1'b1;
    end

    assign tmp1    = (cnt_p < H);
    assign tmp2    = (cnt_n < H);
    assign clk_out = tmp1 & tmp2;

endmodule
