// 32-bits ISA, so we needs to decode
// 7 bits opcode, and 3 32bits register address,
// opcode : 31-25
// DA     : 24-20
// AA     : 19-15
// BA     : 14-10


// decode result :
// bits:      5            5           5          1       4       1    1    1    1    1    1
//      --------------------------------------------------------------------------------------
//      |            |            |            |    |          |    |    |    |    |    |    | 
//      |     DA     |     AA     |     BA     | MB |    FS    | MD | RW | MW | PL | JB | BC |
//      |   [25:21]  |   [20:16]  |   [15:11]  |[10]|  [9:6]   | [5]| [4]| [3]| [2]| [1]| [0]| 
//      --------------------------------------------------------------------------------------
//

module instruction_decoder (
  input  wire  [31:0] instruction,
  output wire  [25:0]control_word
);
wire  [4:0]  DA;
wire  [4:0]  AA;
wire  [4:0]  BA;
wire         MB;
wire  [4:0]  FS;
wire  [4:0]  SH;
wire         MD;
wire         RW;
wire         MW;
wire         PL;
wire         JB;
wire         BC;

assign DA = instruction[24:20];
assign AA = instruction[19:15];
assign BA = instruction[14:10];
assign MB = instruction[31];
assign FS = {instruction[28:16], ~PL & instruction[25]};
assign SH = instruction[4:0];
assign MD = instruction[29];
assign RW = ~(instruction[30]);
assign MW = ~(instruction[31]) & instruction[30];
assign PL = instruction[31] & instruction[30];
assign JB = instruction[29];
assign BC = instruction[25];
assign control_word = {DA, AA, BA, MB, FS, MD, RW, MW, PL, JB, BC};

endmodule
