module pipe_pc_test;
  parameter period = 20;
  reg clk, rst_n;
  reg [31:0] ir;
  top#(.pre_i("/users/course/2015F/cs4125/dsd18/final/test/if_test.dat"),
       .pre_d("/users/course/2015F/cs4125/dsd18/final/test/if_test.dat")) 
       t(clk, rst_n);

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
    rst_n = 0;
    #(period) rst_n = 1;
    /*#(period) ir    = 32'hffff_cccc;
    #(period) ir    = 32'habff_aaaa;
    #(period) ir    = 32'hcdff_dddd;
    #(period) ir    = 32'hcdff_dddd;
    #(period) ir    = 32'hade1_8712;
    #(period) ir    = 32'hacdc_9638;
    #(period) ir    = 32'h6312_8888;
    #(period) ir    = 32'h7fff_ffff;
    #(period) ir    = 32'h8000_0000;
    #(period) ir    = 32'h1234_abcd;
    #(period) ir    = 32'h1234_abcd;*/
    #(period) ir    = 32'h4470_7fff;
    /*#(period) ir    = 32'h0487_b400;
    #(period) ir    = 32'h0ac4_2000;
    #(period) ir    = 32'h10e6_2800;
    #(period) ir    = 32'h14f6_3800;*/
    #(period) ir    = 32'h0000_0000;
    #(period) ir    = 32'h4413_ffff;
    #(12*period)
    $finish;
  end

endmodule
