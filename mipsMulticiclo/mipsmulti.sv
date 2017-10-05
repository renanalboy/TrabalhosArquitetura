//-------------------------------------------------------
// mipsmulti.v
// David_Harris@hmc.edu 8 November 2005
// Update to SystemVerilog 17 Nov 2010 DMH
// Multicycle MIPS processor
//------------------------------------------------

module mips(input  logic        clk, reset,
            output logic [31:0] adr, writedata,
            output logic        memwrite,
            input  logic [31:0] readdata);

  logic        zero, pcen, irwrite, regwrite,
               alusrca, iord, memtoreg;
  logic [1:0]  regdst;
  logic [2:0]  alusrcb;
  logic [2:0]  pcsrc;
  logic [2:0]  alucontrol;
  logic [5:0]  op, funct;

  controller c(clk, reset, op, funct, zero,
               pcen, memwrite, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst, 
               alusrcb, pcsrc, alucontrol);
  datapath dp(clk, reset, 
              pcen, irwrite, regwrite,
              alusrca, iord, memtoreg, regdst,
              alusrcb, pcsrc, alucontrol,
              op, funct, zero,
              adr, writedata, readdata);
endmodule

module controller(input  logic       clk, reset,
                  input  logic [5:0] op, funct,
                  input  logic       zero,
                  output logic       pcen, memwrite, irwrite, regwrite,
                  output logic       alusrca, iord, memtoreg, 
				  output logic [1:0] regdst,
                  output logic [2:0] alusrcb,
				  output logic [2:0] pcsrc,
                  output logic [2:0] alucontrol);

  logic [1:0] aluop;
  logic       branch, bne, pcwrite;

  // Main Decoder and ALU Decoder subunits.
  maindec md(clk, reset, op, funct,
             pcwrite, memwrite, irwrite, regwrite,
             alusrca, branch, bne, iord, memtoreg, regdst, 
             alusrcb, pcsrc, aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcen = pcwrite | branch & (bne ^ zero);
 
endmodule

module maindec(input  logic       clk, reset, 
               input  logic [5:0] op, funct,
               output logic       pcwrite, memwrite, irwrite, regwrite,
               output logic       alusrca, branch, bne, iord, memtoreg, 
			   output logic [1:0] regdst,
               output logic [2:0] alusrcb,
			   output logic [2:0] pcsrc,
               output logic [1:0] aluop);

  parameter   FETCH   = 5'b00000; 	// State 0
  parameter   DECODE  = 5'b00001; 	// State 1
  parameter   MEMADR  = 5'b00010;	// State 2
  parameter   MEMRD   = 5'b00011;	// State 3
  parameter   MEMWB   = 5'b00100;	// State 4
  parameter   MEMWR   = 5'b00101;	// State 5
  parameter   RTYPEEX = 5'b00110;	// State 6
  parameter   RTYPEWB = 5'b00111;	// State 7
  parameter   BEQEX   = 5'b01000;	// State 8
  parameter   ADDIEX  = 5'b01001;	// State 9
  parameter   ADDIWB  = 5'b01010;	// state 10
  parameter   JEX     = 5'b01011;	// State 11
  parameter   ORIEX   = 5'b01100;	// State 12
  parameter   ORIWB   = 5'b01101;	// state 13
  parameter   BNEEX   = 5'b01110;	// State 14
  parameter   JALEX   = 5'b01111;	// State 15
  parameter   JREX    = 5'b10000; // State 16
  

  parameter   LW      = 6'b00011;	// Opcode for lw
  parameter   SW      = 6'b01011;	// Opcode for sw
  parameter   RTYPE   = 6'b00000;	// Opcode for R-type
  parameter   BEQ     = 6'b00100;	// Opcode for beq
  parameter   ADDI    = 6'b01000;	// Opcode for addi
  parameter   J       = 6'b00010;	// Opcode for j
  parameter   ORI     = 6'b01101;	// Opcode for ori
  parameter   BNE     = 6'b00101;	// Opcode for bne
  parameter   JAL     = 6'b00011;	// Opcode for jal

  parameter   FUNCTJR      = 6'b01000; 

  logic [4:0]  state, nextstate;
  logic [19:0] controls;

  // state register
  always_ff @(posedge clk or posedge reset)			
    if(reset) state <= FETCH;
    else state <= nextstate;

  // next state logic
  always_comb
    case(state)
      FETCH:   nextstate <= DECODE;
      DECODE:  case(op)
                 LW:      nextstate <= MEMADR;
                 SW:      nextstate <= MEMADR;
                 RTYPE:   nextstate <= RTYPEEX;
                 BEQ:     nextstate <= BEQEX;
                 ADDI:    nextstate <= ADDIEX;
                 J:       nextstate <= JEX;
				 ORI:	  nextstate <= ORIEX;
				 BNE:     nextstate <= BNEEX;
				 JAL:     nextstate <= JALEX;
                 default: nextstate <= 5'bx; // should never happen
               endcase
      MEMADR: case(op)
                 LW:      nextstate <= MEMRD;
                 SW:      nextstate <= MEMWR;
                 RTYPE:
                      case(funct)
                        FUNCTJR:   nextstate <= JREX;
                        default:  nextstate <= RTYPEEX;
                      endcase
                 default: nextstate <= 5'bx;
               endcase
      MEMRD:   nextstate <= MEMWB;
      MEMWB:   nextstate <= FETCH;
      MEMWR:   nextstate <= FETCH;
      RTYPEEX: nextstate <= RTYPEWB;
      RTYPEWB: nextstate <= FETCH;
      BEQEX:   nextstate <= FETCH;
      ADDIEX:  nextstate <= ADDIWB;
      ADDIWB:  nextstate <= FETCH;
      JEX:     nextstate <= FETCH;
	  ORIEX:   nextstate <= ORIWB;
	  ORIWB:   nextstate <= FETCH;
	  BNEEX:   nextstate <= FETCH;
	  JALEX:   nextstate <= FETCH;
    JREX:    nextstate  <= FETCH;
      default: nextstate <= 5'bx; // should never happen
    endcase

  // output logic
  assign {pcwrite, memwrite, irwrite, regwrite, 
          alusrca, branch, bne, iord, memtoreg, 
		  regdst,
          alusrcb, pcsrc, aluop} = controls;

  /*
  module maindec(input  logic       clk, reset, 
	   input  logic [5:0] op, 
	   output logic       pcwrite, memwrite, irwrite, regwrite,
	   output logic       alusrca, branch, iord, memtoreg, regdst,
	   output logic [1:0] alusrcb, pcsrc,
	   output logic [1:0] aluop);
  */
  always_comb
    case(state)						 // 0000 00000 00_00_00
      FETCH:   controls <= 19'b1010_00000_00_001_000_00; //h5010;
      DECODE:  controls <= 19'b0000_00000_00_011_000_00; //h0030;
      MEMADR:  controls <= 19'b0000_10000_00_010_000_00; //h0420; b0000_10000_10_00_00
      MEMRD:   controls <= 19'b0000_00010_00_000_000_00; //h0100; b0000_00100_00_00_00
      MEMWB:   controls <= 19'b0001_00001_00_000_000_00; //h0880; b0001_00010_00_00_00
      MEMWR:   controls <= 19'b0100_00010_00_000_000_00; //h2100; b0100_00100_00_00_00
      RTYPEEX: controls <= 19'b0000_10000_00_000_000_10; //h0402;
      RTYPEWB: controls <= 19'b0001_00000_01_000_000_00; //h0840;
	    BEQEX:   controls <= 19'b0000_11000_00_000_011_01; //h0605;
      ADDIEX:  controls <= 19'b0000_10000_00_010_000_00; //h0420;
      ADDIWB:  controls <= 19'b0001_00000_00_000_000_00; //h0800;
      JEX:     controls <= 19'b1000_00000_00_000_010_00; //h4008;
	    ORIEX:   controls <= 19'b0000_10000_00_100_000_11; //h0423;
	    ORIWB:   controls <= 19'b0001_10000_00_100_000_11; //h0803;
	    BNEEX:   controls <= 19'b0000_11100_00_000_011_01; //h0605;
	    JALEX:   controls <= 19'b1001_00001_10_000_010_00; //h4008;
      JREX:    controls <= 19'b1000_00000_00_000_101_00; //h4008;
      default: controls <= 19'bxxxx_xxxxx_0x_xxx_xx_xx; // should never happen
    endcase
endmodule

module aludec(input  logic [5:0] funct,
              input  logic [1:0] aluop,
              output logic [2:0] alucontrol);

  always @(*)
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add
      2'b01: alucontrol <= 3'b110;  // sub
	  2'b11: alucontrol <= 3'b001;  // ori
      default: case(funct)          // RTYPE aluop b10
          6'b100000: alucontrol <= 3'b010; // ADD
          6'b100010: alucontrol <= 3'b110; // SUB
          6'b100100: alucontrol <= 3'b000; // AND
          6'b100101: alucontrol <= 3'b001; // OR
          6'b101010: alucontrol <= 3'b111; // SLT
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase

endmodule

module datapath(input  logic        clk, reset,
                input  logic        pcen, irwrite, regwrite,
                input  logic        alusrca, iord, memtoreg, 
				input  logic [1:0]  regdst,
                input  logic [2:0]  alusrcb, 
				input  logic [2:0]  pcsrc,
                input  logic [2:0]  alucontrol,
                output logic [5:0]  op, funct,
                output logic        zero,
                output logic [31:0] adr, writedata, 
                input  logic [31:0] readdata);

  // Below are the internal signals of the datapath module.

  logic [4:0]  writereg;
  logic [31:0] pcnext, pc;
  logic [31:0] instr, data, srca, srcb;
  logic [31:0] a;
  logic [31:0] aluresult, aluout;
  logic [31:0] signimm;   // the sign-extended immediate
  logic [31:0] signimmsh;	// the sign-extended immediate shifted left by 2
  logic [31:0] orihizerosig;
  logic [31:0] wd3, rd1, rd2;
  logic [31:0] pcbranch;

  // op and funct fields to controller
  assign op = instr[31:26];
  assign funct = instr[5:0];

  flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);
  mux2    #(32) adrmux(pc, aluout, iord, adr);
  flopenr #(32) instrreg(clk, reset, irwrite, readdata, instr);
  flopr   #(32) datareg(clk, reset, readdata, data);
  mux3    #(5)  regdstmux(instr[20:16], instr[15:11], 5'b11111, regdst, writereg);
  mux2    #(32) wdmux(aluout, data, memtoreg, wd3);
  regfile       rf(clk, regwrite, instr[25:21], instr[20:16], writereg, wd3, rd1, rd2);
  signext       se(instr[15:0], signimm);
  hizero		orihizero(instr[15:0], orihizerosig); // coloca a parte alta do imediate do ori como zero.
  sl2           immsh(signimm, signimmsh); 
  flopr   #(32) areg(clk, reset, rd1, a);
  flopr   #(32) breg(clk, reset, rd2, writedata);
  mux2    #(32) srcamux(pc, a, alusrca, srca);
  mux5    #(32) srcbmux(writedata, 32'b100, signimm, signimmsh, orihizerosig, alusrcb, srcb);
  alu           alu(srca, srcb, alucontrol, aluresult, zero);
  flopr   #(32) alureg(clk, reset, aluresult, aluout);
  mux5    #(32) pcmux(aluresult, aluout, {pc[31:28], instr[25:0], 2'b00}, pcbranch, a, pcsrc, pcnext);
  bdm			bdm_bb(pc, signimmsh, pcbranch);
endmodule

//Branch do mal - bdm
module bdm(input  logic [31:0] npc,	//pc ja incrementado de 4
		   input  logic [31:0] imedd, //Incremento de endereço em bytes
           output logic [31:0] dest); //endereço de destino do salto

  assign dest =  npc + imedd;
endmodule

module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

   always_comb
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
endmodule

module mux5 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3, d4,
              input  logic [2:0]       s, 
              output logic [WIDTH-1:0] y);

   always_comb
      case(s)
         3'b000: y <= d0;
         3'b001: y <= d1;
         3'b010: y <= d2;
         3'b011: y <= d3;
		 3'b100: y <= d4;
		 default: y <= d4;
      endcase
endmodule

