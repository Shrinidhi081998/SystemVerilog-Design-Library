// =============================================================================
// priority_encoder.sv - N-bit Priority Encoder
// =============================================================================
// Encodes the position of the HIGHEST-PRIORITY (lowest-index) set bit.
// Returns: out = binary index of the highest set bit, valid = 1 if any bit set.
// This is the building block inside the fixed_priority_arbiter and many other
// circuits. A synthesis tool will implement this as a cascade of muxes.
// =============================================================================
module priority_encoder #(
    parameter int N  = 8,
    parameter int OW = $clog2(N)   // output width
) (
    input  logic [N-1:0]  in,
    output logic [OW-1:0] out,
    output logic          valid
);
    always_comb begin
        out   = '0;
        valid = |in;
        for (int i = N-1; i >= 0; i--) begin
            if (in[i]) out = OW'(i);
        end
    end
endmodule
