// =============================================================================
// spi_master.sv - SPI Master (Mode 0: CPOL=0, CPHA=0)
// =============================================================================
// MOSI is driven on the falling edge (or before the first rising edge).
// MISO is sampled on the rising edge.
// Exactly WIDTH SCL periods (one per bit) between CS_N assert and deassert.
// =============================================================================
module spi_master #(
    parameter int WIDTH         = 8,
    parameter int CLKS_PER_HALF = 4
) (
    input  logic             clk, rst_n,
    input  logic             start,
    input  logic [WIDTH-1:0] tx_data,
    output logic [WIDTH-1:0] rx_data,
    output logic             done, busy,
    output logic             sclk, mosi, cs_n,
    input  logic             miso
);
    localparam int CW = $clog2(CLKS_PER_HALF+1);
    typedef enum logic [1:0] {S_IDLE, S_XFER, S_DONE} state_t;
    state_t state;

    logic [CW-1:0]    hcnt;      // counts up to CLKS_PER_HALF per half-period
    logic [3:0]       bit_idx;   // current bit being shifted (WIDTH-1 down to 0)
    logic             sclk_r;
    logic [WIDTH-1:0] tx_r, rx_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state<=S_IDLE; sclk_r<=0; cs_n<=1; mosi<=0;
            hcnt<=0; bit_idx<=0; tx_r<=0; rx_r<=0; done<=0;
        end else begin
            done<=0;
            case (state)
                S_IDLE: begin
                    sclk_r<=0; cs_n<=1;
                    if (start) begin
                        tx_r    <=tx_data;
                        bit_idx <=WIDTH-1;
                        hcnt    <=0;
                        cs_n    <=0;
                        mosi    <=tx_data[WIDTH-1];  // drive MSB before first clock
                        state   <=S_XFER;
                    end
                end
                S_XFER: begin
                    hcnt<=hcnt+1;
                    if (hcnt==CLKS_PER_HALF-1) begin
                        hcnt<=0;
                        sclk_r<=~sclk_r;
                        if (!sclk_r) begin
                            // Transitioning 0->1 (rising edge): sample MISO
                            rx_r<={rx_r[WIDTH-2:0], miso};
                            if (bit_idx==0) state<=S_DONE;
                        end else begin
                            // Transitioning 1->0 (falling edge): update MOSI for next bit
                            bit_idx<=bit_idx-1;
                            mosi<=tx_r[bit_idx-1];
                        end
                    end
                end
                S_DONE: begin
                    cs_n<=1; sclk_r<=0; done<=1; rx_data<=rx_r; state<=S_IDLE;
                end
                default: state<=S_IDLE;
            endcase
        end
    end
    assign sclk=sclk_r; assign busy=(state!=S_IDLE);
endmodule
