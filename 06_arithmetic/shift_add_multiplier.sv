// =============================================================================
// shift_add_multiplier.sv - Sequential Shift-and-Add Multiplier (unsigned)
// =============================================================================
// For an N-bit * N-bit unsigned multiply the accumulator needs 2N bits.
// Each step: add multiplicand (scaled) to upper N bits, then right-shift the
// full 2N-bit register.  The key fix vs a naive implementation: the adder
// producing 'upper_new' must use N+1 bits to capture the carry-out from the
// upper-half add before the shift folds it back in.
// =============================================================================
module shift_add_multiplier #(
    parameter int WIDTH = 8
) (
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   start,
    input  logic [WIDTH-1:0]       multiplicand,
    input  logic [WIDTH-1:0]       multiplier,
    output logic [2*WIDTH-1:0]     product,
    output logic                   busy,
    output logic                   done
);
    localparam int W2 = 2 * WIDTH;

    typedef enum logic [1:0] {S_IDLE, S_RUN, S_DONE} state_t;
    state_t state;

    logic [$clog2(WIDTH)-1:0] cnt;
    logic [W2-1:0]            acc;
    logic [WIDTH-1:0]         mcand_r;

    // N+1 bit adder so we never lose the carry out of the upper half
    logic [WIDTH:0] upper_sum;   // one extra bit for carry

    assign upper_sum = {1'b0, acc[W2-1:WIDTH]} + (acc[0] ? {1'b0, mcand_r} : {(WIDTH+1){1'b0}});
    // Shift right: carry-out of the adder becomes the new MSB of the 2N-bit register
    wire [W2-1:0] acc_next = {upper_sum[WIDTH], upper_sum[WIDTH-1:0], acc[WIDTH-1:1]};

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE; acc <= '0; mcand_r <= '0; cnt <= '0; done <= 1'b0;
        end else begin
            done <= 1'b0;
            case (state)
                S_IDLE: if (start) begin
                    acc     <= {{WIDTH{1'b0}}, multiplier};
                    mcand_r <= multiplicand;
                    cnt     <= '0;
                    state   <= S_RUN;
                end
                S_RUN: begin
                    acc <= acc_next;
                    if (cnt == WIDTH - 1) state <= S_DONE;
                    else                  cnt   <= cnt + 1'b1;
                end
                S_DONE: begin done <= 1'b1; state <= S_IDLE; end
                default: state <= S_IDLE;
            endcase
        end
    end

    assign product = acc;
    assign busy    = (state != S_IDLE);
endmodule
