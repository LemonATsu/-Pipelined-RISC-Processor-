module pipeline(
  input  clk, rst_n,
  input  [31:0] IR ,  // out from memory
  input  [31:0] D_IN,  // out from memory
  output reg [31:0] D_OUT, // go  into memory
  output reg [10:0] I_ADDR,
  output reg [10:0] D_ADDR,// memory access.
  output reg im_oen,
  output reg dm_oen,
  output reg dm_wen
);

reg  [31:0] BrA, RAA;
reg  [31:0] MUX_C, PC_NEXT;
reg  [31:0] PC, PC_1, PC_2;      // Per stage PC, maintain the PC of the stage.
reg  [1:0]  C_SELECT;
reg  [1:0]  C_SELECT_NEXT;

reg  HA, HB;                     // for ID, came out from fwd unit.
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
reg  flush_ID;                   // for ID, This will flush next IR.

wire V, C, N, Z;                 // for EX, came out from func unit.
wire [31:0]   F;                 // for EX, came out from func unit.
reg  [31:0] EX_BUSA, EX_BUSB;    // for EX, came from ID stage.
reg  EX_RW, EX_PS, EX_MW;        // for EX, came from ID stage.
reg  [1:0]  EX_MD, EX_BS;        // for EX, came from ID stage.
reg  [4:0]  EX_DA, EX_AA, EX_BA; // for EX, came from ID stage. Note that AA, BA may not be used. It's for modified to 5 stage.
reg  [3:0]  EX_FS;               // for EX, came from ID stage.
reg  [4:0]  EX_SH;               // for EX, came from ID stage.


reg WB_RW;                       // for WB, came from EX stage.
reg [1:0]  WB_MD;                // for WB, came from EX stage.
reg [4:0]  WB_DA;                // for WB, destination address.
reg [31:0] WB_F, WB_SLT, WB_DIN; // for WB, F came out from func unit, slt is smaller than flag, DIN is read from memory.
reg [31:0] BUS_D;          
reg WHA, WHB;
reg dm_onext, dm_wnext;

reg [31:0] instrc, instrc_next;



