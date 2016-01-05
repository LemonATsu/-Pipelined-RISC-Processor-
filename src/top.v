module top
#(parameter pre_i="ins.dat", pre_d="bin.dat")(
  input clk,
  input rst_n
  //input [31:0]ir
);

wire [31:0] dm_in, dm_out;
wire [31:0] im_in, im_out;
wire [10:0] data_addr, ins_addr;
wire im_oen, dm_oen, dm_wen;
wire [31:0 ]ir;
assign ir = im_in;

pipeline p_line(.clk(clk)       , .rst_n(rst_n)  ,
                .IR(ir)      , .I_ADDR(ins_addr),
                .D_IN(dm_in)    , .D_OUT(dm_out)   , .D_ADDR(data_addr),
                .im_oen(im_oen) , .dm_oen(dm_oen)  , .dm_wen(dm_wen)  );

RAM2Kx32 #(
  .preload_file(pre_i)
  ) IM (
    .Q(im_in),
    .CLK(clk),
    .CEN(1'b0),
    .WEN(1'b1),
    .A(ins_addr),
    .OEN(im_oen)
  );


RAM2Kx32 #(
  .preload_file(pre_d)
  ) DM (
    .Q(dm_in),
    .CLK(clk),
    .CEN(1'b0),
    .WEN(dm_wen),
    .A(data_addr),
    .D(dm_out),
    .OEN(dm_oen)
  );

endmodule
