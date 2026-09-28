// =============================================================================
// tb_adders.sv - Testbench for ripple_carry_adder and carry_lookahead_adder
// =============================================================================
`timescale 1ns/1ps
module tb_adders;

    localparam int WIDTH = 8;
    logic [WIDTH-1:0] a, b, sum_rca, sum_cla;
    logic cin, cout_rca, cout_cla;
    int errors = 0, checks = 0;

    ripple_carry_adder #(.WIDTH(WIDTH)) u_rca (.a(a), .b(b), .cin(cin), .sum(sum_rca), .cout(cout_rca));
    carry_lookahead_adder #(.WIDTH(WIDTH)) u_cla (.a(a), .b(b), .cin(cin), .sum(sum_cla), .cout(cout_cla));

    // NOTE: no $dumpfile/$dumpvars here on purpose -- this test runs 262,144
    // exhaustive vectors, which would produce a multi-megabyte VCD unsuitable
    // for a waveform viewer. See tb_adders_wave.sv for a small, curated set
    // of vectors specifically meant to produce a readable waveform.

    task automatic check(input [WIDTH-1:0] av, bv, input cv);
        logic [WIDTH:0] expected;
        a = av; b = bv; cin = cv;
        #1;
        expected = av + bv + cv;
        checks++;
        if (sum_rca !== expected[WIDTH-1:0] || cout_rca !== expected[WIDTH]) begin
            $display("ERROR(RCA): a=%0d b=%0d cin=%0d -> sum=%0d cout=%0d, expected sum=%0d cout=%0d",
                       av, bv, cv, sum_rca, cout_rca, expected[WIDTH-1:0], expected[WIDTH]);
            errors++;
        end
        checks++;
        if (sum_cla !== expected[WIDTH-1:0] || cout_cla !== expected[WIDTH]) begin
            $display("ERROR(CLA): a=%0d b=%0d cin=%0d -> sum=%0d cout=%0d, expected sum=%0d cout=%0d",
                       av, bv, cv, sum_cla, cout_cla, expected[WIDTH-1:0], expected[WIDTH]);
            errors++;
        end
    endtask

    initial begin
        // Exhaustive over all 8-bit a,b with cin=0 and cin=1 would be 131072 cases --
        // fully exhaustive over an 8-bit x 8-bit x cin space (2^17 = 131072), totally fine to run.
        for (int av = 0; av < 256; av++) begin
            for (int bv = 0; bv < 256; bv++) begin
                check(av[WIDTH-1:0], bv[WIDTH-1:0], 1'b0);
                check(av[WIDTH-1:0], bv[WIDTH-1:0], 1'b1);
            end
        end

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("ADDERS (RCA + CLA, WIDTH=%0d): ALL %0d CHECKS PASSED (exhaustive)", WIDTH, checks);
        else
            $display("ADDERS: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
