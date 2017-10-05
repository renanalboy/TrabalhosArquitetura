module swap (Data, Resetn, w, Clock, Extern, RinExt); 
  input [7:0] Data;
  input Resetn, w, Clock, Extern;
  wire [7:0] R1, R2, R3, R4;//Saídas registradores e entrada mux
  input [1:4] RinExt;
  wire [1:4] Rin;
  wire [1:2] S;
  wire [7:0] Y1, Y2, Y3, Y4;//Saídas mux e entrada registradores
  
  shiftr control (Resetn, w, Clock, S); 
    defparam control.m = 2;

  assign Rin[1] = RinExt[1] | (S[1]|S[2]); 
  assign Rin[2] = RinExt[2] | (S[1]|S[2]);  
  assign Rin[3] = RinExt[3] | (S[1]|S[2]); 
  assign Rin[4] = RinExt[4] | (S[1]|S[2]);  
 
  regn reg_1 (Y1, Rin[1], Clock, R1); 
  regn reg_2 (Y2, Rin[2], Clock, R2); 
  regn reg_3 (Y3, Rin[3], Clock, R3);
  regn reg_4 (Y4, Rin[4], Clock, R4);
  
  mux mux_1(Data,R2,R3,R4,S,Y1);
  mux mux_2(Data,R1,R4,R3,S,Y2);
  mux mux_3(Data,R4,R1,R2,S,Y3);
  mux mux_4(Data,R3,R2,R1,S,Y4);  
endmodule