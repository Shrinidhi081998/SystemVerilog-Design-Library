// =============================================================================
// async_fifo.sv - Dual-Clock (Asynchronous) FIFO
// -----------------------------------------------------------------------------
// The classic Clifford E. Cummings structure. Two separate clock domains
// (write side, read side) exchange pointers safely by:
//   1. Converting binary pointers to GRAY CODE before crossing domains
//      (gray code changes only ONE bit at a time, so a synchronizer can
//       never latch a "half-updated" value that is wildly wrong -- at worst
//       it's off by one, which full/empty logic is built to tolerate).
//   2. Passing the gray pointer through a 2-flip-flop synchronizer in the
//      OTHER clock domain before it's used for full/empty comparison.
//
// FULL  is a REGISTERED flag in the WRITE clock domain, computed by comparing
//       the next write pointer to the synchronized read pointer.
// EMPTY is a REGISTERED flag in the READ clock domain, computed by comparing
//       the next read pointer to the synchronized write pointer.
// (Both are registered rather than purely combinational to avoid a subtle
//  zero-delay combinational-loop bug -- see the comment near 'full' below.)
// =============================================================================
module async_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16                  // must be a power of 2
) (
    // ---------------- write domain ----------------
    input  logic             wr_clk,
    input  logic             wr_rst_n,
    input  logic             wr_en,
    input  logic [WIDTH-1:0] wdata,
    output logic             full,

    // ---------------- read domain ----------------
    input  logic             rd_clk,
    input  logic             rd_rst_n,
    input  logic             rd_en,
    output logic [WIDTH-1:0] rdata,
    output logic             empty
);

    localparam int AW = $clog2(DEPTH);

    logic [WIDTH-1:0] mem [0:DEPTH-1];

    logic [AW:0] wbin, wbin_next, wgray, wgray_next;
    logic [AW:0] rbin, rbin_next, rgray, rgray_next;

    logic [AW:0] wq1_rgray, wq2_rgray;   // read-pointer gray, synced INTO write domain
    logic [AW:0] rq1_wgray, rq2_wgray;   // write-pointer gray, synced INTO read domain

    // =====================================================================
    // WRITE DOMAIN
    // =====================================================================
    // 2-flop synchronizer bringing the read pointer (gray) into wr_clk domain
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) {wq2_rgray, wq1_rgray} <= '0;
        else           {wq2_rgray, wq1_rgray} <= {wq1_rgray, rgray};
    end

    assign wbin_next  = wbin + (wr_en & ~full);
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;      // binary -> gray

    // NOTE ON A CLASSIC PITFALL: it's tempting to write
    //   assign full = (wgray_next == {~wq2_rgray[AW:AW-1], wq2_rgray[AW-2:0]});
    // as a plain continuous assignment. DON'T -- wgray_next depends on
    // wbin_next, which itself depends on full (via "wr_en & ~full"). That
    // makes full a combinational function of itself the instant the FIFO
    // fills up, which is a genuine zero-delay oscillation (full toggles
    // 0/1/0/1... forever within the same time step and hangs the
    // simulator). The fix: register 'full' in the same always_ff as the
    // pointers, so the value used on the right-hand side of wbin_next is
    // always last cycle's stable, already-settled value.
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wbin  <= '0;
            wgray <= '0;
            full  <= 1'b0;
        end else begin
            wbin  <= wbin_next;
            wgray <= wgray_next;
            full  <= (wgray_next == {~wq2_rgray[AW:AW-1], wq2_rgray[AW-2:0]});
        end
    end

    always_ff @(posedge wr_clk) begin
        if (wr_en && !full) mem[wbin[AW-1:0]] <= wdata;
    end

    // =====================================================================
    // READ DOMAIN
    // =====================================================================
    // 2-flop synchronizer bringing the write pointer (gray) into rd_clk domain
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) {rq2_wgray, rq1_wgray} <= '0;
        else           {rq2_wgray, rq1_wgray} <= {rq1_wgray, wgray};
    end

    assign rbin_next  = rbin + (rd_en & ~empty);
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;

    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rbin  <= '0;
            rgray <= '0;
            empty <= 1'b1;
        end else begin
            rbin  <= rbin_next;
            rgray <= rgray_next;
            empty <= (rgray_next == rq2_wgray);
        end
    end

    assign rdata = mem[rbin[AW-1:0]];

endmodule
