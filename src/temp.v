
module top 
#(parameter pre_i="ins.dat", pre_d="bin.dat")
( clk, rst_n , halt);
  input clk, rst_n;
  output halt;
  wire   im_oen, dm_oen, dm_wen;
  wire   [31:0] ir;
  wire   [10:0] ins_addr;
  wire   [31:0] dm_in;
  wire   [31:0] dm_out;
  wire   [10:0] data_addr;

  RAM2Kx32 
  #(.preload_file(pre_i))
  IM ( .Q(ir), .A(ins_addr), .D({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0}), .CLK(clk), .CEN(1'b0), .OEN(1'b0 & !rst_n), .WEN(1'b1) );
  RAM2Kx32 
  #(.preload_file(pre_d))
  DM ( .Q(dm_in), .A(data_addr), .D(dm_out), .CLK(clk), .CEN(1'b0), 
        .OEN(dm_oen), .WEN(dm_wen) );
  pipeline p_line ( .clk(clk), .rst_n(rst_n), .IR(ir), .D_IN(dm_in), .D_OUT(
        dm_out), .I_ADDR(ins_addr), .D_ADDR(data_addr), .im_oen(im_oen), 
        .dm_oen(dm_oen), .dm_wen(dm_wen), .halt(halt) );
endmodule
