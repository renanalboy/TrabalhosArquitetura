module shiftr (Resetn, w, Clock, S); 
  parameter m = 2;
  input Resetn, w, Clock;
  output [1:m] S;
  reg [1:m] S; 
  integer k;

  always @(negedge Resetn or posedge Clock) 
    if (!Resetn)
      S <= 0; 
    else
    begin
      /*for (k=m; k>1; k=k-1)*/
       S[1] <= S[2];
       S[2] <= w;
    end  
endmodule