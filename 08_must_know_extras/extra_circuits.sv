// =============================================================================
// gray_counter.sv  - N-bit Gray code counter
// =============================================================================
// Output changes only ONE BIT at a time on every clock edge, unlike a binary
// counter where multiple bits can flip simultaneously. This makes gray counters
// ideal for CDC: even if a synchronizer latches the counter mid-transition,
// it captures either the old or new value (never a garbage in-between value).
// Used in: async FIFO pointer generation, rotary encoder decoding, angle sensors.
// =============================================================================
module gray_counter #(parameter int WIDTH = 4) (
    input  logic             clk, rst_n,
    input  logic             en,          // count enable
    output logic [WIDTH-1:0] gray_out,    // gray-encoded count
    output logic [WIDTH-1:0] bin_out      // binary count (for memory addressing)
);
    logic [WIDTH-1:0] bin_r;
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) bin_r <= '0;
        else if (en) bin_r <= bin_r + 1'b1;

    assign bin_out  = bin_r;
    assign gray_out = (bin_r >> 1) ^ bin_r;   // standard binary-to-gray
endmodule

// =============================================================================
// lfsr.sv  - Linear Feedback Shift Register (Fibonacci LFSR)
// =============================================================================
// An LFSR generates a pseudo-random sequence by XOR-ing selected bits (taps)
// back into the shift register. A maximal-length LFSR with N bits cycles
// through 2^N - 1 states before repeating (all states except all-zeros).
// Uses: PRBS test patterns, scrambling, CRC calculation, simple RNG.
//
// Tap polynomial for WIDTH=8: x^8 + x^6 + x^5 + x^4 + 1
// (standard maximal-length polynomial; see table in Xilinx XAPP052)
// =============================================================================
module lfsr #(parameter int WIDTH = 8) (
    input  logic             clk, rst_n,
    input  logic             en,
    input  logic [WIDTH-1:0] seed,        // load a non-zero seed value
    input  logic             load,        // 1 = load seed this cycle
    output logic [WIDTH-1:0] data_out,
    output logic             prbs_bit     // single-bit pseudo-random output
);
    logic [WIDTH-1:0] lfsr_r;

    // Fibonacci LFSR: feedback = XOR of tap positions, fed to MSB
    // Tap polynomial for 8-bit: positions 8,6,5,4 (1-indexed) = bits 7,5,4,3 (0-indexed)
    wire feedback = lfsr_r[7] ^ lfsr_r[5] ^ lfsr_r[4] ^ lfsr_r[3];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)        lfsr_r <= 8'h01;         // non-zero default seed
        else if (load)     lfsr_r <= (seed == '0) ? 8'h01 : seed;
        else if (en)       lfsr_r <= {lfsr_r[WIDTH-2:0], feedback};
    end

    assign data_out  = lfsr_r;
    assign prbs_bit  = lfsr_r[WIDTH-1];
endmodule

// =============================================================================
// barrel_shifter.sv  - Parameterized Barrel Shifter (logical left/right)
// =============================================================================
// A barrel shifter shifts DATA by SHAMT positions in O(log2 N) gate stages
// using a cascade of conditional-shift muxes (not a chain of 1-bit shifts).
// Shift directions: LEFT (multiply by 2^shamt), RIGHT logical (divide unsigned),
// Right arithmetic (divide signed, preserving sign bit).
// =============================================================================
module barrel_shifter #(parameter int WIDTH = 8) (
    input  logic [WIDTH-1:0]         data_in,
    input  logic [$clog2(WIDTH)-1:0] shamt,   // shift amount
    input  logic [1:0]               mode,    // 00=SHL 01=SHR_L 10=SHR_A
    output logic [WIDTH-1:0]         data_out
);
    always_comb begin
        case (mode)
            2'b00:   data_out = data_in  <<  shamt;    // logical left
            2'b01:   data_out = data_in  >>  shamt;    // logical right
            2'b10:   data_out = $signed(data_in) >>> shamt; // arithmetic right
            default: data_out = data_in;
        endcase
    end
endmodule

// =============================================================================
// pwm.sv  - Pulse-Width Modulator
// =============================================================================
// A PWM output is HIGH for DUTY out of every PERIOD clock cycles, producing
// an average voltage of (DUTY/PERIOD)*VDD. Used for motor speed control,
// LED dimming, DAC-less analog output, servo control.
// The duty cycle is a runtime-configurable input (not a parameter).
// =============================================================================
module pwm #(parameter int CWIDTH = 8) (   // counter width; max period = 2^CWIDTH
    input  logic             clk, rst_n,
    input  logic [CWIDTH-1:0] period,    // total period in clock cycles (e.g. 255)
    input  logic [CWIDTH-1:0] duty,      // high-time in clocks (0 = always low, period = always high)
    output logic             pwm_out
);
    logic [CWIDTH-1:0] cnt;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)              cnt <= '0;
        else if (cnt >= period)  cnt <= '0;
        else                     cnt <= cnt + 1'b1;
    end
    assign pwm_out = (cnt < duty);
