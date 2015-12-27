module pipeline(
  input clk, rst_n
);


wire [31:0] BrA, RAA;
reg  [31:0] MUX_C, PC_NEXT;
reg  [31:0] PC, PC_1, PC_2;      // Per stage PC, maintain the PC of the stage.
wire [1:0]  C_SELECT;

wire [31:0] IR;                  // for IF, Came out from ins memory. 



wire [4:0] ID_DA, ID_AA, ID_BA;  // for ID, Came out from ins decoder.
wire [31:0] CONST_B;             // for ID, Came out from ins decoder.
wire MA, MB;                     // for ID, Came out from ins decoder.
wire HA, HB;                     // for ID, Came out from fwd unit.
wire [31:0] RA, RB;              // for ID, Came out from reg file.
reg  [31:0] BUS_A, BUS_B;        // for ID, Came out from reg A/B.
reg  [31:0] FWD;                 // for ID, Came out from fwd unit


wire V, C, N, Z;                 // for EX, Came out from func unit.
wire [31:0]   F;                 // for EX, Came out from func unit.




/* Stage manager */
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









/* stage : IF */

// step 1. retreive IR from instruction memory.
// step 2. if branch happen, make it become nop.



/* stage : ID */
register_file REGF(.clk(clk), .rst_n(rst_n), 
                    .DA(ID_DA), .AA(ID_AA), .BA(ID_BA), .BUS_D(BUS_D),
                     .REG_A(RA), .REG_B(RB));


  // mux A
  always @(*) begin
    case({HA, MB})
      2'b00 : BUS_A = RA;
      2'b01 : BUS_A = PC_1; // for JML
      3'b10 : BUS_A = FWD;
    endcase
  end

  // mux B
  always @(*) begin
    case({HA, MB})
      2'b00 : BUS_B = RA;
      2'b01 : BUS_B = CONST_B; // for constant.
      3'b10 : BUS_B = FWD;
    endcase
  end


/* stage : EX */
func_unit FUNCUNIT(.FS(FS), .SH(EX_SH), .A(BUS_A), .B(BUS_B), 
                    .V(V), .C(C), .N(N), .Z(Z), .F(F));


/* stage : ME */

/* stage : WB */



endmodule
