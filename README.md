SystemVerilog Design Library

A library of synthesizable SystemVerilog RTL blocks covering the fundamentals every ASIC design engineer works with: FIFOs, clock domain crossing, clock dividers, arbiters, integer and floating-point arithmetic, serial protocols, and common control circuits.

Every design is paired with a self-checking testbench and simulated in Icarus Verilog and Verilator. Waveforms (VCD) are included so you can inspect behavior without running anything.

At a glance: 25 design files · 18 self-checking testbenches · 17 VCD waveforms

Highlights

IEEE-754 single-precision floating-point adder. Exponent alignment, mantissa add/subtract, leading-one normalization, rounding, and special cases (zero, infinity, NaN, denormals). While verifying it, simulation exposed a mantissa-extraction error: the design sliced the normalized result as norm[46:24] instead of norm[23:1]. The exponent update also had to be re-derived from first principles. Both are fixed, and 22 directed checks pass.

Exhaustive and randomized verification. The adders are checked exhaustively (262,144 input combinations). FIFOs and arbiters use randomized concurrent traffic with scoreboards.

Bugs found during verification. Several real RTL and testbench bugs were caught in simulation and are documented in the code comments. These include the FP adder slicing error above, an SPI master that shifted out 9 bits instead of 8, and a simulator $countones quirk that required a manual popcount function.

Designs
Category	Designs	Verification
FIFOs	Synchronous FIFO (wrap-bit pointers), asynchronous dual-clock FIFO (Gray-code pointers, 2-flop synchronizers)	822/822 and 147/147 checks
Clock domain crossing	2-flop synchronizer, pulse synchronizer, req/ack handshake synchronizer	202, 15, 20 checks
Clock dividers	Even divider, odd divider with 50% duty cycle (DIV = 3, 5)	Period and duty cycle measured
Arbiters	Fixed-priority arbiter, round-robin arbiter	16 exhaustive + 91 fairness checks
Integer arithmetic	Ripple-carry adder, carry-lookahead adder, shift-and-add multiplier, signed Booth multiplier, restoring divider	262,144 exhaustive adder checks; 207, 209, 309 checks
Floating point	IEEE-754 single-precision adder	22 directed checks incl. special cases
Serial protocols	UART transmitter, SPI master, I2C master	UART and SPI self-checked; I2C smoke-tested
Control and datapath	FSM examples (Moore/Mealy), shift register, register file, priority encoder, barrel shifter	Directed checks
Utility circuits	Gray-code counter, LFSR, PWM generator, switch debouncer, Hamming (7,4) encoder/checker	Property checks (1-bit Gray transitions, no LFSR repeats, exact duty ratio, all 16 codewords with injected single-bit errors corrected)
Repository layout
rtl/        Synthesizable design files, grouped by category
tb/         Self-checking testbenches
waves/      VCD waveform dumps from simulation
wavedrom/   WaveDrom timing diagrams (JSON) for each block
docs/       Per-block design notes: interface, micro-architecture, design decisions
Running a simulation

Requires Icarus Verilog 11+ (or Verilator 5+).

bash
# Example: run the FP adder testbench
iverilog -g2012 -o sim rtl/fp_adder.sv tb/tb_fp_adder.sv
vvp sim

Each testbench prints a PASS/FAIL summary and writes a .vcd file.

Viewing waveforms
VCD files: open in GTKWave, or drag into Surfer in the browser. No install needed.
WaveDrom diagrams: paste any JSON file from wavedrom/ into the WaveDrom editor.
Tools

SystemVerilog (IEEE 1800-2012) · Icarus Verilog · Verilator · GTKWave · WaveDrom

Author

Shrinidhi Nagarajan Sreedharamurthy. M.S. Electrical and Computer Engineering, Portland State University. Former FPGA Engineer (5G fronthaul RTL: JESD204B, AXI, I2C/SPI).

LinkedIn · GitHub

License

MIT
