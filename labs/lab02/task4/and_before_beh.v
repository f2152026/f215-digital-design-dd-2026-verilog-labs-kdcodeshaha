

module and_beh_before (
  input      a,
  input      b,
  output reg y
);
  always @(*)
    #1 y = a & b;           // delay BEFORE the assignment
endmodule

