module func_unit(
  input [3:0]  FS,
  input [4:0]  SH,
  input [31:0] A,
  input [31:0] B,
  output reg V,
  output reg C,
  output reg N,
  output reg Z,
  output reg [31:0] F
);

  parameter T_A    = 4'b0000,
            A_A1   = 4'b0001,
            A_AB   = 4'b0010,
            A_AB1  = 4'b0011,
            A_ANB  = 4'b0100,
            A_ANB1 = 4'b0101,
            S_A1   = 4'b0110,
            T_A2   = 4'b0111,
            LAND   = 4'b1000,
            LOR    = 4'b1001,
            LXOR   = 4'b1010,
            T_NA   = 4'b1011,
            T_B    = 4'b1100,
            LSR    = 4'b1101,
            LSL    = 4'b1110,
            ONE    = 32'h0000_0001,
            NONE   = 32'hFFFF_FFFF;

  reg [31:0] NA;
  reg [31:0] NB;

  function overflow;
    input M_A, M_B, M_F;
    begin
      // if M_A != M_B, it won't overflow.
      overflow = (M_A != M_B) | (M_A == M_F) ? 1'b0 : 1'b1; 
    end
  endfunction


  always @(*) begin
    V = 0;
    C = 0;
    F = 0;
    
    NA = ~A; // pre-calculate. or it will has addition 1 bts.
    NB = ~B;

    case(FS)
      T_A    : begin
                 F = A;
               end
      A_A1   : begin
                 {C, F} = A + ONE; 
                 V = overflow(A[31], 1'b0, F[31]);
               end
      A_AB   : begin 
                 {C, F} = A + B;
                 V = overflow(A[31], B[31], F[31]);
               end
      A_AB1  : begin
                 {C, F} = A + B + ONE;
                 V = overflow(A[31], (B + ONE) >> 31, F[31]);
               end
      A_ANB  : begin
                 {C, F} = A + NB;
                 V = overflow(A[31], NB[31], F[31]);
               end
      A_ANB1 : begin
                 {C, F} = A + NB + 1;
                 V = overflow(A[31], (NB + ONE) >> 31, F[31]);
               end
      S_A1   : begin
                 {C, F} = A + NONE;
                 V = overflow(A[31], 1'b1, F[31]);
               end
      T_A2   : begin 
                 F = A;
               end
      LAND   : begin
                 F = A & B;
               end
      LOR    : begin
                 F = A | B;
               end
      LXOR   : begin
                 F = A ^ B;
               end
      T_NA   : begin
                 F = NA;
               end
      T_B    : begin
                 F = B;
               end
      LSR    : begin
                 F = B >> SH;
               end
      LSL    : begin
                 F = B << SH;
               end
    endcase
    Z = F ? 0 : 1;
    N = F[31];
  end

endmodule
