module func_test_unit;
  parameter period = 20;
  reg [3:0] FS;
  reg [4:0] SH;
  reg [31:0] A;
  reg [31:0] B;
  wire V, C, N, Z;
  wire [31:0] F;

  func_unit funit(FS, SH, A, B, V, C, N, Z, F);

  initial begin
    `ifdef NETLIST
      $sdf_annotate("../src/func_unit.sdf", funit);
      $fsdbDumpfile("func_unit_syn.fsdb");
    `else
      $fsdbDumpfile("func_unit.fsdb");
    `endif
    $fsdbDumpvars;
  end


  initial begin
    #(period) add_a1(32'd5);
    #(period) add_a1(32'd8);
    #(period) add_a1(32'd11);
    #(period) add_a1(32'hFFFF_FFFF);
    #(period) add_a1(32'd31);
    #(period) add_a1(32'd0);
    #(period) add_ab1(32'd5, 32'd10);
    #(period) add_ab1(32'd9, 32'd11);
    #(period) add_ab1(32'd7, 32'd12);
    #(period) add_ab1(32'd8, 32'd13);
    #(period) add_ab1(32'd9, 32'd14);
    #(period) add_ab1(32'hFFFF_FFF0, 32'h0000_000E);
    #(period) add_ab1(32'hFFFF_FFFF, 32'd0);
    #(period) add_ab(32'h7FFF_FFFF, 32'd1);
    #(period) add_anb(32'h7FFF_FFFF, 32'd1);
    #(period) add_anb1(32'h7FFF_FFFF, 32'd1);
    #(period) sub_a1(32'hFFFF_FFFF);
    #(period) sub_a1(32'd1);
    #(period) mova(32'd10);
    #(period) mova_2(32'd10);
    #(period) log_and(32'h0FFF_FFFF, 32'hFFFF_FFFF);
    #(period) log_and(32'h0000_0000, 32'hFFFF_FFFF);
    #(period) log_or(32'h0000_0000, 32'hFFFF_FFFF);
    #(period) log_or(32'hF000_0000, 32'h0FFF_FFFF);
    #(period) log_xor(32'hF000_0000, 32'h0FFF_FFFF);
    #(period) log_xor(32'h0000_FFFF, 32'h0FFF_FFFF);
    #(period) log_xor(32'h0000_FFFF, 32'h0FFF_FFFF);
    #(period) movna(32'h0000_0001);
    #(period) movb(32'h0000_0001);
    #(period) lsl(32'h0000_0001, 5'd31);
    #(period) lsl(32'h0000_0001, 5'd6);
    #(period) lsr(32'h8000_0000, 5'd31);
    #(period) lsr(32'h8000_0000, 5'd4);
    #(period) mova(0);
  end

  task mova;
    input [31:0] num;
    begin
      FS = 4'b0000;
      A = num;
    end
  endtask

  task add_a1;
    input [31:0] num;
    begin
      FS = 4'b0001;
      A = num;
    end
  endtask

  task add_ab;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b0010;
      A = num_A;
      B = num_B;
    end
  endtask

  task add_ab1;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b0011;
      A = num_A;
      B = num_B;
    end  
  endtask

  task add_anb;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b0100;
      A = num_A;
      B = num_B;
    end  
  endtask

  task add_anb1;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b0101;
      A = num_A;
      B = num_B;
    end  
  endtask
  
  task sub_a1;
    input [31:0] num;
    begin
      FS = 4'b0110;
      A = num;
    end  
  endtask

  task mova_2;
    input [31:0] num;
    begin
      FS = 4'b0111;
      A = num;
    end  
  endtask
  
  task log_and;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b1000;
      A = num_A;
      B = num_B;
    end  
  endtask
  
  task log_or;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b1001;
      A = num_A;
      B = num_B;
    end  
  endtask
  
  task log_xor;
    input [31:0] num_A;
    input [31:0] num_B;
    begin
      FS = 4'b1010;
      A = num_A;
      B = num_B;
    end  
  endtask
  
  task movna;
    input [31:0] num;
    begin
      FS = 4'b1011;
      A = num;
    end  
  endtask
  
  task movb;
    input [31:0] num;
    begin
      FS = 4'b1100;
      B = num;
    end  
  endtask

  task lsr;
    input [31:0] num;
    input [4:0]  sh;
    begin
      FS = 4'b1101;
      B = num;
      SH = sh;
    end
  endtask
  
  task lsl;
    input [31:0] num;
    input [4:0]  sh;
    begin
      FS = 4'b1110;
      B = num;
      SH = sh;
    end
  endtask
endmodule
