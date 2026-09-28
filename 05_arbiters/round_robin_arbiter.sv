// =============================================================================
// round_robin_arbiter.sv - Round-Robin Arbiter
// -----------------------------------------------------------------------------
// Fixes the starvation problem of a fixed-priority arbiter: after granting
// requester K, the priority pointer moves to K+1, so K becomes the LOWEST
// priority requester for the next arbitration. Every requester eventually
// gets a turn as long as it keeps asking -- no one can be starved forever by
// a higher-priority neighbor.
//
// Implementation trick: rather than writing separate "wrap-around priority"
// logic, we DOUBLE the request vector (concatenate req with itself) and scan
// a WINDOW of N consecutive bits starting at the pointer's position. The
// first requester found scanning left-to-right through that window wins.
// Because the vector is doubled, the window can "wrap past bit N-1 back to
// bit 0" for free, without any special-case wrap-around code.
// =============================================================================
module round_robin_arbiter #(
    parameter int N = 4
) (
    input  logic          clk,
    input  logic          rst_n,
    input  logic [N-1:0]  req,
    output logic [N-1:0]  grant                // one-hot (or all-zero if no request)
);

    localparam int PW = (N <= 1) ? 1 : $clog2(N);

    logic [PW-1:0] ptr;             // "highest priority this round" pointer (0..N-1)
    logic [2*N-1:0] req_double;     // req concatenated with itself
    logic [2*N-1:0] grant_double;
    logic [PW-1:0] winner_pos;
    logic          any_grant;

    assign req_double = {req, req};

    // Scan the window [ptr, ptr+N) left to right; the FIRST requester found
    // asking wins. 'found' stops us granting more than one bit.
    always @(*) begin
        grant_double = '0;
        winner_pos   = ptr;
        any_grant    = 1'b0;
        for (int i = 0; i < 2*N; i++) begin
            if (!any_grant && i >= ptr && i < ptr + N && req_double[i]) begin
                grant_double[i] = 1'b1;
                winner_pos      = i % N;
                any_grant       = 1'b1;
            end
        end
    end

    // Fold the doubled grant vector back down to N bits (bit i and bit i+N
    // represent the same physical requester; only one of the two is ever set)
    assign grant = grant_double[N-1:0] | grant_double[2*N-1:N];

    // Advance the pointer to (winner + 1) so the winner becomes lowest
    // priority next time. If nobody won (no requests), pointer holds.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)          ptr <= '0;
        else if (any_grant)  ptr <= (winner_pos + 1'b1) % N;
    end

endmodule
