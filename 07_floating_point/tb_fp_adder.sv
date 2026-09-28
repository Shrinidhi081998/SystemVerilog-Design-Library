// =============================================================================
// tb_fp_adder.sv - Self-checking testbench for fp_adder
// All test vectors use pre-computed IEEE 754 hex bit patterns (bypassing
// Icarus's $realtobits limitation that always returns double-precision bits).
// =============================================================================
`timescale 1ns/1ps
module tb_fp_adder;

    logic [31:0] a, b, result;
    int errors = 0, checks = 0;
    fp_adder dut (.a(a), .b(b), .result(result));

    initial begin
        $dumpfile("fp_adder.vcd");
        $dumpvars(0, tb_fp_adder);
    end

    // Allow 2 ULP tolerance (truncation vs round-to-nearest)
    function automatic bit fp_close(input [31:0] got, exp);
        int diff;
        if (got[30:23]==8'hFF && got[22:0]!=0 && exp[30:23]==8'hFF && exp[22:0]!=0) return 1;
        if (got==exp) return 1;
        diff = $signed({1'b0, got}) - $signed({1'b0, exp});
        if (diff < 0) diff = -diff;
        return (diff <= 2);
    endfunction

    task automatic chk(input [31:0] av, bv, exp, input string lbl);
        a=av; b=bv; #1;
        checks++;
        if (!fp_close(result, exp)) begin
            $display("FAIL[%s]: a=%h b=%h got=%h exp=%h", lbl, av, bv, result, exp);
            errors++;
        end
    endtask

    initial begin
        // ---- Basic arithmetic (all values from Python: struct.pack('f',...)) ----
        chk(32'h3F800000, 32'h40000000, 32'h40400000, "1+2=3");
        chk(32'h3FC00000, 32'h40200000, 32'h40800000, "1.5+2.5=4");
        chk(32'hBF800000, 32'h3F800000, 32'h00000000, "-1+1=0");
        chk(32'h00000000, 32'h40A00000, 32'h40A00000, "0+5=5");
        chk(32'h42C80000, 32'h3A83126F, 32'h42C80083, "100+0.001");
        chk(32'h60AD78EC, 32'h60AD78EC, 32'h612D78EC, "1e20+1e20=2e20");
        chk(32'h1E3CE508, 32'h1E3CE508, 32'h1EBCE508, "1e-20+1e-20=2e-20");
        chk(32'hC0490FDB, 32'h40490FDB, 32'h00000000, "-pi+pi=0");
        chk(32'h40A00000, 32'hC0600000, 32'h3FC00000, "5+(-3.5)=1.5");
        chk(32'h3E4CCCCD, 32'h3DCCCCCD, 32'h3E99999A, "0.2+0.1~0.3");
        chk(32'h47C35000, 32'hC7C35000, 32'h00000000, "100k+(-100k)=0");
        chk(32'h461C4000, 32'h45FA0000, 32'h468CA000, "10000+8000=18000");
        chk(32'hBF800000, 32'hBF800000, 32'hC0000000, "-1+(-1)=-2");
        chk(32'h42480000, 32'h42480000, 32'h42C80000, "50+50=100");
        chk(32'h3F800000, 32'hBF000000, 32'h3F000000, "1+(-0.5)=0.5");
        chk(32'h43FA0000, 32'hC3C80000, 32'h42C80000, "500+(-400)=100");
        chk(32'h44898000, 32'h44898000, 32'h45098000, "1100+1100=2200");
        chk(32'h3727C5AC, 32'h36A7C5AC, 32'h377BA882, "tiny+smaller");

        // ---- Special values ----
        a=32'h7F800000; b=32'h3F800000; #1; checks++;  // +inf + 1.0 = +inf
        if (result!==32'h7F800000) begin $display("FAIL +inf+1=%h",result); errors++; end
        a=32'h7F800000; b=32'hFF800000; #1; checks++;  // +inf+(-inf) = NaN
        if (result[30:23]!==8'hFF || result[22:0]==0) begin $display("FAIL inf-inf=%h",result); errors++; end
        a=32'h7FC00000; b=32'h3F800000; #1; checks++;  // NaN+1 = NaN
        if (result[30:23]!==8'hFF || result[22:0]==0) begin $display("FAIL NaN+1=%h",result); errors++; end
        a=32'h00000000; b=32'h00000000; #1; checks++;  // 0+0=0
        if (result!==32'h00000000) begin $display("FAIL 0+0=%h",result); errors++; end

        $display("--------------------------------------------------");
        if (errors==0) $display("FP_ADDER: ALL %0d CHECKS PASSED", checks);
        else           $display("FP_ADDER: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
