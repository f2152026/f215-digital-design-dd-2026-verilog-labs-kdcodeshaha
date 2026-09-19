module cla4_dataflow(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire [3:0] p, g;
  wire c1, c2, c3;

  // Step 1: Generate & Propagate buses
  assign #(2) p = a ^ b;
  assign #(2) g = a & b;

  // Step 2: Lookahead Carry Logic
  assign #(2) c1   = g[0] | (p[0] & cin);
  assign #(2) c2   = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
  assign #(2) c3   = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
  assign #(2) cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);

  // Step 3: Sum computation
  assign #(2) sum  = p ^ {c3, c2, c1, cin};

endmodule