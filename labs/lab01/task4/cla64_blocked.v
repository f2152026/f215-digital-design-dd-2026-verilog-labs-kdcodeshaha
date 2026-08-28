module cla64_blocked(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [16:0] c;
  assign c[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_blocks
      cla4 block (
        .a(a[4*i+3 : 4*i]),
        .b(b[4*i+3 : 4*i]),
        .cin(c[i]),
        .sum(sum[4*i+3 : 4*i]),
        .cout(c[i+1])
      );
    end
  endgenerate

  assign cout = c[16];

endmodule