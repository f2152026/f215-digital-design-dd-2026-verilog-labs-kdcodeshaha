module and_beh_intra (
  input      a,
  input      b,
  output reg y
);
  always @(*)
    y = #1 a & b;           // intra-assignment delay
endmodule


