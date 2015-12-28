module pipeline(
  input clk, rst_n
  `ifdef N_MEM_TEST
  ,input [31:0] IR
  `endif
);


wire [31:0] BrA, RAA;
reg  [31:0] MUX_C, PC_NEXT;
reg  [31:0] PC, PC_1, PC_2;      // Per stage PC, maintain the PC of the stage.
wire [1:0]  C_SELECT;

`ifndef N_MEM_TEST
wire [31:0] IR;                  // for IF, Came out from ins memory. 
`endif


wire HA, HB;                     // for ID, came out from fwd unit.
wire MA, MB;                     // for ID, came out from ins decoder.
wire CS;                         // for ID, came out from ins decoder.
wire ID_RW, ID_PS, ID_MW;        // for ID, came out from ins decoder.
wire [1:0]  ID_MD, ID_BS;        // for ID, came out from ins decoder
wire [3:0]  ID_FS;               // for ID, came out from ins decoder
wire [4:0]  ID_DA, ID_AA, ID_BA; // for ID, came out from ins decoder.
wire [31:0] RA, RB;              // for ID, came out from reg file.
reg  [31:0] BUS_A, BUS_B;        // for ID, came out from reg A/B.
reg  [31:0] FWD;                 // for ID, came out from fwd unit.
reg  [31:0] IM;                  // for ID, came out from constant unit.
reg  [4:0]  ID_SH;               // for ID, came out from IR directly.

wire V, C, N, Z;                 // for EX, came out from func unit.
wire [31:0]   F;                 // for EX, came out from func unit.
reg  EX_RW, EX_PS, EX_MW;        // for EX, came from ID stage.
reg  [1:0]  EX_MD, EX_BS;        // for EX, came from ID stage.
reg  [4:0]  EX_DA;               // for EX, came out from ins decoder.
reg  [3:0]  EX_FS;               // for EX, came from ID stage.
reg  [4:0]  EX_SH;               // for EX, came from ID stage.
reg  [31:0] BUS_D;          

/* Stage manager */
  // handle per stage pc.
  always @(posedge clk) begin
    if(!rst_n) begin
      {PC, PC_1, PC_2} = 0;
    end else begin
      PC_2  = PC_1;
      PC_1  = PC;
      PC    = PC_NEXT;
    end
  end

  always @(*) begin
    PC_NEXT = PC + 1;
    case(C_SELECT)
      2'b01 : PC_NEXT = BrA;
      2'b10 : PC_NEXT = RAA;
      2'b11 : PC_NEXT = BrA;
    endcase
  end

  // handle shift amount between ID and EX.
  always @(posedge clk) begin
    if(!rst_n) begin
      {ID_SH, IM} = 0;
    end else begin
      EX_SH = ID_SH;
      ID_SH = IR[4:0];
    end
  end

  // Handle things that will pass to next stage.
  always @(posedge clk) begin
      if(!rst_n) begin
        {EX_FS, EX_DA, EX_MD, EX_BS, EX_PS, EX_FS} = 0;
      end else begin
        EX_RW = ID_RW;
        EX_DA = ID_DA;
        EX_MD = ID_MD;
        EX_BS = ID_BS;
        EX_PS = ID_PS;
        EX_MW = ID_MW;
        EX_FS = ID_FS;
      end
  end

/* stage : IF */

// step 1. retreive IR from instruction memory.
// step 2. if branch happen, make it become nop.



/* stage : ID */
register_file       REGF (.clk(clk) , .rst_n(rst_n), 
                          .DA(ID_DA), .AA(ID_AA), .BA(ID_BA), .BUS_D(BUS_D),
                          .REG_A(RA), .REG_B(RB));

instruction_decoder INSDE(.IR(IR)   , .DA(ID_DA), .AA(ID_AA), .BA(ID_BA),
                          .RW(ID_RW), .MD(ID_MD), .BS(ID_BS), .PS(ID_PS), 
                          .MW(ID_MW), .FS(ID_FS), .MB(MB)   , .MA(MA)   , .CS(CS));
  // constant unit
  always @(*) begin
    IM = {17'h0_0000 ,IR[14:0]};
    // IF CS is true, and the leftmost of imm is 1,
    // it need to be extend.
    if(CS & IR[14]) begin
      IM = {17'h1_ffff, IR[14:0]};
    end
  end
  
  // mux A
  always @(*) begin
    BUS_A = RA;
    case({HA, MA})
      2'b00 : BUS_A = RA;
      2'b01 : BUS_A = PC_1; // for JML
      3'b10 : BUS_A = FWD;
    endcase
  end

  // mux B
  always @(*) begin
    BUS_B = RB;
    case({HB, MB})
      2'b00 : BUS_B = RB;
      2'b01 : BUS_B = IM; // for constant.
      3'b10 : BUS_B = FWD;
    endcase
  end


/* stage : EX */
func_unit FUNCUNIT(.FS(EX_FS), .SH(EX_SH), .A(BUS_A), .B(BUS_B), 
                    .V(V), .C(C), .N(N), .Z(Z), .F(F));


/* stage : ME */

/* stage : WB */



endmodule
