// =============================================================================
// tb_booth_multiplier.sv
// =============================================================================
`timescale 1ns/1ps
module tb_booth_multiplier;

    localparam int WIDTH = 8;
    logic clk = 0, rst_n;
    logic start, busy, done;
    logic signed [WIDTH-1:0]     multiplicand, multiplier;
    logic signed [2*WIDTH-1:0]   product;

    int errors = 0, checks = 0;

    booth_multiplier #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .multiplicand(multiplicand), .multiplier(multiplier),
        .product(product), .busy(busy), .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("booth_multiplier.vcd");
        $dumpvars(0, tb_booth_multiplier);
    end

    task automatic do_multiply_signed(input signed [WIDTH-1:0] mc, mr);
        logic signed [2*WIDTH-1:0] expected;
        @(negedge clk);
        multiplicand = mc; multiplier = mr; start = 1;
        @(negedge clk); start = 0;
        while (!done) @(negedge clk);
        expected = {{WIDTH{mc[WIDTH-1]}}, mc} * {{WIDTH{mr[WIDTH-1]}}, mr};
        checks++;
        if (product !== expected) begin
            $display("ERROR: %0d x %0d = %0d (0x%04h), expected %0d (0x%04h)",
                       mc, mr, product, product, expected, expected);
            errors++;
        end
        @(negedge clk);
    endtask

    initial begin
        start = 0; multiplicand = 0; multiplier = 0;
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        // Directed signed cases covering all sign combinations
        do_multiply_signed( 8'sd5,   8'sd3);    //  +  = +15
        do_multiply_signed(-8'sd5,   8'sd3);    //  -  = -15
        do_multiply_signed( 8'sd5,  -8'sd3);    //  -  = -15
        do_multiply_signed(-8'sd5,  -8'sd3);    //  +  = +15
        do_multiply_signed( 8'sd0,   8'sd127);  //  0
        do_multiply_signed( 8'sd127, 8'sd127);  // large +ve
        do_multiply_signed(-8'sd128, 8'sd1);    // most-negative * 1
        do_multiply_signed(-8'sd128,-8'sd128);  // most-negative squared (produces +16384)
        do_multiply_signed(-8'sd1,   8'sd1);    // -1

        // Randomized signed coverage
        for (int i = 0; i < 200; i++) begin
            do_multiply_signed($signed($urandom_range(128,255)), $signed($urandom_range(128,255)));
        end

        $display("--------------------------------------------------");
        if (errors == 0) $display("BOOTH_MULTIPLIER: ALL %0d CHECKS PASSED (signed)", checks);
        else $display("BOOTH_MULTIPLIER: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
