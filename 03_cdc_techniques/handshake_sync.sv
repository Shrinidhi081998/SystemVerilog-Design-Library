// =============================================================================
// handshake_sync.sv - 4-Phase Handshake CDC Synchronizer (multi-bit data)
// -----------------------------------------------------------------------------
// Problem: a 2-flop synchronizer only safely moves ONE bit. A pulse
// synchronizer only moves a single-cycle event. Neither is safe for a whole
// multi-bit DATA BUS, because different bits could be sampled on different
// sides of a destination clock edge (bits arrive skewed), corrupting the word.
//
// Fix: a REQ/ACK handshake.
//   1. Source loads 'data' onto a bus that it holds STABLE, then raises REQ.
//   2. REQ is synchronized into the destination domain (safe -- it's a level).
//   3. Destination sees synchronized REQ, captures 'data' (which has been
//      stable for a while now, so no skew risk), then raises ACK.
//   4. ACK is synchronized back into the source domain.
//   5. Source sees synchronized ACK, drops REQ (and may then change 'data').
//   6. Destination sees synchronized REQ fall, drops ACK. Ready for the next
//      transfer.
// This is slow (several clock round trips per word) but is bulletproof --
// exactly the same idea used by the async FIFO's pointer synchronization,
// generalized to arbitrary data width.
// =============================================================================
module handshake_sync #(
    parameter int WIDTH = 16
) (
    // ---------------- source domain ----------------
    input  logic             src_clk,
    input  logic             src_rst_n,
    input  logic             src_valid,     // "I have new data" pulse or level
    input  logic [WIDTH-1:0] src_data,
    output logic             src_busy,      // "don't give me new data yet"

    // ---------------- destination domain ----------------
    input  logic             dst_clk,
    input  logic             dst_rst_n,
    output logic             dst_valid,     // one dst_clk-cycle pulse: "here's a new word"
    output logic [WIDTH-1:0] dst_data
);

    // ---------------- Internal signals (declared up front to avoid forward-reference issues) ----------------
    typedef enum logic [1:0] {S_IDLE, S_REQ, S_WAIT_ACK, S_DONE} src_state_t;
    typedef enum logic [1:0] {D_IDLE, D_CAPTURE, D_ACK_HIGH} dst_state_t;

    src_state_t src_state;
    dst_state_t dst_state;

    logic req_ff;                  // source: "request" level, toggled/held while a transfer is in flight
    logic ack_ff;                  // destination: "acknowledge" level
    logic [WIDTH-1:0] data_hold;   // source: data held stable for the whole handshake
    logic req_sync;                // req_ff synchronized into the destination clock domain
    logic ack_sync;                // ack_ff synchronized into the source clock domain
    logic dst_valid_r;

    sync_2ff u_sync_ack (.clk(src_clk), .rst_n(src_rst_n), .async_in(ack_ff), .sync_out(ack_sync));
    sync_2ff u_sync_req (.clk(dst_clk), .rst_n(dst_rst_n), .async_in(req_ff), .sync_out(req_sync));

    assign src_busy = (src_state != S_IDLE);

    always_ff @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n) begin
            src_state <= S_IDLE;
            req_ff    <= 1'b0;
            data_hold <= '0;
        end else begin
            case (src_state)
                S_IDLE: begin
                    if (src_valid) begin
                        data_hold <= src_data;   // latch and HOLD stable for the whole handshake
                        req_ff    <= 1'b1;
                        src_state <= S_WAIT_ACK;
                    end
                end
                S_WAIT_ACK: begin
                    if (ack_sync) begin          // destination has captured the data
                        req_ff    <= 1'b0;
                        src_state <= S_DONE;
                    end
                end
                S_DONE: begin
                    if (!ack_sync) begin         // destination has seen REQ fall, dropped ACK
                        src_state <= S_IDLE;
                    end
                end
                default: src_state <= S_IDLE;
            endcase
        end
    end

    // ---------------- Destination-side FSM ----------------

    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            dst_state   <= D_IDLE;
            ack_ff      <= 1'b0;
            dst_data    <= '0;
            dst_valid_r <= 1'b0;
        end else begin
            dst_valid_r <= 1'b0;
            case (dst_state)
                D_IDLE: begin
                    if (req_sync) begin
                        dst_data    <= data_hold;   // safe: data_hold has been stable for >=1 full src period
                        dst_valid_r <= 1'b1;        // pulse: "new word captured"
                        ack_ff      <= 1'b1;
                        dst_state   <= D_ACK_HIGH;
                    end
                end
                D_ACK_HIGH: begin
                    if (!req_sync) begin            // source saw our ACK and dropped REQ
                        ack_ff    <= 1'b0;
                        dst_state <= D_IDLE;
                    end
                end
                default: dst_state <= D_IDLE;
            endcase
        end
    end

    assign dst_valid = dst_valid_r;

endmodule
