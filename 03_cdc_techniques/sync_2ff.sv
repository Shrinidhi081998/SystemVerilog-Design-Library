// =============================================================================
// sync_2ff.sv - Two-Flip-Flop Synchronizer
// -----------------------------------------------------------------------------
// The most basic CDC (Clock Domain Crossing) primitive. Used to bring a
// SINGLE-BIT, SLOWLY-CHANGING (relative to the destination clock) signal
// safely into a new clock domain.
//
// Why 2 flops and not 1? A single flop sampling an asynchronous input can go
// METASTABLE (its output hovers between 0 and 1 for an unbounded time) if the
// input changes right at the sampling clock edge. The first flop is allowed
// to go metastable; giving it a full clock period to resolve before the
// SECOND flop samples it makes the probability of the metastability
// propagating any further astronomically small (this is the "MTBF" -- Mean
// Time Between Failures -- calculation every CDC checklist references).
//
// Rules this module follows (and any real synchronizer must follow):
//   1. Only ONE bit crosses per synchronizer instance (multi-bit buses need
//      gray coding or a handshake -- see async_fifo.sv / handshake_sync.sv).
//   2. No combinational logic on the signal between the two flops.
//   3. The source flop's output is never touched by anything else "along
//      the way" (no fan-out taps between ff1 and ff2).
// =============================================================================
module sync_2ff #(
    parameter int STAGES = 2                  // 2 is the common minimum; 3 for very high-speed/noisy designs
) (
    input  logic clk,        // destination clock domain
    input  logic rst_n,
    input  logic async_in,   // signal coming from another (or asynchronous) clock domain
    output logic sync_out
);

    (* ASYNC_REG = "TRUE" *)                  // synthesis attribute: tells the tool to place these flops
    logic [STAGES-1:0] sync_ff;               // close together and not optimize/retime them

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) sync_ff <= '0;
        else        sync_ff <= {sync_ff[STAGES-2:0], async_in};
    end

    assign sync_out = sync_ff[STAGES-1];

endmodule
