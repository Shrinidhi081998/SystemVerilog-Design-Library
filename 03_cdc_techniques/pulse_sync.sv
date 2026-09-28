// =============================================================================
// pulse_sync.sv - Pulse Synchronizer (toggle + 2-flop-sync + edge detect)
// -----------------------------------------------------------------------------
// Problem: a plain 2-flop synchronizer works great for a LEVEL signal, but a
// single-cycle PULSE in a fast clock domain can be completely missed by a
// slower destination clock (it can come and go between two destination edges).
//
// Fix: convert the pulse into a LEVEL change (a toggle flip-flop), synchronize
// that level with an ordinary 2-flop synchronizer (safe, since it's now a
// slowly-changing level, not a pulse), then detect the EDGE of the
// synchronized toggle to regenerate a clean single-cycle pulse in the
// destination clock domain.
//
//   src_pulse ---> [toggle FF] ---> level change ---> [2FF sync] ---> [edge
//   detect] ---> dst_pulse (exactly one dst_clk cycle wide)
//
// Constraint: pulses in the source domain must be spaced at least 2 source
// clock periods apart (must let the toggle flop settle) or they can be
// missed/coalesced -- this synchronizer guarantees every pulse is SEEN, not
// that back-to-back pulses stay distinguishable if they arrive faster than
// the destination can keep up.
// =============================================================================
module pulse_sync (
    input  logic src_clk,
    input  logic src_rst_n,
    input  logic src_pulse,      // single src_clk-cycle pulse to be transferred

    input  logic dst_clk,
    input  logic dst_rst_n,
    output logic dst_pulse       // single dst_clk-cycle pulse, in the destination domain
);

    // ---------------- Source domain: toggle on every pulse ----------------
    logic toggle_ff;
    always_ff @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n) toggle_ff <= 1'b0;
        else if (src_pulse) toggle_ff <= ~toggle_ff;
    end

    // ---------------- Cross to destination domain (safe: it's now a level) ----------------
    logic sync_toggle;
    sync_2ff #(.STAGES(2)) u_sync (
        .clk(dst_clk), .rst_n(dst_rst_n),
        .async_in(toggle_ff), .sync_out(sync_toggle)
    );

    // ---------------- Edge-detect the synchronized toggle to regenerate a pulse ----------------
    logic sync_toggle_d;
    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) sync_toggle_d <= 1'b0;
        else            sync_toggle_d <= sync_toggle;
    end

    assign dst_pulse = sync_toggle ^ sync_toggle_d;   // XOR = "it just changed" = one pulse per toggle edge

endmodule
