// =============================================================================
// carry_lookahead_adder.sv - 4-bit Carry Lookahead Adder (CLA), cascadable
// -----------------------------------------------------------------------------
// Speeds up addition by computing all the carries directly from the inputs,
// in parallel, instead of waiting for them to ripple bit by bit.
//
// For each bit i, define:
//   Gi (GENERATE) = ai & bi         -- this bit position generates a carry
//                                       on its own, regardless of incoming carry
//   Pi (PROPAGATE) = ai ^ bi        -- this bit position passes an incoming
//                                       carry through if one arrives
// Then every carry can be written directly in terms of the inputs and cin,
// with no dependency chain:
//   C1 = G0 + P0.C0
//   C2 = G1 + P1.G0 + P1.P0.C0
//   C3 = G2 + P2.G1 + P2.P1.G0 + P2.P1.P0.C0
//   C4 = G3 + P3.G2 + P3.P2.G1 + P3.P2.P1.G0 + P3.P2.P1.P0.C0
// Each Ci is now only "2 gate delays" deep (AND-OR), independent of width,
// instead of growing linearly like a ripple carry chain. Real ASIC adders
// build wide adders out of 4-bit (or wider) CLA blocks, sometimes with
// another layer of lookahead across the blocks themselves ("carry lookahead
// generator" trees) for even more speed.
// =============================================================================
module carry_lookahead_adder_4bit (
    input  logic [3:0] a, b,
    input  logic       cin,
    output logic [3:0] sum,
    output logic       cout
);

    logic [3:0] g, p;          // generate / propagate per bit
    logic [4:0] c;             // c[0]=cin ... c[4]=cout

    assign g = a & b;
    assign p = a ^ b;
    assign c[0] = cin;

    // Direct lookahead equations (no dependency chain -- all computed "in parallel")
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum  = p ^ c[3:0];   // sum[i] = p[i] ^ c[i]  (same identity as full adder: a^b^cin)
    assign cout = c[4];

endmodule

// ---- Wider adder built by cascading 4-bit CLA blocks (ripple BETWEEN blocks,
//      but lookahead WITHIN each block -- a common real-world compromise) ----
module carry_lookahead_adder #(
    parameter int WIDTH = 16               // must be a multiple of 4
) (
    input  logic [WIDTH-1:0] a, b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);
    localparam int NBLOCKS = WIDTH / 4;
    logic [NBLOCKS:0] block_carry;
    assign block_carry[0] = cin;
    assign cout = block_carry[NBLOCKS];

    genvar i;
    generate
        for (i = 0; i < NBLOCKS; i++) begin : gen_cla_block
            carry_lookahead_adder_4bit u_block (
                .a    (a[i*4 +: 4]),
                .b    (b[i*4 +: 4]),
                .cin  (block_carry[i]),
                .sum  (sum[i*4 +: 4]),
                .cout (block_carry[i+1])
            );
        end
    endgenerate
endmodule
