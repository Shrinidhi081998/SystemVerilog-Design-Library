// =============================================================================
// tb_handshake_sync.sv
// =============================================================================
`timescale 1ns/1ps
module tb_handshake_sync;

    localparam int WIDTH = 16;

    logic src_clk = 0, dst_clk = 0;
    logic src_rst_n, dst_rst_n;
    logic src_valid, src_busy;
    logic [WIDTH-1:0] src_data;
    logic dst_valid;
    logic [WIDTH-1:0] dst_data;

    int errors = 0, checks = 0;
    logic [WIDTH-1:0] ref_model [$];

    handshake_sync #(.WIDTH(WIDTH)) dut (
        .src_clk(src_clk), .src_rst_n(src_rst_n), .src_valid(src_valid), .src_data(src_data), .src_busy(src_busy),
        .dst_clk(dst_clk), .dst_rst_n(dst_rst_n), .dst_valid(dst_valid), .dst_data(dst_data)
    );

    always #3.0 src_clk = ~src_clk;   // fast domain, 6ns period
    always #7.0 dst_clk = ~dst_clk;   // slow domain, 14ns period

    initial begin
        $dumpfile("handshake_sync.vcd");
        $dumpvars(0, tb_handshake_sync);
    end

    // Destination checker
    always @(posedge dst_clk) begin
        if (dst_rst_n && dst_valid) begin
            checks++;
            if (ref_model.size() == 0) begin
                $display("[%0t] ERROR: dst_valid fired but reference model is empty", $time);
                errors++;
            end else begin
                logic [WIDTH-1:0] exp;
                exp = ref_model.pop_front();
                if (dst_data !== exp) begin
                    $display("[%0t] ERROR: dst_data=%0h expected=%0h", $time, dst_data, exp);
                    errors++;
                end
            end
        end
    end

    task automatic send_word(input [WIDTH-1:0] d);
        @(negedge src_clk);
        while (src_busy) @(negedge src_clk);   // wait for the interface to be idle
        src_data  = d;
        src_valid = 1;
        ref_model.push_back(d);
        @(negedge src_clk);
        while (!src_busy) @(negedge src_clk);  // wait until the FSM confirms it latched the request
        src_valid = 0;
    endtask

    initial begin
        src_valid = 0; src_data = 0;
        src_rst_n = 0; dst_rst_n = 0;
        repeat (3) @(posedge src_clk);
        repeat (3) @(posedge dst_clk);
        src_rst_n = 1; dst_rst_n = 1;
        @(posedge src_clk);

        // Send 20 back-to-back words as fast as the handshake allows
        for (int i = 0; i < 20; i++) begin
            send_word(16'hA000 + i[15:0]);
        end

        // Let the final handshake fully complete
        repeat (30) @(posedge dst_clk);

        $display("--------------------------------------------------");
        if (errors == 0 && ref_model.size() == 0)
            $display("HANDSHAKE_SYNC: ALL %0d CHECKS PASSED (reference model fully drained)", checks);
        else
            $display("HANDSHAKE_SYNC: %0d ERRORS out of %0d checks, %0d items un-drained",
                      errors, checks, ref_model.size());
        $display("--------------------------------------------------");
        #100 $finish;
    end

    // Safety watchdog
    initial begin
        #500000;
        $display("WATCHDOG TIMEOUT at T=%0t", $time);
        $finish;
    end
endmodule
