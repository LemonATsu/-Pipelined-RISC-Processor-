// 32-bits ISA, so we needs to decode
// 7 bits opcode, and 3 32bits register address,
// opcode : 31-25
// DA     : 24-20
// AA     : 19-15
// BA     : 14-10

module instruction_decoder (
    input  wire [31:0] IR,
    output wire [4:0]  DA,
    output wire [4:0]  AA,
    output wire [4:0]  BA,
    output reg         RW,
    output reg  [1:0]  MD,
    output reg  [1:0]  BS,
    output reg         PS,
    output reg         MW,
    output reg  [3:0]  FS,
    output reg         MB,
    output reg         MA,
    output reg         CS
    );
wire [6:0] opcode;

assign DA     = IR[24:20];
assign AA     = IR[19:15];
assign BA     = IR[14:10];
assign opcode = IR[31:25];

parameter NOP  = 7'b000_0000,
          MOVA = 7'b100_0000,
          ADD  = 7'b000_0010,
          SUB  = 7'b000_0101,
          AND  = 7'b000_1000,
          OR   = 7'b000_1001,
          XOR  = 7'b000_1010,
          NOT  = 7'b000_1011,
          ADI  = 7'b010_0010,
          SBI  = 7'b010_0101,
          ANI  = 7'b010_1000,
          ORI  = 7'b010_1001,
          XRI  = 7'b010_1010,
          AIU  = 7'b100_0010,
          SIU  = 7'b100_0101,
          MOVB = 7'b000_1100,
          LSR  = 7'b000_1101,
          LSL  = 7'b000_1110,
          LD   = 7'b001_0000,
          ST   = 7'b010_0000,
          JMR  = 7'b111_0000,
          SLT  = 7'b110_0101,
          BZ   = 7'b110_0000,
          BNZ  = 7'b100_1000,
          JMP  = 7'b110_1000,
          JML  = 7'b011_0000;

  always @(*) begin
    RW = 0;
    MD = 0;
    BS = 0;
    PS = 0;
    MW = 0;
    MB = 0;
    MA = 0;
    CS = 0;
    FS = opcode[3:0];
    case(opcode)
      // These instructions need only RW, other part are either 0 or don't care.
      // Just all to 0, and RW to 1.
      MOVA,
      MOVB,
      ADD ,
      SUB ,
      AND , 
      OR  ,
      XOR ,
      LSR ,
      LSL ,
      NOT  : RW = 1'b1;
      // These instructions need RW, MB, CS. Other are either 0 or don't care.
      ADI ,
      SBI  : {RW, MB, CS} = 3'b1_1_1;
      // These instructions need only RW and MB.
      ANI ,
      ORI ,
      XRI ,
      AIU ,
      SIU  : {RW, MB}             = 2'b1_1;
      LD   : {RW, MD}             = 3'b1_01;
      ST   : MW                   = 1'b1;
      JMR  : BS                   = 2'b10;
      SLT  : {RW, MD}             = 3'b1_10;
      BZ   : {BS, MB, CS}         = 4'b01_1_1;
      BNZ  : {BS, PS, FS, MB, CS} = 9'b01_1_0000_1_1;
      JMP  : {BS, MB, CS}         = 4'b11_1_1;
      JML  : {RW, BS, MB, MA, CS} = 6'b1_11_1_1_1;
    endcase
  end




endmodule
