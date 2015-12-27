module pipe_pc_test;
  parameter period = 20;
  reg clk, rst_n;

  pipeline p(clk, rst_n);

  always #(period) clk = ~clk;

  initial begin
    `ifdef NETLIST
      $sdf_annotate("../src/pipeline.sdf", funit);
      $fsdbDumpfile("pipeline_syn.fsdb");
    `else
      $fsdbDumpfile("pipeline.fsdb");
    `endif
    $fsdbDumpvars;
  end

  initial begin
    clk = 0;
    #(period) rst_n = 0;
    #(period) rst_n = 1;
    #(12*period)
    $finish;
  end

endmodule
