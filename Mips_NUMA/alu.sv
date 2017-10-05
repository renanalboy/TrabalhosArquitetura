module alu(input  logic [31:0] a, b,
           input  logic [3:0]  f,
           output logic [31:0] y,
           output logic        zero);
           
  logic [31:0] bb, b2, add_res, and_res, or_res, slt_res;
  logic [31:0] ror_res, tr_1, tr_2;
  logic [31:0] rol_res, tl_1, tl_2;
  logic [31:0] nor_res;
  logic [31:0] mul_res;
  
  //b deslocado de a

  //Implementação instrução ROR
  assign tr_1 = b >> a;
  assign tr_2 = b << (32 - a);
  assign ror_res = tr_1 | tr_2;

  //Implementação instrução ROL
  //b deslocado de a 
  assign tl_1 = b << a;
  assign tl_2 = b >> (32 - a);
  assign rol_res = tl_1 | tl_2;

  //Implementação instrução NOR
  assign nor_res  = ~(a | b);

  //Implementação instrução MUL
  assign mul_res  = a * b;
  
  assign bb = ~b;
  assign b2 = f[3] ? bb : b;
  assign add_res = a + b2 + f[3]; // handle 2's complement
  assign and_res = a & b2;
  assign or_res  = a | b2;
  assign slt_res = add_res[31] ? 32'b1 : 32'b0;
  
  always_comb
    case (f[2:0])
      3'b000: y = and_res;
      3'b001: y = or_res;
      3'b010: y = add_res;
      3'b011: y = slt_res;
      3'b100: y = ror_res;//Ocupa o op da instrução SLLV (func 0x04)
		3'b101: y = rol_res;//Ocupa o op da instruçãoSRLV -> ROL func 0x06
		3'b110: y = nor_res;//NOR 
		3'b111: y = mul_res;//Ocupa o op da instrução XOR (func 0x26)
    endcase
/*
          6'b100100: alucontrol <= 3'b0000; // AND
          6'b100101: alucontrol <= 3'b0001; // OR
			 6'b100000: alucontrol <= 4'b0010; // ADD
			 6'b100010: alucontrol <= 4'b1010; // SUB
          6'b101010: alucontrol <= 4'b1011; // SLT
          6'b000100: alucontrol <= 4'b0100; // ROR		
			 6'b000110: alucontrol <= 4'b0101; // ROL
          6'b100111: alucontrol <= 4'b0110; // NOR 
          6'b100110: alucontrol <= 4'b0111; // MUL
          default:   alucontrol <= 4'bxxxx; // ???
*/    
  assign zero = (y == 32'b0);

endmodule
