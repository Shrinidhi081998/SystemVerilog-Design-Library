// =============================================================================
// sync_fifo.sv - Parameterized Synchronous FIFO
// -----------------------------------------------------------------------------
// Single clock domain FIFO. Uses the classic "one extra pointer bit" trick to
// tell full apart from empty without a separate counter:
//   - Write and read pointers are (AW+1) bits wide, where AW = log2(DEPTH).
//   - The extra MSB is a "wrap bit" that toggles every time the pointer wraps
//     around the memory array.
//   - EMPTY  : wptr == rptr                      (all bits match, no wrap diff)
//   - FULL   : same lower AW bits (same slot) BUT different wrap bit
//              (writer has lapped the reader exactly once)
// =============================================================================
module sync_fifo #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16                 // must be a power of 2
) (
    input  logic             clk,
    input  logic             rst_n,          // active-low async reset

    input  logic             wr_en,
    input  logic [WIDTH-1:0] wdata,
    output logic             full,

    input  logic             rd_en,
    output logic [WIDTH-1:0] rdata,
    output logic             empty,

    output logic [$clog2(DEPTH):0] fill_count // 0..DEPTH, handy for "almost full" logic
);

    localparam int AW = $clog2(DEPTH);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [AW:0] wptr, rptr;                 // extra MSB = wrap bit

    wire wr_valid = wr_en && !full;
    wire rd_valid = rd_en && !empty;

    // ---------------- Write pointer & memory write ----------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr <= '0;
        end else if (wr_valid) begin
            mem[wptr[AW-1:0]] <= wdata;
            wptr <= wptr + 1'b1;
        end
    end

    // ---------------- Read pointer ----------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rptr <= '0;
        end else if (rd_valid) begin
            rptr <= rptr + 1'b1;
        end
    end

    // Read data: combinational read (data valid same cycle address is presented).
    // For a registered/synchronous-read FIFO you would flop 'rdata' instead.
    assign rdata = mem[rptr[AW-1:0]];

    // ---------------- Status flags ----------------
    assign empty = (wptr == rptr);
    assign full  = (wptr[AW] != rptr[AW]) && (wptr[AW-1:0] == rptr[AW-1:0]);
    assign fill_count = wptr - rptr;         // relies on modulo-2^(AW+1) arithmetic

endmodule
