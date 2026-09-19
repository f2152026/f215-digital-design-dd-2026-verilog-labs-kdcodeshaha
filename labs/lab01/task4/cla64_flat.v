module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:0] c;

  // Step 1: Bitwise Generate (g) and Propagate (p) signals
  assign #(2) p = a ^ b;
  assign #(2) g = a & b;

  // Set initial carry-in
  assign c[0] = cin;

  // Step 2: Generate all 64 carry bits using expand-on-fly or iterative calculation
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_carry
      assign #(2) c[i+1] = g[i] | (p[i] & c[i]);
    end
  endgenerate

  // Step 3: Compute sum bits and final carry out
  assign #(2) sum = p ^ c[63:0];
  assign cout = c[64];

endmodule