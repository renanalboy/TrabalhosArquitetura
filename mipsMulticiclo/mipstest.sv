//------------------------------------------------
// mipstest.sv
// David_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Testbench for MIPS processor
//------------------------------------------------

module testbench01();

  logic        clk;
  logic        reset;

  logic [31:0] writedata, dataadr;
  logic        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

 always@(negedge clk) begin
//sw $t3, 200 #Grava no endereço 200 o valor de t3 (0x00000001 ; 1) ORI positivo
//sw $t4, 204 #Grava no endereço 204 o valor de t4 (0xffffffff ; -1) ORI negativo
//sw  $t5, 208  #Grava no endereço 208 o valor de t5 (0x00000064 ; 100) BNE sem salto
//sw  $t6, 212  #Grava no endereço 212 o valor de t6 (0x000000C8 ; 200) BNE com salto
  if(memwrite) begin
   //Testa ORI positivo
   if(dataadr === 200) begin
    if(writedata === 32'h00000001) begin
     $display("OK - ORI valor positivo");
    end
    else begin
     $display("ERROR - ORI valor positivo");
     $stop;
    end
   end
   //Testa ORI negativo
   if(dataadr === 204) begin
    if(writedata === 32'hffffffff) begin
     $display("OK - ORI valor negativo");
    end
    else begin
     $display("ERROR - ORI valor negativo");
     $stop;
    end
   end
   //Testa BNE sem salto
   if(dataadr === 208) begin
    if(writedata === 32'h00000064) begin
     $display("OK - BNE sem salto");
    end
    else begin
     $display("ERROR - BNE sem salto");
     $stop;
    end
   end
   //Testa BNE com salto
   if(dataadr === 212) begin
    if(writedata === 32'h000000C8) begin
     $display("OK - BNE com salto");
     $stop;
    end
    else begin
     $display("ERROR - BNE com salto");
     $stop;
    end
   end
  end
    end
endmodule