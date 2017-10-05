`timescale 1ns / 1ps
//------------------------------------------------
// topmulti.sv
// David_Harris@hmc.edu 9 November 2005
// Update to SystemVerilog 17 Nov 2010 DMH
// Top level system including multicycle MIPS 
// and unified memory
//------------------------------------------------

module topmulti (
  input wire reset, 
	input wire CLOCK_50,	//board clock: 50MHz
	output wire VGA_HS,		//horizontal sync out
	output wire VGA_VS,		//vertical sync out
	output reg [3:0] VGA_R,	//red vga output
	output reg [3:0] VGA_G, //green vga output
	output reg [3:0] VGA_B	//blue vga output
	);

	logic CLOCK_25;
  
  //Para Mips1
  logic         memwrite;
  logic [31:0]  adr;
  logic [31:0]  writedata;
  logic [31:0]  readdata;
  
  //Para Mips2
  logic        memwrite2;
  logic [31:0] adr2;
  logic [31:0] writedata2;
  logic [31:0] readdata2;
  
  //Para video
  logic [31:0] vdatar;
  logic [31:0] vdatag;
  logic [31:0] vdatab;
  logic [31:0] vadr;

  //Declaracoes para fios dos mux mxm1, mxm2, mxm3
  
  //Declaracoes mxm1
  logic     	  out_we1;
  logic [31:0]    out_a1;
  logic [31:0]    out_wd1;

  //Declaracoes mxm2
  logic           out_we2;
  logic [31:0]    out_a2;
  logic [31:0]    out_wd2;

  //Declaracoes mxm3
  logic           out_we3;
  logic [31:0]    out_a3;
  logic [31:0]    out_wd3;

  
  //Declaracoes muxin1
  logic [31:0]   out_rd1;
  logic [31:0]   readdatav;

  //Declaracoes muxin2
  logic [31:0]   out_rd2;
  

  //Declaracoes para juiz
  logic           clk_out1;
  logic           clk_out2;
  logic           trg1;
  logic           trg2;

  
	clockdiv cd(
	.clr(reset),
	.clk(CLOCK_50),
	.dclk(CLOCK_25)
	);
	
	vga640x480 vd(
	.clr(reset),
	.dclk(CLOCK_25),
	.vdatar(vdatar),
	.vdatag(vdatag),
	.vdatab(vdatab),
	.vadr(vadr),
	.hsync(VGA_HS),
	.vsync(VGA_VS),
	.red(VGA_R),
	.green(VGA_G),
	.blue(VGA_B)
	); 

  
  /*
  module mips(input  logic        clk, reset,
            output logic [31:0] adr, writedata,
            output logic        memwrite,
            input  logic [31:0] readdata);
  */
  
  //Microprocessor (control & datapath) - para mips1
  mips mips1(
			 CLOCK_25, 
			 reset, 
			 adr, 
			 writedata, 
			 memwrite, 
			 out_rd1,
			 mips1out
			 );
			 
  /*
  module memMips1( input  logic        clk, we,
      input  logic [31:0] a,
      input  logic [31:0] wd, 
      output logic [31:0] rd);
  */
  
  //Memoria para mips1 
  memMips1 mem1(CLOCK_25,   
                out_we1,  
                out_a1,   
                out_wd1,   
                readdata
				);

  // microprocessor (control & datapath) - para mips2
  mips mips2(CLOCK_25,   
             reset,       
             adr2,        
             writedata2,   
             memwrite2,     
             out_rd2,
			 mips2out
			 );
    
  /*module memMips2( input  logic        clk, we,
      input  logic [31:0] a,
      input  logic [31:0] wd, 
      output logic [31:0] rd);
  */
  //Memoria para mips2
  memMips2 mem2(CLOCK_25,     
                out_we2,     
                out_a2,     
                out_wd2,    
                readdata2);

  /*
  module memVideo(	input  logic        clk, we,
			input  logic [31:0] a,
			input  logic [31:0] wd,
			output logic [31:0] rd,
			input  logic [31:0] va,
			output logic [31:0] vdr,
			output logic [31:0] vdg,
			output logic [31:0] vdb);
  */
  
  //Memoria de video
  memVideo mem(CLOCK_25, 
              out_we3, 
              out_a3, 
              out_wd3, 
              readdatav, 
              vadr, 
              vdatar, 
              vdatag, 
              vdatab);

  /*
  module muxmemoria(  input  logic          s,
                    //Sinais vindo do mips1
                    input  logic          we1,
                    input  logic [31:0]   a1,
                    input  logic [31:0]   wd1,
                    //sinais vindo do mips 2
                    input  logic          we2,
                    input  logic [31:0]   a2,
                    input  logic [31:0]   wd2,
                    //saidas 
                    output  logic         out_we,
                    output  logic [31:0]  out_a,
                    output  logic [31:0]  out_wd);
  */

  //Mux seletor que recebe como prioridade o mips1
  muxmemoria mxm1({adr[6], adr2[6]}, 
				   //
                   memwrite, 
                   adr, 
                   writedata, 
                   //
                   memwrite2, 
                   adr2, 
                   writedata2, 
                   //
                   out_we1, 
                   out_a1, 
                   out_wd1);

  /*
  
  module muxmemoria(  input  logic [1:0]          s,
                    //Sinais vindo do mips1
                    input  logic          we1,
                    input  logic [31:0]   a1,
                    input  logic [31:0]   wd1,
                    //sinais vindo do mips 2
                    input  logic          we2,
                    input  logic [31:0]   a2,
                    input  logic [31:0]   wd2,
                    //saidas 
                    output  logic         out_we,
                    output  logic [31:0]  out_a,
                    output  logic [31:0]  out_wd);
  
  */
  //Mux seletor que recebe como prioridade o mips2
  muxmemoria mxm2({adr2[6], adr[6]},
                  // 
                  memwrite2, 
                  adr2, 
                  writdata2,
                  // 
                  memwrite, 
                  adr, 
                  writedata, 
                  //
                  out_we2, 
                  out_a2, 
                  out_wd2);

  //Mux para video, adotado como prioridade a execucao do mips1
  muxmemoria mxm3({adr[6], adr2[7]}, 
                   //
                   memwrite, 
                   adr, 
                   writedata,
                   // 
                   memwrite2, 
                   adr2, 
                   writedata2, 
                   //
                   out_we3, 
                   out_a3, 
                   out_wd3);

  /*
module muxmemin( input  logic [1:0]       s,
                //entrada vinda do mips1
                input  logic  [31:0]      rd1,
                //entrada vinda do mips2
                input  logic  [31:0]      rd2,
				//entrada do video
				input logic	  [31:0]      rdv,
                //saida 
                output  logic  [31:0]     out_rd);   

  */

  //Mux para o sinal readdata que retorna ao mips1
  muxmemin muxin1({adr[6], adr[7]}, 
                  readdata, 
                  readdata2,
				  readdatav,
                  out_rd1);

  //Mux para o sinal readdata que retorna ao mips2
  muxmemin muxin2({adr2[6], adr2[7]},    
                   readdata2, 
                   readdata, 
                   out_rd2);

  /*
module juiz( input  logic     s,
             output logic     mips1out,
             output logic     mips2out);
  */

  //Juiz para decidir qual pode executar
  juiz julga({adr[6], adr2[6]}, 
              trg1, 
              trg2);

  /*
module permite( 
                input  logic  clk_in,
                input  logic     trigger,
                output logic     clk_out
              );
  */

  //Interrupcao ou execucao do clock no mips1
  /*permite p1(CLOCK_25, 
             trg1, 
             clk_out1);

  //Interrupcao ou execucao do clock no mips2
  permite p2(CLOCK_25, 
             trg2, 
             clk_out2);*/

endmodule

module muxmemoria(  input  logic [1:0]          s,
                    //Sinais vindo do mips1
                    input  logic          we1,
                    input  logic [31:0]   a1,
                    input  logic [31:0]   wd1,
                    //sinais vindo do mips 2
                    input  logic          we2,
                    input  logic [31:0]   a2,
                    input  logic [31:0]   wd2,
                    //saidas 
                    output  logic         out_we,
                    output  logic [31:0]  out_a,
                    output  logic [31:0]  out_wd);

          
              always_comb
              case(s)
                2'b00:
                  begin
                    out_we <= 0;
                    out_a  <= 0;
                    out_wd <= 0;
                  end
                2'b01:
                  begin
                    out_we <= we2;
                    out_a  <= a2;
                    out_wd <= wd2;
                  end
                2'b10:
                  begin
                    out_we <= we1;
                    out_a  <= a1;
                    out_wd <= wd1;
                  end
						2'b11:
                  begin
                    out_we <= we1;
                    out_a  <= a1;
                    out_wd <= wd1;
                  end
              endcase
        endmodule

module muxmemin( input  logic [1:0]       s,
                //entrada vinda do mips1
                input  logic  [31:0]      rd1,
                //entrada vinda do mips2
                input  logic  [31:0]      rd2,
				//entrada do video
				input logic	  [31:0]      rdv,
                //saida 
                output  logic  [31:0]     out_rd);   
          
        always_comb
          case(s)
          2'b00:
            begin
              out_rd <= 0;
            end
          2'b01:
           begin
              out_rd <= rd2;
           end
          2'b10:
            begin
              out_rd <= rd1;
          end
		  2'b11:
            begin
              out_rd <= rd1;
          end
        endcase
endmodule



module juiz( 	 input  logic [1:0]     s,
				 output logic     mips1out,
				 output logic     mips2out); 
				 

              always_comb
                case(s)
                2'b11:
                  begin
                    mips1out <= 1;
                    mips2out <= 0;
                  end
				    2'b10:
                  begin
                    mips1out <= 1;
                    mips2out <= 0;
                  end
                2'b01:
                  begin
                    mips1out <= 0;
                    mips2out <= 1;
                  end
                2'b00:
                  begin
                    mips1out <= 0;
                    mips2out <= 0;
                  end
                
                endcase
endmodule



module permite( 
                input  logic  	 clk_in,
                input  logic     trigger,
                output logic     clk_out
              );

             always_comb
             case(trigger)
             1'b0:
                begin
                  clk_out <= 0;
                end
             1'b1:
                begin
                  clk_out <= clk_in;
                end
				 endcase
endmodule