/* Stage manager */
  // Handle things that will pass to next stage.
  always @(posedge clk) begin
    if(!rst_n) begin
      // for pc.
      PC     = 0;
      PC_1   = 0;
      PC_2   = 0;
      I_ADDR = 0;
      im_oen = 1'b1;
      
      // for each stage. 
      WB_RW  = 0;
      WB_MD  = 0;
      WB_DA  = 0;
      WB_F   = 0;
      WB_SLT = 0;
      WB_DIN = 0;

      EX_FS    = 0;
      EX_RW    = 0;
      EX_DA    = 0;
      EX_MD    = 0;
      EX_BS    = 0;
      EX_PS    = 0;
      flush_ID = 0;
  end else begin
      // for pc.
      im_oen = 1'b0;
      PC_2   = PC_1;
      PC_1   = PC;
      PC     = PC_NEXT;
      I_ADDR = PC[10:0]; // fetch Instruction by PC_NEXT, else it will consume addtional cycle.
      // for each stage
      WB_RW   = EX_RW;
      WB_MD   = EX_MD;
      WB_DA   = EX_DA;
      WB_F    = F;
      WB_SLT  = {31'b0, N ^ Z};
      WB_DIN  = D_IN;
        
      EX_RW    = ID_RW;
      EX_DA    = ID_DA;
      EX_MD    = ID_MD;
      EX_BS    = ID_BS;
      EX_PS    = ID_PS;
      EX_MW    = ID_MW;
      EX_FS    = ID_FS;
      EX_BUSA  = BUS_A;
      EX_BUSB  = BUS_B;
      EX_SH    = ID_SH;
      flush_ID = C_SELECT;        
      D_OUT    = EX_BUSB;
    end
  end

/* stage : IF */
  always @(posedge clk) begin
    if(!rst_n) begin
      instrc = 0;
    end else begin
      instrc = instrc_next;
    end
  end
  
  always @(*) begin
    // C_SELECT to detect branch happen. flush_ID will help flush Instruction in ID
    instrc_next = ((C_SELECT != 2'b00) | flush_ID | !rst_n) ? 32'b0 : IR;
  end


/* stage : ID */
// Since all the input to REGFILE is block by clock,
// We don't need to have a clock port.
// WB_DA only change when clock raise.
// WB_RW only change when clock raise.
// WB_DIN, WB_F, WB_SLT only change when clock raise => BUS_D only change when clock raise.
// So basically, all port about register write only change when clock raise. 
register_file       REGF (.clk(clk), .rst_n(rst_n), .RW(WB_RW),
                          .DA(WB_DA), .AA(ID_AA)   , .BA(ID_BA), .BUS_D(BUS_D),
                          .REG_A(RA), .REG_B(RB));

instruction_decoder INSDE(.flush(|C_SELECT),
                          .IR(instrc), .DA(ID_DA), .AA(ID_AA), .BA(ID_BA),
                          .RW(ID_RW) , .MD(ID_MD), .BS(ID_BS), .PS(ID_PS), 
                          .MW(ID_MW) , .FS(ID_FS), .MB(MB)   , .MA(MA)   , .CS(CS));
  // constant unit
  always @(*) begin
    IM      = {17'h0_0000 ,instrc[14:0]};
    ID_SH   = instrc[4:0];
    // IF CS is true, and the leftmost of imm is 1,
    // it need to be extend.
    if(CS & instrc[14]) begin
      IM = {17'h1_ffff, instrc[14:0]};
    end
  end

  
  // mux A
  always @(*) begin
    case({WHA, HA, MA})
      3'b000 : BUS_A = RA;
      3'b001 : BUS_A = PC_1; // for JML
      3'b010,
      3'b110 : BUS_A = FWD;
      3'b100 : BUS_A = BUS_D;
      default: BUS_A = 0;
    endcase
  end

  // mux B
  always @(*) begin
    case({WHB, HB, MB})
      3'b000 : BUS_B = RB;
      3'b001 : BUS_B = IM; // for constant.
      3'b010 : BUS_B = FWD;
      3'b100 : BUS_B = BUS_D;
      default: BUS_B = 0;
    endcase
  end

  // Little trick :
  // It might take 2 cycle to retrieve data from memory
  // So we do it at ID, and then we can take it back when EX/WB.
  always @(posedge clk) begin
    if(!rst_n) begin
      dm_oen = 1'b1;
      dm_wen = 1'b1;
    end else begin
      dm_oen = dm_onext;
      dm_wen = dm_wnext;
    end
  end

  always @(*) begin
    dm_onext = 1'b1;
    dm_wnext = 1'b1;
    if(ID_MW)
      dm_wnext = 1'b0;
    if(ID_MD[0])
      dm_onext = 1'b0;
    if(dm_wen) begin
      D_ADDR = BUS_A;
    end else begin
      D_ADDR = EX_BUSA;
    end
  end


/* stage : EX */
func_unit FUNCUNIT(.FS(EX_FS), .SH(EX_SH), .A(EX_BUSA), .B(EX_BUSB), 
                    .V(V), .C(C), .N(N), .Z(Z), .F(F));


  // hazard detect unit 
  always @(*) begin
    // if EX_RW == 0, then data hazard won't happend.
    // if |EX_DA == 0, then data hazard won't happend because R0 need to be 0 all the time.
    // if MA/MB = 1, if means that it don't need REG A/B
    // finally, DA need to be equal to rather AA or BA.
    HA = (EX_RW) & (|EX_DA) & ~(MA) & (EX_DA == ID_AA);
    HB = (EX_RW) & (|EX_DA) & ~(MB) & (EX_DA == ID_BA);
    WHA= (WB_RW) & (|WB_DA) & ~(MA) & (WB_DA == ID_AA);
    WHB= (WB_RW) & (|WB_DA) & ~(MB) & (WB_DA == ID_BA);
  end

  // MUX D' (fwd unit)
  always @(*) begin
    FWD = 0;
    case(EX_MD)
      2'b00 : FWD = F;
      2'b01 : FWD = D_IN;
      2'b10 : FWD = {31'b0, N ^ Z};
    endcase
  end
 

  always @(*) begin
    BrA = PC_2 + EX_BUSB;
    RAA = EX_BUSA;
  end

/* stage : WB */

  // MUX D
  always @(*) begin
    case(WB_MD)
      2'b00 : BUS_D = WB_F;
      2'b01 : BUS_D = WB_DIN;
      2'b10 : BUS_D = WB_SLT;
      default:BUS_D = 0;
    endcase
  end

  always @(*) begin
      PC_NEXT = PC + 1;
    case(C_SELECT)
      2'b01 : PC_NEXT = BrA;
      2'b10 : PC_NEXT = RAA;
      2'b11 : PC_NEXT = BrA;
    endcase
  end

  always @(*) begin
    // avoid contiguous branch 
    if(!flush_ID)
      C_SELECT = {EX_BS[1], (((EX_PS ^ Z) | EX_BS[1]) & EX_BS[0])};
    else
      C_SELECT = 0;
  end

endmodule
