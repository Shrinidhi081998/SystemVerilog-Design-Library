// =============================================================================
// fixed_priority_arbiter.sv - Fixed-Priority Arbiter
// -----------------------------------------------------------------------------
// N requesters compete for one shared resource. Requester 0 always wins if it
// asks; requester 1 wins only if 0 doesn't ask; and so on down the line. This
// is the simplest possible arbiter -- purely combinational, one-hot grant.
//
// Pros: trivial to implement, zero latency, deterministic.
// Cons: low-priority requesters can be starved forever if a high-priority
//       requester keeps asking. (This is exactly why round_robin_arbiter.sv
//       exists -- see that file for the fairness fix.)
// =============================================================================
module fixed_priority_arbiter #(
    parameter int N = 4                        // number of requesters
) (
    input  logic [N-1:0] req,                  // req[0] = highest priority
    output logic [N-1:0] grant                 // one-hot (or all-zero if no request)
);

    // grant[i] = req[i] AND none of the higher-priority requesters (0..i-1) are asking
    always_comb begin
        grant = '0;
        for (int i = 0; i < N; i++) begin
            if (req[i] && !(|(req & ((1 << i) - 1)))) begin
                grant[i] = 1'b1;
            end
        end
    end

endmodule
