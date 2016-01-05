module register_file (
  input clk,
  input rst_n,
  input RW,
  input  [4:0]  DA,
  input  [4:0]  AA,
  input  [4:0]  BA,
  input  [31:0] BUS_D,
  output reg [31:0] REG_A,
  output reg [31:0] REG_B
);

  reg [31:0] R00, R01, R02, R03, R04, R05, R06, R07, R08, R09, R10, R11, R12, R13, R14, R15,
             R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31;


  always @(posedge clk) begin
    if(!rst_n) begin
      R00 = 0;
      R01 = 0;
      R02 = 0;
      R03 = 0;
      R04 = 0;
      R05 = 0;
      R06 = 0;
      R07 = 0;
      R08 = 0;
      R09 = 0;
      R10 = 0;
      R11 = 0;
      R12 = 0;
      R13 = 0;
      R14 = 0;
      R15 = 0;
      R16 = 0;
      R17 = 0;
      R18 = 0;
      R19 = 0;
      R20 = 0;
      R21 = 0;
      R22 = 0;
      R23 = 0;
      R24 = 0;
      R25 = 0;
      R26 = 0;
      R27 = 0;
      R28 = 0;
      R29 = 0;
      R30 = 0;
      R31 = 0;
    end else begin
      if(RW) begin
        case(DA)
          5'd01 : R01 = BUS_D;
          5'd02 : R02 = BUS_D;
          5'd03 : R03 = BUS_D;
          5'd04 : R04 = BUS_D;
          5'd05 : R05 = BUS_D;
          5'd06 : R06 = BUS_D;
          5'd07 : R07 = BUS_D;
          5'd08 : R08 = BUS_D;
          5'd09 : R09 = BUS_D;
          5'd10 : R10 = BUS_D;
          5'd11 : R11 = BUS_D;
          5'd12 : R12 = BUS_D;
          5'd13 : R13 = BUS_D;
          5'd14 : R14 = BUS_D;
          5'd15 : R15 = BUS_D;
          5'd16 : R16 = BUS_D;
          5'd17 : R17 = BUS_D;
          5'd18 : R18 = BUS_D;
          5'd19 : R19 = BUS_D;
          5'd20 : R20 = BUS_D;
          5'd21 : R21 = BUS_D;
          5'd22 : R22 = BUS_D;
          5'd23 : R23 = BUS_D;
          5'd24 : R24 = BUS_D;
          5'd25 : R25 = BUS_D;
          5'd26 : R26 = BUS_D;
          5'd27 : R27 = BUS_D;
          5'd28 : R28 = BUS_D;
          5'd29 : R29 = BUS_D;
          5'd30 : R30 = BUS_D;
          5'd31 : R31 = BUS_D;
        endcase
      end
    end
  end

  // read out data from register file.
  always @(*) begin

    case(AA)
      5'd01 : REG_A = R01;
      5'd02 : REG_A = R02;
      5'd03 : REG_A = R03;
      5'd04 : REG_A = R04;
      5'd05 : REG_A = R05;
      5'd06 : REG_A = R06;
      5'd07 : REG_A = R07;
      5'd08 : REG_A = R08;
      5'd09 : REG_A = R09;
      5'd10 : REG_A = R10;
      5'd11 : REG_A = R11;
      5'd12 : REG_A = R12;
      5'd13 : REG_A = R13;
      5'd14 : REG_A = R14;
      5'd15 : REG_A = R15;
      5'd16 : REG_A = R16;
      5'd17 : REG_A = R17;
      5'd18 : REG_A = R18;
      5'd19 : REG_A = R19;
      5'd20 : REG_A = R20;
      5'd21 : REG_A = R21;
      5'd22 : REG_A = R22;
      5'd23 : REG_A = R23;
      5'd24 : REG_A = R24;
      5'd25 : REG_A = R25;
      5'd26 : REG_A = R26;
      5'd27 : REG_A = R27;
      5'd28 : REG_A = R28;
      5'd29 : REG_A = R29;
      5'd30 : REG_A = R30;
      5'd31 : REG_A = R31;
      default:REG_A = 0;
    endcase

    case(BA)
      5'd01 : REG_B = R01;
      5'd02 : REG_B = R02;
      5'd03 : REG_B = R03;
      5'd04 : REG_B = R04;
      5'd05 : REG_B = R05;
      5'd06 : REG_B = R06;
      5'd07 : REG_B = R07;
      5'd08 : REG_B = R08;
      5'd09 : REG_B = R09;
      5'd10 : REG_B = R10;
      5'd11 : REG_B = R11;
      5'd12 : REG_B = R12;
      5'd13 : REG_B = R13;
      5'd14 : REG_B = R14;
      5'd15 : REG_B = R15;
      5'd16 : REG_B = R16;
      5'd17 : REG_B = R17;
      5'd18 : REG_B = R18;
      5'd19 : REG_B = R19;
      5'd20 : REG_B = R20;
      5'd21 : REG_B = R21;
      5'd22 : REG_B = R22;
      5'd23 : REG_B = R23;
      5'd24 : REG_B = R24;
      5'd25 : REG_B = R25;
      5'd26 : REG_B = R26;
      5'd27 : REG_B = R27;
      5'd28 : REG_B = R28;
      5'd29 : REG_B = R29;
      5'd30 : REG_B = R30;
      5'd31 : REG_B = R31;
      default:REG_B = 0;
    endcase

  end

endmodule
