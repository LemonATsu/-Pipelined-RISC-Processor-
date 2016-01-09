`ifndef FPATH
  `define FPATH \"if_test.dat\" //"
`endif

`ifndef CYC
  `define CYC 300
`endif

module pipe_pc_test;
  parameter period = 20;
  reg clk, rst_n;
  reg [31:0] ir;
  top#(.pre_i(`FPATH),
       .pre_d(`FPATH)) 
       t(clk, rst_n);

  always #(period/2) clk = ~clk;
  initial begin
    `ifdef NETLIST
      $sdf_annotate("../src/top.sdf", t);
      $fsdbDumpfile("top_syn.fsdb");
      $display("Syn!!!!!!!!!");
    `else
      $fsdbDumpfile("pipeline.fsdb");
    `endif
    $fsdbDumpvars;
  end

  initial begin
    clk = 0;
    ir = 0;
    rst_n = 0;
    #(period);
    #(period/2) rst_n = 1;
    #(`CYC*period)
    $display (`FPATH);
    $finish;
  end

endmodule
