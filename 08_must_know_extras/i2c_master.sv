// =============================================================================
// i2c_master.sv - Simplified I2C Master (single-byte write/read)
// =============================================================================
// I2C uses two wires: SCL (clock) and SDA (data). Both are open-drain
// (devices only pull LOW; a pull-up resistor holds them HIGH when idle).
// Key protocol events:
//   START condition : SDA falls while SCL is HIGH
//   STOP  condition : SDA rises  while SCL is HIGH
//   Data bit        : SDA sampled on rising SCL edge; stable while SCL is HIGH
//   ACK             : receiver pulls SDA LOW on the 9th clock = "I got it"
//
// This module implements: START -> 7-bit address + R/W -> ACK -> 8-bit data
// -> ACK -> STOP for write; START -> addr -> ACK -> read byte -> NACK -> STOP
// for read. CLKS_PER_QUARTER sets the quarter-period of SCL relative to clk.
// =============================================================================
module i2c_master #(
    parameter int CLKS_PER_QUARTER = 25   // f_clk/(4*f_scl)
) (
    input  logic       clk, rst_n,
    input  logic       start_xfer,        // pulse to begin
    input  logic       rw,                // 0=write, 1=read
    input  logic [6:0] addr,              // 7-bit I2C device address
    input  logic [7:0] wdata,             // byte to write (ignored on read)
    output logic [7:0] rdata,             // byte received (valid when done=1 & rw=1)
    output logic       done,
    output logic       ack_error,         // 1 if slave did not ACK

    // I2C bus (open-drain: drive 0 to assert, release (Z) to let pull-up hold 1)
    output logic       scl_oe,            // 1 = drive SCL low
    output logic       sda_oe,            // 1 = drive SDA low
    input  logic       sda_in             // SDA as read back from the bus
);
    localparam int CQ = CLKS_PER_QUARTER;
    typedef enum logic [3:0] {
        S_IDLE, S_START, S_ADDR, S_ADDR_ACK,
        S_DATA, S_DATA_ACK, S_STOP, S_DONE
    } state_t;
    state_t state;

    logic [$clog2(CQ)-1:0] cnt;    // quarter-period counter
    logic [3:0] bit_cnt;           // bit index (0..7 for addr/data, +1 for ACK)
    logic [7:0] shift_r;           // shift register: addr+rw or data
    logic [1:0] qphase;            // quarter phase within one SCL period (0..3)
    logic       scl_r;

    // SCL: toggle every quarter period
    // Phase 0 = SCL low (first half)  Phase 1 = SCL rising (sampling edge)
    // Phase 2 = SCL high              Phase 3 = SCL falling

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state<=S_IDLE; cnt<='0; bit_cnt<='0; shift_r<='0;
            qphase<='0; scl_r<=1'b1; scl_oe<=1'b0; sda_oe<=1'b0;
            rdata<='0; done<=1'b0; ack_error<=1'b0;
        end else begin
            done<=1'b0;
            // Quarter-period tick
            if (cnt == CQ-1) begin
                cnt    <='0;
                qphase <= qphase+1'b1;
            end else cnt<=cnt+1'b1;

            // Generate SCL: low on phase 0-1, high on phase 2-3 (except START/STOP)
            scl_r <= (qphase[1]);   // 0,1 -> low; 2,3 -> high

            case (state)
                S_IDLE: begin
                    scl_oe<=1'b0; sda_oe<=1'b0; qphase<='0;
                    if (start_xfer) begin
                        shift_r<={addr,rw};
                        bit_cnt<=4'd7;
                        state<=S_START;
                    end
                end
                S_START: begin
                    // START: SDA falls while SCL high
                    // Use qphase 2 (SCL high) -> pull SDA low -> move to ADDR
                    if (qphase==2'd2 && cnt==0) sda_oe<=1'b1;    // SDA low
                    if (qphase==2'd3 && cnt==CQ-1) begin
                        scl_oe<=1'b1;   // pull SCL low too
                        state  <=S_ADDR;
                        bit_cnt<=4'd7;
                        shift_r<={addr,rw};
                    end
                end
                S_ADDR: begin
                    // Clock out 8 bits (7 addr + R/W), MSB first
                    // Phase 0: set SDA, Phase 1: release SCL (clock high), Phase 2: SCL high (slave samples)
                    if (qphase==2'd0 && cnt==0) sda_oe <= !shift_r[7];
                    if (qphase==2'd1 && cnt==0) scl_oe <=1'b0;   // release SCL
                    if (qphase==2'd3 && cnt==0) begin
                        scl_oe<=1'b1;  // pull SCL low
                        if (bit_cnt==0) begin
                            state<=S_ADDR_ACK;
                        end else begin
                            shift_r<={shift_r[6:0],1'b0};
                            bit_cnt<=bit_cnt-1'b1;
                        end
                    end
                end
                S_ADDR_ACK: begin
                    // Release SDA for slave to ACK, one SCL pulse
                    if (qphase==2'd0 && cnt==0) sda_oe<=1'b0;
                    if (qphase==2'd1 && cnt==0) scl_oe<=1'b0;
                    if (qphase==2'd2 && cnt==CQ/2) ack_error<= sda_in;  // ACK=0=ok
                    if (qphase==2'd3 && cnt==0) begin
                        scl_oe<=1'b1;
                        shift_r <= rw ? 8'hFF : wdata;
                        bit_cnt <= 4'd7;
                        state   <= S_DATA;
                    end
                end
                S_DATA: begin
                    if (rw==1'b0) begin
                        // Write: drive SDA from shift register
                        if (qphase==2'd0 && cnt==0) sda_oe<=!shift_r[7];
                    end
                    // Clock pulse
                    if (qphase==2'd1 && cnt==0) scl_oe<=1'b0;
                    if (rw==1'b1 && qphase==2'd2 && cnt==CQ/2)
                        rdata<={rdata[6:0],sda_in};
                    if (qphase==2'd3 && cnt==0) begin
                        scl_oe<=1'b1;
                        if (bit_cnt==0) state<=S_DATA_ACK;
                        else begin shift_r<={shift_r[6:0],1'b0}; bit_cnt<=bit_cnt-1'b1; end
                    end
                end
                S_DATA_ACK: begin
                    if (qphase==2'd0 && cnt==0) sda_oe<=(rw ? 1'b1 : 1'b0); // NACK on read
                    if (qphase==2'd1 && cnt==0) scl_oe<=1'b0;
                    if (rw==1'b0 && qphase==2'd2 && cnt==CQ/2) ack_error<=sda_in;
                    if (qphase==2'd3 && cnt==0) begin scl_oe<=1'b1; state<=S_STOP; end
                end
                S_STOP: begin
                    // STOP: SDA rises while SCL high
                    if (qphase==2'd0 && cnt==0) sda_oe<=1'b1;   // SDA low
                    if (qphase==2'd1 && cnt==0) scl_oe<=1'b0;   // SCL high
                    if (qphase==2'd2 && cnt==0) sda_oe<=1'b0;   // SDA rises (STOP)
                    if (qphase==2'd3 && cnt==0) state<=S_DONE;
                end
                S_DONE: begin done<=1'b1; state<=S_IDLE; end
                default: state<=S_IDLE;
            endcase
        end
    end

endmodule
