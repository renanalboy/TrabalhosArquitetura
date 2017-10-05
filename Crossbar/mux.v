module mux (w0, w1, w2, w3, S, f);
input [7:0] w0, w1, w2, w3;
input [1:2] S;
output [7:0] f;
reg [7:0] f;

always @(w0 or w1 or w2 or w3 or S)    
    case (S)
    2'b00: begin
        f = w0;
      end
    2'b01:begin
        f = w1;
      end 
    2'b10:begin
        f = w3;
      end
    2'b11:begin
        f = w2;
      end
  endcase
endmodule

