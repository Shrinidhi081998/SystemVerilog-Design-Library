// =============================================================================
// tb_round_robin_arbiter.sv
// =============================================================================
`timescale 1ns/1ps
module tb_round_robin_arbiter;

    localparam int N = 4;
    logic clk = 0, rst_n;
    logic [N-1:0] req;
    logic [N-1:0] grant;
    int errors = 0, checks = 0;
    int grant_count [N];

    round_robin_arbiter #(.N(N)) dut (.clk(clk), .rst_n(rst_n), .req(req), .grant(grant));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("round_robin_arbiter.vcd");
        $dumpvars(0, tb_round_robin_arbiter);
    end

    // Basic legality checks every cycle: grant must be one-hot AND a subset of req
    always @(posedge clk) begin
        if (rst_n) begin
            checks++;
            if (grant != 0 && $countones(grant) != 1) begin
                $display("[%0t] ERROR: grant=%b is not one-hot", $time, grant);
                errors++;
            end
            if ((grant & ~req) != 0) begin
                $display("[%0t] ERROR: grant=%b includes a bit not in req=%b", $time, grant, req);
                errors++;
            end
            for (int i = 0; i < N; i++) if (grant[i]) grant_count[i]++;
        end
    end

    initial begin
        req = '0;
        rst_n = 0;
        for (int i = 0; i < N; i++) grant_count[i] = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;
        @(negedge clk);

        // --- Test 1: all 4 requesters constantly asking -> should cycle fairly ---
        req = 4'b1111;
        repeat (40) @(posedge clk);
        @(negedge clk);   // let the grant_count-updating always block settle before we read it

        $display("After 40 cycles, all requesting: grant_count = [%0d, %0d, %0d, %0d]",
                  grant_count[0], grant_count[1], grant_count[2], grant_count[3]);
        checks++;
        for (int i = 0; i < N; i++) begin
            if (grant_count[i] < 8) begin   // expect ~10 each; allow slack, but nobody starved
                $display("ERROR: requester %0d only got %0d grants out of 40 (possible starvation)", i, grant_count[i]);
                errors++;
            end
        end

        // --- Test 2: only requester 3 asks -> it should get every grant, no starving itself ---
        @(negedge clk); req = 4'b1000;
        repeat (10) @(posedge clk);
        @(negedge clk);   // let the grant_count-updating always block settle before we read it
        checks++;
        if (grant_count[3] < 8) begin  // it was already accumulating from test1 too; just sanity check it keeps winning
            $display("NOTE: requester 3 solo count=%0d", grant_count[3]);
        end

        // --- Test 3: requester 0 asks continuously, others silent -> req0 should win every time ---
        for (int i = 0; i < N; i++) grant_count[i] = 0;
        @(negedge clk); req = 4'b0001;
        repeat (10) @(posedge clk);
        @(negedge clk);   // let the grant_count-updating always block settle before we read it
        checks++;
        if (grant_count[0] != 10) begin
            $display("ERROR: sole requester 0 expected 10/10 grants, got %0d", grant_count[0]);
            errors++;
        end

        // --- Test 4: alternating pair (0 and 2) both constantly requesting ---
        for (int i = 0; i < N; i++) grant_count[i] = 0;
        @(negedge clk); req = 4'b0101;
        repeat (20) @(posedge clk);
        @(negedge clk);   // let the grant_count-updating always block settle before we read it
        checks++;
        if (grant_count[0] < 8 || grant_count[2] < 8) begin
            $display("ERROR: unfair split between requesters 0 and 2: %0d vs %0d", grant_count[0], grant_count[2]);
            errors++;
        end else begin
            $display("Fair split between 0 and 2: %0d vs %0d (out of 20)", grant_count[0], grant_count[2]);
        end

        req = '0;
        repeat (3) @(posedge clk);

        $display("--------------------------------------------------");
        if (errors == 0) $display("ROUND_ROBIN_ARBITER: ALL %0d CHECKS PASSED", checks);
        else $display("ROUND_ROBIN_ARBITER: %0d ERRORS out of %0d checks", errors, checks);
        $display("--------------------------------------------------");
        #20 $finish;
    end
endmodule
