// =============================================================================
// traffic_light_fsm.sv - Moore FSM: 3-phase traffic light controller
// =============================================================================
// A classic FSM interview example. Moore FSM: outputs depend only on STATE.
// States: GREEN -> YELLOW -> RED -> GREEN (with configurable hold times).
//
// The MOORE FSM has 3 distinct states; outputs are purely a function of state.
// The MEALY FSM variant (shown below as comments) has outputs that also depend
// on inputs -- it can respond one cycle faster but is harder to reason about.
// =============================================================================
module traffic_light_fsm #(
    parameter int GREEN_TIME  = 10,
    parameter int YELLOW_TIME = 3,
    parameter int RED_TIME    = 10
) (
    input  logic clk, rst_n,
    output logic red, yellow, green
);
    typedef enum logic [1:0] {S_GREEN, S_YELLOW, S_RED} state_t;
    state_t state;

    logic [$clog2(RED_TIME+1)-1:0] cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_GREEN;
            cnt   <= '0;
        end else begin
            cnt <= cnt + 1'b1;
            case (state)
                S_GREEN: if (cnt == GREEN_TIME - 1) begin
                    state <= S_YELLOW; cnt <= '0;
                end
                S_YELLOW: if (cnt == YELLOW_TIME - 1) begin
                    state <= S_RED;    cnt <= '0;
                end
                S_RED: if (cnt == RED_TIME - 1) begin
                    state <= S_GREEN;  cnt <= '0;
                end
                default: state <= S_GREEN;
            endcase
        end
    end

    // Moore outputs: depend only on state
    assign green  = (state == S_GREEN);
    assign yellow = (state == S_YELLOW);
    assign red    = (state == S_RED);

endmodule

// =============================================================================
// sequence_detector.sv - Mealy FSM: detects "1011" sequence
// =============================================================================
// A Mealy FSM: output depends on BOTH current state AND current inputs.
// Classic interview question. Overlapping sequences: after 1011, if the
// next input is 1, that's the start of a new potential 1011.
// =============================================================================
module sequence_detector_1011 (
    input  logic clk, rst_n,
    input  logic din,       // serial bit stream
    output logic detected   // 1 for one cycle when "1011" is detected (Mealy: same cycle as last bit)
);
    typedef enum logic [1:0] {S0, S1, S2, S3} state_t;
    state_t state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else case (state)
            S0: state <= din ? S1 : S0;   // waiting for first '1'
            S1: state <= din ? S1 : S2;   // got '1', waiting for '0'
            S2: state <= din ? S3 : S0;   // got '10', waiting for '1'
            S3: state <= din ? S1 : S2;   // got '101', waiting for '1'; if '0' -> S2 (overlap)
            default: state <= S0;
        endcase
    end

    // Mealy output: valid SAME cycle we get the final '1' in S3
    assign detected = (state == S3) && din;

endmodule
