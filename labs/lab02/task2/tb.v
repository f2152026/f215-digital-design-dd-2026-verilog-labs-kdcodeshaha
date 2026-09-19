
module tb;

  localparam N = 8;              // number of ROM locations to test

  reg  [2:0] t_sel;              // 3 bits covers DEPTH = 4 and DEPTH = 8
  wire [7:0] t_dout;             // matches WIDTH = 8

  reg  [7:0] exp_dout;
  integer i;
  integer errors;

  // Parameter override (different from the module's default DEPTH = 4)
  lut #(.WIDTH(8), .DEPTH(N)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
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
    t_sel  = 0;
    #1;                          // let the ROM initialize before reading
    for (i = 0; i < N; i = i + 1) begin
      t_sel = i;
      #5;
      exp_dout = i * i;
      if (t_dout !== exp_dout) begin
        $display("FAIL at %0t: sel=%0d got dout=%0d expected %0d",
                 $time, t_sel, t_dout, exp_dout);
        errors = errors + 1;
      end
    end
    $display("Result: %0d of %0d addresses passed", N - errors, N);
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule

