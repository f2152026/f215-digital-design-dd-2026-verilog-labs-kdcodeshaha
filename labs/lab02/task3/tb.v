
// tb.v  (Task 3: self-checking testbench for comp2)
module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  reg        exp_gt, exp_lt, exp_eq;
  integer    i, errors;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    for (i = 0; i < 16; i = i + 1) begin
      {t_a, t_b} = i[3:0];
      #5;

      // Expected values, worked out independently of the design
      exp_gt = 0; exp_lt = 0; exp_eq = 0;
      if (t_a > t_b)       exp_gt = 1;
      else if (t_a < t_b)  exp_lt = 1;
      else                 exp_eq = 1;

      if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
        $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                 $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        errors = errors + 1;
      end
    end

    $write("Summary: %0d of 16 combinations passed", 16 - errors);
    if (errors == 0) $write(" -- ALL PASS");
    $write("\n");
    $finish;
  end

  // Development aid: watch every change live
  initial
    $monitor($time, " A=%b B=%b | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule