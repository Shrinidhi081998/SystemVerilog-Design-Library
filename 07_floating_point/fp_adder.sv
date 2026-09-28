// =============================================================================
// fp_adder.sv - IEEE 754 Single-Precision (32-bit) Floating-Point Adder
// =============================================================================
module fp_adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result
);
    // ---- Unpack ----
    wire        sa = a[31], sb = b[31];
    wire  [7:0] ea = a[30:23], eb = b[30:23];
    wire [22:0] ma = a[22:0],  mb = b[22:0];

    wire a_nan  = (ea == 8'hFF) && (ma != 0);
    wire b_nan  = (eb == 8'hFF) && (mb != 0);
    wire a_inf  = (ea == 8'hFF) && (ma == 0);
    wire b_inf  = (eb == 8'hFF) && (mb == 0);
    wire a_zero = (ea == 8'h00) && (ma == 0);
    wire b_zero = (eb == 8'h00) && (mb == 0);

    // 24-bit significands (with implicit leading 1)
    wire [23:0] siga = (ea == 0) ? {1'b0, ma} : {1'b1, ma};
    wire [23:0] sigb = (eb == 0) ? {1'b0, mb} : {1'b1, mb};

    // ---- Align ----
    wire        a_bigger = (ea > eb) || ((ea == eb) && (siga >= sigb));
    wire  [7:0] exp_big  = a_bigger ? ea : eb;
    wire  [7:0] exp_sml  = a_bigger ? eb : ea;
    wire [23:0] sig_big  = a_bigger ? siga : sigb;
    wire [23:0] sig_sml  = a_bigger ? sigb : siga;
    wire        s_big    = a_bigger ? sa : sb;
    wire        s_sml    = a_bigger ? sb : sa;

    wire  [7:0] shamt  = exp_big - exp_sml;
    // Shift sig_sml right by shamt; use 48-bit extended to avoid losing bits
    // then take the upper 24 bits as the aligned value
    wire [47:0] sml_ext       = {sig_sml, 24'b0};
    wire [47:0] sml_shifted   = sml_ext >> shamt;
    wire [23:0] sig_sml_align = sml_shifted[47:24];

    // ---- Add/subtract ----
    wire same_sign = (s_big == s_sml);
    // 25-bit sum to capture carry/borrow
    wire [24:0] raw = same_sign ? ({1'b0, sig_big} + {1'b0, sig_sml_align})
                                : ({1'b0, sig_big} - {1'b0, sig_sml_align});

    // ---- Normalize ----
    // raw[24] = carry (overflow); otherwise leading 1 is somewhere in raw[23:0]
    // Expand to 48 bits for clean left-shifting
    wire [47:0] raw_ext = {23'b0, raw};  // leading 1 is at raw[24] or lower

    // Priority: find highest set bit in raw[24:0]
    wire [4:0] lz;    // # of leading zeros above the leading 1 in raw[24:0]
    assign lz = raw[24] ? 5'd0 :
                raw[23] ? 5'd1 :
                raw[22] ? 5'd2 :
                raw[21] ? 5'd3 :
                raw[20] ? 5'd4 :
                raw[19] ? 5'd5 :
                raw[18] ? 5'd6 :
                raw[17] ? 5'd7 :
                raw[16] ? 5'd8 :
                raw[15] ? 5'd9 :
                raw[14] ? 5'd10 :
                raw[13] ? 5'd11 :
                raw[12] ? 5'd12 :
                raw[11] ? 5'd13 :
                raw[10] ? 5'd14 :
                raw[9]  ? 5'd15 :
                raw[8]  ? 5'd16 :
                raw[7]  ? 5'd17 :
                raw[6]  ? 5'd18 :
                raw[5]  ? 5'd19 :
                raw[4]  ? 5'd20 :
                raw[3]  ? 5'd21 :
                raw[2]  ? 5'd22 :
                raw[1]  ? 5'd23 :
                raw[0]  ? 5'd24 : 5'd25;   // 25 = all zeros (result is 0)

    // After left-shifting raw by lz, the leading 1 is at bit 24.
    // The 23-bit mantissa is bits [23:1] of the shifted value (just below the leading 1).
    // raw_ext pads raw to 48 bits; after <<lz, norm[24] = leading 1, norm[23:1] = mantissa.
    wire [47:0] norm    = raw_ext << lz;
    wire [22:0] mant_out = norm[23:1];      // *** 23 bits immediately below the leading 1 ***

    // Exponent formula (derived from first principles):
    //   position p of leading 1 in raw = 24 - lz
    //   exp_out = exp_big - 23 + p = exp_big + 1 - lz
    wire [8:0] exp_adj = {1'b0, exp_big} + 9'd1 - {4'b0, lz};
    wire [7:0] exp_out = (raw == 0)  ? 8'h00 :
                         exp_adj[8]  ? 8'hFF :   // overflow -> inf
                                       exp_adj[7:0];

    // ---- Repack ----
    always_comb begin
        if (a_nan || b_nan)
            result = 32'h7FC00000;
        else if (a_inf && b_inf && (sa != sb))
            result = 32'h7FC00000;
        else if (a_inf) result = a;
        else if (b_inf) result = b;
        else if (a_zero) result = b;
        else if (b_zero) result = a;
        else if (raw == 0) result = 32'h00000000;
        else if (exp_out == 8'hFF) result = {s_big, 8'hFF, 23'h0};
        else result = {s_big, exp_out, mant_out};
    end
endmodule
