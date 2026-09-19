`timescale 1ns/1ps

module tb;

  // Declarations: inputs driven by the testbench are reg,
  // the output driven by the DUT is wire.
  reg  t_I0, t_I1, t_S;
  wire t_Y;

  reg  exp_Y;
  integer i;
  integer errors;

  // DUT instantiation (module is named DUT in dut.v)
  DUT U0 (
    .I0 (t_I0),
    .I1 (t_I1),
    .S  (t_S),
    .Y  (t_Y)
  );

  // Optional: waveform dump
  initial begin
    $dumpfile("mux.vcd");
    $dumpvars(0, tb);
  end

  // Live monitor during development
  initial
    $monitor("t=%0t  S=%b I1=%b I0=%b  ->  Y=%b", $time, t_S, t_I1, t_I0, t_Y);

  // Stimulus: all 8 combinations, 5 time units apart
  initial begin
    errors = 0;
    for (i = 0; i < 8; i = i + 1) begin
      {t_S, t_I1, t_I0} = i[2:0];
      #5;
      exp_Y = t_S ? t_I1 : t_I0;
      if (t_Y !== exp_Y) begin
        $display("FAIL at %0t: S=%b I1=%b I0=%b got Y=%b expected %b",
                 $time, t_S, t_I1, t_I0, t_Y, exp_Y);
        errors = errors + 1;
      end
    end
    $display("Result: %0d of 8 combinations passed", 8 - errors);
    $finish;
  end

endmodule