endmodule

// =============================================================================
// debouncer.sv  - Switch / GPIO Debouncer (counter-based)
// =============================================================================
// Mechanical switches bounce (oscillate between 0 and 1) for up to ~10ms on
// press/release. The debouncer filters this by requiring the input to be
// STABLE for STABLE_COUNT consecutive clock cycles before the output changes.
// =============================================================================
module debouncer #(
    parameter int STABLE_COUNT = 1000   // e.g. 10ms at 100kHz = 1000 cycles
) (
    input  logic clk, rst_n,
    input  logic noisy_in,
    output logic clean_out
);
    localparam int CW = $clog2(STABLE_COUNT+1);
    logic [CW-1:0] cnt;
    logic last_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= '0; last_in <= 1'b0; clean_out <= 1'b0;
        end else begin
            if (noisy_in != last_in) begin
                // Input changed: reset the counter and track the new level
                cnt     <= '0;
                last_in <= noisy_in;
            end else if (cnt < STABLE_COUNT - 1) begin
                cnt <= cnt + 1'b1;
            end else begin
                // Input has been stable for STABLE_COUNT cycles: update output
                clean_out <= noisy_in;
            end
        end
    end
endmodule

// =============================================================================
// hamming_encoder.sv  - (7,4) Hamming Code Encoder
// =============================================================================
// Adds 3 parity bits to 4 data bits, producing a 7-bit codeword that can
// detect and CORRECT any single-bit error. The parity bits sit at positions
// that are powers of two (1, 2, 4); data bits fill the remaining positions.
// Used in: ECC memory, FPGA configuration memory, aerospace/safety systems.
//
// Bit positions (1-indexed): P1 P2 D1 P4 D2 D3 D4
// P1 covers: 1,3,5,7  =>  P1 = D1^D2^D4
// P2 covers: 2,3,6,7  =>  P2 = D1^D3^D4
// P4 covers: 4,5,6,7  =>  P4 = D2^D3^D4
// =============================================================================
module hamming_encoder (
    input  logic [3:0] data_in,       // 4 data bits
    output logic [6:0] code_out       // 7-bit Hamming codeword
);
    wire d1=data_in[0], d2=data_in[1], d3=data_in[2], d4=data_in[3];
    wire p1 = d1 ^ d2 ^ d4;
    wire p2 = d1 ^ d3 ^ d4;
    wire p4 = d2 ^ d3 ^ d4;
    // Pack: [6:0] = {d4, d3, d2, p4, d1, p2, p1}  (bit 0 = position 1)
    assign code_out = {d4, d3, d2, p4, d1, p2, p1};
endmodule

// =============================================================================
// hamming_checker.sv  - (7,4) Hamming Code Checker / Corrector
// =============================================================================
module hamming_checker (
    input  logic [6:0] code_in,       // received 7-bit codeword (may have 1-bit error)
    output logic [3:0] data_out,      // corrected 4-bit data
    output logic [2:0] syndrome,      // 0=no error; 1-7=bit position of error
    output logic       single_error,  // 1 = single-bit error detected and corrected
    output logic       no_error       // 1 = codeword is valid as received
);
    wire p1=code_in[0], p2=code_in[1], d1=code_in[2],
         p4=code_in[3], d2=code_in[4], d3=code_in[5], d4=code_in[6];

    // Recalculate syndrome bits
    wire s1 = p1 ^ d1 ^ d2 ^ d4;
    wire s2 = p2 ^ d1 ^ d3 ^ d4;
    wire s4 = p4 ^ d2 ^ d3 ^ d4;

    assign syndrome      = {s4, s2, s1};    // syndrome = bit position of error (1-indexed)
    assign no_error      = (syndrome == 0);
    assign single_error  = (syndrome != 0);

    // Flip the erroneous bit
    logic [6:0] corrected;
    always_comb begin
        corrected = code_in;
        if (syndrome != 0) corrected[syndrome - 1] = ~code_in[syndrome - 1];
    end

    assign data_out = {corrected[6], corrected[5], corrected[4], corrected[2]};
endmodule
