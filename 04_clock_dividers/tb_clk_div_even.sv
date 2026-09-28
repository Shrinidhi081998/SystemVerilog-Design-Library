// =============================================================================
// tb_clk_div_even.sv
// =============================================================================
`timescale 1ns/1ps
module tb_clk_div_even;

    localparam int DIV = 4;
    logic clk_in = 0, rst_n;
    logic clk_out, enable_out;
    int errors = 0, checks = 0;

    clk_div_even #(.DIV(DIV)) dut (.clk_in(clk_in), .rst_n(rst_n), .clk_out(clk_out), .enable_out(enable_out));

    localparam real TIN = 4.0;
    always #(TIN/2) clk_in = ~clk_in;

    initial begin
        $dumpfile("clk_div_even.vcd");
        $dumpvars(0, tb_clk_div_even);
    end

    time t_rise0, t_rise1, t_fall0;

    initial begin
        rst_n = 0;
        repeat (4) @(posedge clk_in);
        rst_n = 1;

        // Measure period between two consecutive rising edges of clk_out
        @(posedge clk_out);
        t_rise0 = $time;
        @(negedge clk_out);
        t_fall0 = $time;
        @(posedge clk_out);
        t_rise1 = $time;

        $display("clk_out period measured = %0t (expected %0t)", t_rise1 - t_rise0, DIV * TIN);
        checks++;
        if ((t_rise1 - t_rise0) != DIV * TIN) begin
            $display("ERROR: period mismatch");
            errors++;
        end

        $display("clk_out high time = %0t (expected %0t, i.e. 50%% duty)", t_fall0 - t_rise0, (DIV*TIN)/2);
        checks++;
        if ((t_fall0 - t_rise0) != (DIV*TIN)/2) begin
            $display("ERROR: duty cycle mismatch");
            errors++;
        end

        // Run several more periods and check consistency + count enable_out pulses
        begin
            int enable_count = 0;
            time t_start = $time;
            for (int i = 0; i < 20; i++) @(posedge clk_in) if (enable_out) enable_count++;
            $display("enable_out pulses seen in 20 clk_in cycles = %0d (expected ~%0d)", enable_count, 20/DIV);
            checks++;
            if (enable_count != 20/DIV) begin
                $display("ERROR: enable_out pulse count mismatch");
                errors++;
            end
        end

        $display("--------------------------------------------------");
        if (errors == 0) $display("CLK_DIV_EVEN (DIV=%0d): ALL %0d CHECKS PASSED", DIV, checks);
        else $display("CLK_DIV_EVEN: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #50 $finish;
    end
endmodule
