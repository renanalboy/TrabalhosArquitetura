//--------------------------------------------------------------
// mips.sv
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Single-cycle MIPS processor
//--------------------------------------------------------------

// files needed for simulation:
//  mipsttest.v
//  mipstop.v
//  mipsmem.v
//  mips.v
//  mipsparts.v

// single-cycle MIPS processor
module mips(input  logic        clk, reset,
            output logic [31:0] pc,
            input  logic [31:0] instr,
            output logic        memwrite,
            output logic [31:0] aluout, writedata,
            input  logic [31:0] readdata);

  logic        memtoreg, branch, bne, jal,
               pcsrc, zero,
               alusrc, regdst, regwrite, jump, jr;
  logic [2:0]  alucontrol;
  
  controller c(instr[31:26], instr[5:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump,
               alucontrol,jal,jr);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump, jr, jal,
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);
endmodule

module controller(input  logic [5:0] op, funct,
                  input  logic       zero,
                  output logic       memtoreg, memwrite,
                  output logic       pcsrc, alusrc,
                  output logic       regdst, regwrite,
                  output logic       jump,
                  output logic [2:0] alucontrol,
                  output logic       jal,
                  output logic       jr);
                  
  logic [1:0] aluop;
  logic       branch, bne;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump,
             aluop, bne, jal);
  aludec  ad(funct, aluop, alucontrol, jr);

  assign pcsrc = branch & (zero ^ bne);
endmodule

module maindec(input  logic [5:0] op,
               output logic       memtoreg, memwrite,
               output logic       branch, alusrc,
               output logic       regdst, regwrite,
               output logic       jump,
               output logic [1:0] aluop, 
               output logic       bne,
               output logic       jal);

  logic [10:0] controls;

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop, bne, jal} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 11'b11000001000  ; //Rtype
      6'b100011: controls <= 11'b10100100000; //LW
      6'b101011: controls <= 11'b00101000000; //SW
      6'b000100: controls <= 11'b00010000100; //BEQ
      6'b000101: controls <= 11'b00010000110; //BNE
      6'b001000: controls <= 11'b10100000000; //ADDI
      6'b001101: controls <= 11'b10100001100; //ORI
      6'b000010: controls <= 11'b00000010000; //J
      6'b000011: controls <= 11'b10100010001; //JAL  
      default:   controls <= 11'bxxxxxxxxxxx; //???
    endcase
endmodule

module aludec(input  logic [5:0] funct,
              input  logic [1:0] aluop,
              output logic [2:0] alucontrol,
              output logic       jr);
  
  always_comb
  begin assign jr  = 0;          
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add
      2'b00: alucontrol <= 3'b010;  // add
      2'b11: alucontrol <= 3'b001;  // ori
      default: case(funct)          // RTYPE
          6'b100000: alucontrol <= 3'b010; // ADD
          6'b100010: alucontrol <= 3'b110; // SUB
          6'b100100: alucontrol <= 3'b000; // AND
          6'b100101: alucontrol <= 3'b001; // OR
          6'b101010: alucontrol <= 3'b111; // SLT
          6'b001000:  assign jr = 1;       // JR - 03e00008
          default:   begin alucontrol <= 3'bxxx; //? 
        end
                      
        endcase
    endcase
    end
endmodule

module datapath(input  logic        clk, reset,
                input  logic        memtoreg, pcsrc,
                input  logic        alusrc, regdst,
                input  logic        regwrite, jump, jr, jal,
                input  logic [2:0]  alucontrol,
                output logic        zero,
                output logic [31:0] pc,
                input  logic [31:0] instr,
                output logic [31:0] aluout, writedata,
                input  logic [31:0] readdata);

  logic [4:0]  writereg;
  logic [4:0]  writeregjal;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch, pcnextjr;
  logic [31:0] signimm, signimmsh;
  logic [31:0] srca, srcb;
  logic [31:0] result;
  logic [31:0] resultjal;

  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnextjr, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, 
                    jump, pcnext);
                    
  mux2 #(32)  pcmuxjr(pcnext, result, jr, pcnextjr);
  
  // register file logic
  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writeregjal,
                 resultjal, srca, writedata);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);
  
  mux2 #(5)   regmuxjal(writereg, 5'b11111, jal, writeregjal);
                                     
  mux2 #(32)  resmux(aluout, readdata,
                     memtoreg, result);
  mux2 #(32)  resmuxjal(result, pcplus4,
                     jal, resultjal);                            
  signext     se(instr[15:0], signimm);

  // ALU logic
  mux2 #(32)  srcbmux(writedata, signimm, alusrc,
                      srcb);
  alu         alu(.a(srca), .b(srcb), .f(alucontrol),
                  .y(aluout), .zero(zero));
endmodule

