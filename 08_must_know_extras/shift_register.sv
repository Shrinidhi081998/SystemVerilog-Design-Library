// =============================================================================
// shift_register.sv - SIPO / PISO / PIPO with configurable modes
// =============================================================================
// mode[1:0]:
//   00 - HOLD   : output holds current value
//   01 - SHIFT  : serial shift (SIPO / PISO depending on which port you read)
//   10 - LOAD   : parallel load
//   11 - RESET  : synchronous reset to 0
// The same physical shift register can be used as:
//   SIPO: mode=SHIFT, read parallel out
//   PISO: mode=LOAD to load, then mode=SHIFT to clock bits out serially
// =============================================================================
module shift_register #(
    parameter int WIDTH = 8
) (
    input  logic             clk, rst_n,
    input  logic [1:0]       mode,       // 00=HOLD 01=SHIFT 10=LOAD 11=RST
    input  logic             sin,        // serial input (MSB shifts in)
    input  logic [WIDTH-1:0] par_in,     // parallel load input
    output logic             sout,       // serial output = MSB (for PISO)
    output logic [WIDTH-1:0] par_out     // parallel output (for SIPO)
);
    logic [WIDTH-1:0] reg_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) reg_r <= '0;
        else case (mode)
            2'b11: reg_r <= '0;                               // reset
            2'b10: reg_r <= par_in;                           // parallel load
            2'b01: reg_r <= {reg_r[WIDTH-2:0], sin};         // shift left: MSB out, sin in at LSB
            default: reg_r <= reg_r;                          // hold
        endcase
    end

    assign par_out = reg_r;
    assign sout    = reg_r[WIDTH-1];

endmodule
