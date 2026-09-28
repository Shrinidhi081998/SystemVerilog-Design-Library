// =============================================================================
// tb_fixed_priority_arbiter.sv
// =============================================================================
`timescale 1ns/1ps
module tb_fixed_priority_arbiter;

    localparam int N = 4;
    logic [N-1:0] req;
    logic [N-1:0] grant;
    int errors = 0, checks = 0;

    fixed_priority_arbiter #(.N(N)) dut (.req(req), .grant(grant));

    initial begin
        $dumpfile("fixed_priority_arbiter.vcd");
        $dumpvars(0, tb_fixed_priority_arbiter);
    end

    function automatic [N-1:0] expected_grant(input [N-1:0] r);
        expected_grant = '0;
        for (int i = 0; i < N; i++) begin
            if (r[i]) begin
                expected_grant = (1 << i);
                return expected_grant;
            end
        end
    endfunction

    task automatic check(input [N-1:0] r);
        logic [N-1:0] exp;
        req = r;
        #1;
        exp = expected_grant(r);
        checks++;
        if (grant !== exp) begin
            $display("ERROR: req=%b grant=%b expected=%b", r, grant, exp);
            errors++;
        end
    endtask

    initial begin
        // Exhaustively test all 2^N request combinations -- fully feasible since N is small
        for (int r = 0; r < (1<<N); r++) begin
            check(r[N-1:0]);
        end

        $display("--------------------------------------------------");
        if (errors == 0) $display("FIXED_PRIORITY_ARBITER: ALL %0d CHECKS PASSED (exhaustive, N=%0d)", checks, N);
        else $display("FIXED_PRIORITY_ARBITER: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
