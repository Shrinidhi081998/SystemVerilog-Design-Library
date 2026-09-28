// =============================================================================
// ripple_carry_adder.sv - N-bit Ripple Carry Adder (built from full adders)
// -----------------------------------------------------------------------------
// The most fundamental arithmetic building block. Each bit position has a
// FULL ADDER that adds two bits plus an incoming carry, producing a sum bit
// and an outgoing carry. The carries "ripple" from LSB to MSB -- bit i can't
// compute its result until bit i-1's carry is ready.
//
// This is why it's called "ripple carry": worst-case delay grows LINEARLY
// with width (the carry has to propagate through every single bit), which is
// exactly the motivation for carry_lookahead_adder.sv (faster, more logic).
// =============================================================================

// ---- Single-bit full adder: the atomic building block ----
module full_adder (
    input  logic a, b, cin,
    output logic sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// ---- N-bit ripple carry adder, built by chaining full adders ----
module ripple_carry_adder #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);

    logic [WIDTH:0] carry;     // carry[0] = cin, carry[WIDTH] = final cout
    assign carry[0] = cin;
    assign cout     = carry[WIDTH];

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_fa
            full_adder u_fa (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i]),
                .sum  (sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate

endmodule
