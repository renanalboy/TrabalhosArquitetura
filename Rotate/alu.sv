module alu(input  logic [31:0] a, b,
           input  logic [3:0]  f,
           output logic [31:0] y,
           output logic        zero);
           
  logic [31:0] bb, b2, add_res, and_res, or_res, slt_res;
   logic [31:0] ror_res, ror_tmp, t1, t2;
  //b deslocado de a
  assign t1 = b >> a;
  assign t2 = b << (32 - a);
  assign ror_res = t1 | t2;
  
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
      3'b100: y = ror_res;
      default: y = 'x;
    endcase
    
  assign zero = (y == 32'b0);
endmodule