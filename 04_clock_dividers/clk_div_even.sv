// =============================================================================
// clk_div_even.sv - Clock Divider for EVEN divide ratios (50% duty cycle)
// -----------------------------------------------------------------------------
// For an even divisor N, a single counter that toggles the output every N/2
// input clock cycles gives a perfect 50% duty cycle output at f_in / N.
//
// Example: N=4 -> count 0,1 with clk_out=0, then 2,3 with clk_out=1, repeat.
// This is the simplest possible clock divider and is fully synchronous.
//
// NOTE: this produces a DIVIDED CLOCK, i.e. a new clock domain. In real ASIC
// design you would typically prefer a "clock enable" pulse gating logic on
// the ORIGINAL fast clock (so all logic stays on one clock tree) rather than
// physically dividing the clock, specifically to avoid clock-tree/skew
// headaches. This module is presented both ways: clk_out (divided clock,
// for teaching / simple FPGA use) and enable_out (a clock-enable pulse,
// asserted for exactly one f_in cycle at the divided-clock rate -- the
// ASIC-friendly version).
// =============================================================================
module clk_div_even #(
    parameter int DIV = 4                      // must be even and >= 2
) (
    input  logic clk_in,
    input  logic rst_n,
    output logic clk_out,       // divided clock, 50% duty cycle, frequency = f(clk_in)/DIV
    output logic enable_out     // ASIC-friendly alternative: 1-cycle-wide pulse at the divided rate
);

    localparam int HALF = DIV / 2;
    localparam int CW   = $clog2(HALF);

    logic [CW-1:0] count;

    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            count   <= '0;
            clk_out <= 1'b0;
        end else begin
            if (count == HALF - 1) begin
                count   <= '0;
                clk_out <= ~clk_out;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    // enable_out: pulses for exactly one clk_in cycle, once per full DIV period
    // (aligned to the rising edge of clk_out, i.e. once every DIV input cycles)
    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) enable_out <= 1'b0;
        else        enable_out <= (count == HALF - 1) && !clk_out;
    end

endmodule
