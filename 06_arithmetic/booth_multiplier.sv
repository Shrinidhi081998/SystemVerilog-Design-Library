// =============================================================================
// booth_multiplier.sv - Radix-2 Booth Multiplier (signed, 2's complement)
// =============================================================================
// Key implementation note: the partial-sum accumulator A must be WIDTH+1 bits
// (sign-extended) to avoid overflow when the multiplicand is the most-negative
// value (-2^(W-1)). Subtracting that value in 2's complement = adding 2^(W-1),
// which overflows a W-bit signed register. Using W+1 bits accommodates this.
//
// Recoding ({Q[0], Qm1}):
//   00 / 11 -> NOP          (inside a run of 0s or 1s)
//   01      -> A += M       (entering a run of 1s from below)
//   10      -> A -= M       (leaving a run of 1s going above)
// =============================================================================
module booth_multiplier #(
    parameter int WIDTH = 8
) (
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic                      start,
    input  logic signed [WIDTH-1:0]   multiplicand,
    input  logic signed [WIDTH-1:0]   multiplier,
    output logic signed [2*WIDTH-1:0] product,
    output logic                      busy,
    output logic                      done
);
    localparam int AW = WIDTH + 1;   // one extra bit prevents overflow on most-negative M

    typedef enum logic [1:0] {S_IDLE, S_RUN, S_DONE} state_t;
    state_t state;

    logic signed [AW-1:0]          A;    // accumulator: WIDTH+1 bits, sign-extended
    logic [WIDTH-1:0]              Q;    // shift register holding the multiplier bits
    logic                          Qm1;  // previously shifted-out bit
    logic signed [AW-1:0]         M;    // sign-extended multiplicand
    logic [$clog2(WIDTH)-1:0]      cnt;
    logic signed [2*WIDTH-1:0]     product_r;

    // Booth recoding: fully combinational, uses registered A, Q, Qm1, M
    logic signed [AW-1:0]  A_sel;
    logic signed [AW-1:0]  A_next;
    logic [WIDTH-1:0]      Q_next;
    logic                  Qm1_next;

    always_comb begin
        case ({Q[0], Qm1})
            2'b01:   A_sel = A + M;   // start of a run of 1s
            2'b10:   A_sel = A - M;   // end of a run of 1s
            default: A_sel = A;       // NOP
        endcase
        // Arithmetic right shift of the full {A_sel, Q} register by 1
        A_next   = {A_sel[AW-1], A_sel[AW-1:1]};         // sign-extend
        Q_next   = {A_sel[0], Q[WIDTH-1:1]};              // Q MSB <- A_sel LSB
        Qm1_next = Q[0];
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE; A <= '0; Q <= '0; Qm1 <= '0; M <= '0;
            cnt <= '0; done <= 1'b0; product_r <= '0;
        end else begin
            done <= 1'b0;
            case (state)
                S_IDLE: if (start) begin
                    A   <= '0;
                    M   <= {{1{multiplicand[WIDTH-1]}}, multiplicand};  // sign-extend to AW bits
                    Q   <= multiplier;
                    Qm1 <= 1'b0;
                    cnt <= '0;
                    state <= S_RUN;
                end
                S_RUN: begin
                    A   <= A_next;
                    Q   <= Q_next;
                    Qm1 <= Qm1_next;
                    if (cnt == WIDTH - 1) begin
                        // Capture the final product: top AW bits of A_next (drop the sign-extension
                        // extra bit) concatenated with Q_next gives the full 2*WIDTH product.
                        product_r <= {A_next[WIDTH-1:0], Q_next};
                        state <= S_DONE;
                    end else cnt <= cnt + 1'b1;
                end
                S_DONE: begin done <= 1'b1; state <= S_IDLE; end
                default: state <= S_IDLE;
            endcase
        end
    end

    assign product = product_r;
    assign busy    = (state != S_IDLE);
endmodule
