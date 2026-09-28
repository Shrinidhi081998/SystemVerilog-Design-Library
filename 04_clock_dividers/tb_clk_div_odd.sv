// =============================================================================
// tb_clk_div_odd.sv
// =============================================================================
`timescale 1ns/1ps
module tb_clk_div_odd;

    localparam int DIV = 5;   // try an odd ratio
    logic clk_in = 0, rst_n;
    logic clk_out;
    int errors = 0, checks = 0;

    clk_div_odd #(.DIV(DIV)) dut (.clk_in(clk_in), .rst_n(rst_n), .clk_out(clk_out));

    localparam real TIN = 4.0;
    always #(TIN/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("clk_div_odd.vcd");
        $dumpvars(0, tb_clk_div_odd);
    end

    time t_rise0, t_rise1, t_fall0;

    initial begin
        rst_n = 0;
        repeat (6) @(posedge clk_in);
        rst_n = 1;
        repeat (2) @(posedge clk_in);   // let counters reach steady phase relationship

        repeat (4) begin   // check several consecutive periods for consistency
            @(posedge clk_out);
            t_rise0 = $time;
            @(negedge clk_out);
            t_fall0 = $time;
            @(posedge clk_out);
            t_rise1 = $time;

            checks++;
            if ((t_rise1 - t_rise0) != DIV * TIN) begin
                $display("ERROR: period=%0t expected=%0t", t_rise1 - t_rise0, DIV*TIN);
                errors++;
            end else begin
                $display("period OK: %0t", t_rise1 - t_rise0);
            end

            checks++;
            // 50% duty on an ODD divisor means high time = DIV*TIN/2 (a half-integer
            // number of input periods -- e.g. 1.5, 2.5 input periods -- which is
            // exactly representable since TIN itself has a .0 that can halve evenly)
            if ((t_fall0 - t_rise0) != (DIV*TIN)/2) begin
                $display("ERROR: high_time=%0t expected=%0t", t_fall0 - t_rise0, (DIV*TIN)/2);
                errors++;
            end else begin
                $display("duty OK: high_time=%0t (%0.1f%% of period)", t_fall0-t_rise0, 100.0*(t_fall0-t_rise0)/(DIV*TIN));
            end
        end

        $display("--------------------------------------------------");
        if (errors == 0) $display("CLK_DIV_ODD (DIV=%0d): ALL %0d CHECKS PASSED -- exact 50%% duty confirmed", DIV, checks);
        else $display("CLK_DIV_ODD: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #50 $finish;
    end
endmodule
