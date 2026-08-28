module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  // Propagate and Generate signals
  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  
  // Carry signals
  wire c1, c2, c3;

  // Intermediate AND product terms for carry equations
  wire p0_cin;
  wire p1_g0, p1_p0_cin;
  wire p2_g1, p2_p1_g0, p2_p1_p0_cin;
  wire p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_cin;

  // Step 1: Generate & Propagate signals (1 XOR + 1 AND per bit)
  xor #(2) g_p0 (p0, a[0], b[0]);
  and #(2) g_g0 (g0, a[0], b[0]);

  xor #(2) g_p1 (p1, a[1], b[1]);
  and #(2) g_g1 (g1, a[1], b[1]);

  xor #(2) g_p2 (p2, a[2], b[2]);
  and #(2) g_g2 (g2, a[2], b[2]);

  xor #(2) g_p3 (p3, a[3], b[3]);
  and #(2) g_g3 (g3, a[3], b[3]);

  // Step 2: Lookahead Carry Logic
  // --- C1 = g0 + p0*cin ---
  and #(2) g_c1_1 (p0_cin, p0, cin);
  or  #(2) g_c1   (c1, g0, p0_cin);

  // --- C2 = g1 + p1*g0 + p1*p0*cin ---
  and #(2) g_c2_1 (p1_g0, p1, g0);
  and #(2) g_c2_2 (p1_p0_cin, p1, p0, cin);
  or  #(2) g_c2   (c2, g1, p1_g0, p1_p0_cin);

  // --- C3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin ---
  and #(2) g_c3_1 (p2_g1, p2, g1);
  and #(2) g_c3_2 (p2_p1_g0, p2, p1, g0);
  and #(2) g_c3_3 (p2_p1_p0_cin, p2, p1, p0, cin);
  or  #(2) g_c3   (c3, g2, p2_g1, p2_p1_g0, p2_p1_p0_cin);

  // --- C4 (cout) = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*cin ---
  and #(2) g_c4_1 (p3_g2, p3, g2);
  and #(2) g_c4_2 (p3_p2_g1, p3, p2, g1);
  and #(2) g_c4_3 (p3_p2_p1_g0, p3, p2, p1, g0);
  and #(2) g_c4_4 (p3_p2_p1_p0_cin, p3, p2, p1, p0, cin);
  or  #(2) g_c4   (cout, g3, p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_cin);

  // Step 3: Sum computation (Sum[i] = P[i] ^ C[i])
  xor #(2) g_s0 (sum[0], p0, cin);
  xor #(2) g_s1 (sum[1], p1, c1);
  xor #(2) g_s2 (sum[2], p2, c2);
  xor #(2) g_s3 (sum[3], p3, c3);

endmodule