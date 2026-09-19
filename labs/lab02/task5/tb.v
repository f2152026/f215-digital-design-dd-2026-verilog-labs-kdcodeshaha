module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] exp_result;
  integer    i, j, errors, total;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Wait for the ALU to settle, compute the expected value independently
  // (4-bit wraparound), and compare.
  task check;
    begin
      #5;
      exp_result = t_op ? (t_a - t_b) : (t_a + t_b);
      total = total + 1;
      if (t_result !== exp_result) begin
        $display("FAIL at %0t: a=%0d b=%0d op=%b  got %0d expected %0d",
                 $time, t_a, t_b, t_op, t_result, exp_result);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;

    // Phase 1: SAME operands, only op changes (exposes the sensitivity bug)
    t_a = 4'd9; t_b = 4'd5;
    t_op = 0; check;
    t_op = 1; check;
    t_op = 0; check;
    t_op = 1; check;

    // Phase 2: op held fixed, operands changing (add, then sub)
    t_op = 0;
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i; t_b = j; check;
      end
    t_op = 1;
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i; t_b = j; check;
      end

    // Phase 3: operands changing AND op toggling for every pair
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i; t_b = j;
        t_op = 0; check;
        t_op = 1; check;
      end

    $display("Summary: %0d of %0d checks passed", total - errors, total);
    if (errors == 0) $display("ALL PASS");
    $finish;
  end

endmodule
