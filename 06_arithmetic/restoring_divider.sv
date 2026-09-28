// =============================================================================
// restoring_divider.sv - Sequential Restoring Divider (unsigned)
// =============================================================================
// Implements the classic "restoring division" algorithm, the hardware analog
// of how you learnt long division in school:
//
//   Repeat WIDTH times:
//     1. SHIFT  remainder register left by 1, shifting in the next dividend bit
//     2. SUBTRACT divisor from the partial remainder (trial subtraction)
//     3. CHECK the sign of the result:
//          POSITIVE (or zero) -> quotient bit = 1, KEEP the subtracted value
//          NEGATIVE            -> quotient bit = 0, RESTORE by adding divisor back
//
// After WIDTH steps the quotient has been built LSB-first into the shift
// register and the remainder is in the upper half.
//
// Takes WIDTH+1 cycles per divide (one extra for the initial setup).
// Area: one adder, one subtractor, registers -- much less area than a
// combinational array divider, at the cost of latency.
//
// DIVISION BY ZERO: flagged by div_by_zero output; quotient/remainder undefined.
// =============================================================================
module restoring_divider #(
    parameter int WIDTH = 8
) (
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 start,
    input  logic [WIDTH-1:0]     dividend,
    input  logic [WIDTH-1:0]     divisor,
    output logic [WIDTH-1:0]     quotient,
    output logic [WIDTH-1:0]     remainder,
    output logic                 busy,
    output logic                 done,
    output logic                 div_by_zero
);

    typedef enum logic [1:0] {S_IDLE, S_RUN, S_DONE} state_t;
    state_t state;

    // Partial remainder needs one extra bit (the sign bit from the trial subtract)
    logic [WIDTH:0]          P;           // partial remainder (WIDTH+1 bits)
    logic [WIDTH-1:0]        dvnd_r;      // latched copy of dividend, shifted out bit by bit
    logic [WIDTH-1:0]        dvsr_r;      // latched copy of divisor
    logic [WIDTH-1:0]        quot_r;      // quotient being built (shift register)
    logic [$clog2(WIDTH)-1:0] cnt;

    // Combinational subtract: P - divisor (extended to WIDTH+1 bits)
    wire [WIDTH:0] P_minus_D = P - {1'b0, dvsr_r};

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= S_IDLE;
            P          <= '0;
            dvnd_r     <= '0;
            dvsr_r     <= '0;
            quot_r     <= '0;
            cnt        <= '0;
            done       <= 1'b0;
            div_by_zero <= 1'b0;
        end else begin
            done <= 1'b0;
            case (state)
                S_IDLE: begin
                    if (start) begin
                        if (divisor == '0) begin
                            div_by_zero <= 1'b1;
                            done        <= 1'b1;      // immediately done, with error flag
                        end else begin
                            div_by_zero <= 1'b0;
                            // Initialize: partial remainder P = 0, load dividend
                            P      <= '0;
                            dvnd_r <= dividend;
                            dvsr_r <= divisor;
                            quot_r <= '0;
                            cnt    <= '0;
                            state  <= S_RUN;
                        end
                    end
                end

                S_RUN: begin
                    // Step 1: shift P left by 1, shifting in MSB of dvnd_r
                    // Step 2: trial subtract
                    // Step 3: if no borrow (P_minus_D[WIDTH] == 0), quotient bit = 1 and keep
                    //         else quotient bit = 0 and restore (leave P as the shifted value)
                    logic [WIDTH:0] P_shifted;
                    P_shifted = {P[WIDTH-1:0], dvnd_r[WIDTH-1]};   // shift left, bring in MSB
                    dvnd_r    <= {dvnd_r[WIDTH-2:0], 1'b0};         // shift dividend register left

                    if (P_shifted >= {1'b0, dvsr_r}) begin
                        // No borrow: quotient bit = 1, keep the subtracted value
                        P      <= P_shifted - {1'b0, dvsr_r};
                        quot_r <= {quot_r[WIDTH-2:0], 1'b1};
                    end else begin
                        // Borrow: quotient bit = 0, restore (no actual subtraction kept)
                        P      <= P_shifted;
                        quot_r <= {quot_r[WIDTH-2:0], 1'b0};
                    end

                    if (cnt == WIDTH - 1) state <= S_DONE;
                    else                  cnt   <= cnt + 1'b1;
                end

                S_DONE: begin
                    done  <= 1'b1;
                    state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    assign quotient  = quot_r;
    assign remainder = P[WIDTH-1:0];
    assign busy      = (state != S_IDLE);

endmodule
