// =============================================================================
// tb_shift_add_multiplier.sv
// =============================================================================
`timescale 1ns/1ps
module tb_shift_add_multiplier;

    localparam int WIDTH = 8;
    logic clk = 0, rst_n;
    logic start, busy, done;
    logic [WIDTH-1:0] multiplicand, multiplier;
    logic [2*WIDTH-1:0] product;

    int errors = 0, checks = 0;

    shift_add_multiplier #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .multiplicand(multiplicand), .multiplier(multiplier),
        .product(product), .busy(busy), .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("shift_add_multiplier.vcd");
        $dumpvars(0, tb_shift_add_multiplier);
    end

    task automatic do_multiply(input [WIDTH-1:0] mc, mr);
        logic [2*WIDTH-1:0] expected;
        @(negedge clk);
        multiplicand = mc; multiplier = mr;
        start = 1;
        @(negedge clk);
        start = 0;
        // Poll for completion at negedges (never sample exactly at the same
        // posedge the DUT's own FSM is transitioning on)
        while (!done) @(negedge clk);
        expected = mc * mr;
        checks++;
        if (product !== expected) begin
            $display("ERROR: %0d x %0d = %0d, expected %0d", mc, mr, product, expected);
            errors++;
        end
        @(negedge clk);   // let busy/done settle back to idle before the next start
    endtask

    initial begin
        start = 0; multiplicand = 0; multiplier = 0;
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        // Directed corner cases
        do_multiply(8'd0,   8'd0);
        do_multiply(8'd0,   8'd255);
        do_multiply(8'd255, 8'd0);
        do_multiply(8'd255, 8'd255);
        do_multiply(8'd1,   8'd1);
        do_multiply(8'd16,  8'd16);
        do_multiply(8'd170, 8'd85);

        // Randomized coverage
        for (int i = 0; i < 200; i++) begin
            do_multiply($urandom_range(0,255), $urandom_range(0,255));
        end

        $display("--------------------------------------------------");
        if (errors == 0) $display("SHIFT_ADD_MULTIPLIER: ALL %0d CHECKS PASSED", checks);
        else $display("SHIFT_ADD_MULTIPLIER: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
