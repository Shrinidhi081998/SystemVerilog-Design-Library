// =============================================================================
// tb_restoring_divider.sv
// =============================================================================
`timescale 1ns/1ps
module tb_restoring_divider;

    localparam int WIDTH = 8;
    logic clk = 0, rst_n;
    logic start, busy, done, div_by_zero;
    logic [WIDTH-1:0] dividend, divisor, quotient, remainder;
    int errors = 0, checks = 0;

    restoring_divider #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .dividend(dividend), .divisor(divisor),
        .quotient(quotient), .remainder(remainder),
        .busy(busy), .done(done), .div_by_zero(div_by_zero)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("restoring_divider.vcd");
        $dumpvars(0, tb_restoring_divider);
    end

    task automatic do_divide(input [WIDTH-1:0] dvnd, dvsr);
        @(negedge clk);
        dividend = dvnd; divisor = dvsr; start = 1;
        @(negedge clk); start = 0;
        while (!done) @(negedge clk);
        @(negedge clk);   // settle

        checks++;
        if (dvsr == 0) begin
            if (!div_by_zero) begin
                $display("ERROR: div_by_zero not set for %0d / 0", dvnd);
                errors++;
            end
        end else begin
            logic [WIDTH-1:0] exp_q, exp_r;
            exp_q = dvnd / dvsr;
            exp_r = dvnd % dvsr;
            if (quotient !== exp_q || remainder !== exp_r) begin
                $display("ERROR: %0d / %0d = Q:%0d R:%0d, expected Q:%0d R:%0d",
                          dvnd, dvsr, quotient, remainder, exp_q, exp_r);
                errors++;
            end
        end
    endtask

    initial begin
        start = 0; dividend = 0; divisor = 0;
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        // Directed edge cases
        do_divide(8'd0,   8'd1);     // 0 / 1 = 0 R 0
        do_divide(8'd1,   8'd1);     // 1 / 1 = 1 R 0
        do_divide(8'd255, 8'd1);     // max / 1
        do_divide(8'd255, 8'd255);   // same / same = 1 R 0
        do_divide(8'd100, 8'd7);     // 100 / 7 = 14 R 2
        do_divide(8'd255, 8'd16);    // 255 / 16 = 15 R 15
        do_divide(8'd128, 8'd3);
        do_divide(8'd7,   8'd8);     // quotient = 0, R = dividend
        do_divide(8'd10,  8'd0);     // division by zero

        // Randomized coverage
        for (int i = 0; i < 300; i++) begin
            do_divide($urandom_range(0,255), $urandom_range(1,255));
        end

        $display("--------------------------------------------------");
        if (errors == 0) $display("RESTORING_DIVIDER: ALL %0d CHECKS PASSED", checks);
        else $display("RESTORING_DIVIDER: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
