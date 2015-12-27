module pipe_pc_test;
  parameter period = 20;
  reg clk, rst_n;
  reg [31:0] ir;
  pipeline p(clk, rst_n, ir);

  always #(period/2) clk = ~clk;

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
    ir = 0;
    #(period) rst_n = 0;
    #(period) rst_n = 1;
    #(period/2); 
    #(period) ir    = 32'hffff_cccc;
    #(period) ir    = 32'habff_aaaa;
    #(period) ir    = 32'hcdff_dddd;
    #(12*period)
    $finish;
  end

endmodule
