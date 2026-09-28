// =============================================================================
// register_file.sv - Parameterized Register File (multi-read, single-write)
// =============================================================================
// A register file is just an array of registers with dedicated read and write
// ports. In a CPU datapath, the ALU reads two source registers simultaneously
// (two read ports) and writes the result back (one write port).
// This implementation: NREGS registers, WIDTH bits wide, NREAD read ports.
//
// WRITE-FIRST vs READ-FIRST is a common interview topic:
//   - WRITE-FIRST (implemented here): if you write and read the same address
//     in the same cycle, the read returns the NEW (just-written) value.
//   - READ-FIRST: read returns the OLD value before the write takes effect.
// =============================================================================
module register_file #(
    parameter int WIDTH  = 32,
    parameter int NREGS  = 16,
    parameter int NREAD  = 2,
    parameter int ADDRBITS = $clog2(NREGS)
) (
    input  logic                      clk, rst_n,

    // Write port
    input  logic                      wr_en,
    input  logic [ADDRBITS-1:0]       wr_addr,
    input  logic [WIDTH-1:0]          wr_data,

    // Read ports (combinational read, write-first behavior)
    input  logic [NREAD-1:0][ADDRBITS-1:0] rd_addr,
    output logic [NREAD-1:0][WIDTH-1:0]    rd_data
);
    logic [WIDTH-1:0] regs [0:NREGS-1];

    // Synchronous write
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < NREGS; i++) regs[i] <= '0;
        end else if (wr_en) begin
            regs[wr_addr] <= wr_data;
        end
    end

    // Combinational read (write-first: bypass write data if addresses match)
    always_comb begin
        for (int p = 0; p < NREAD; p++) begin
            if (wr_en && rd_addr[p] == wr_addr)
                rd_data[p] = wr_data;       // write-first bypass
            else
                rd_data[p] = regs[rd_addr[p]];
        end
    end

endmodule
