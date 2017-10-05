//------------------------------------------------
// mipsmem.sv
// Sarah_Harris@hmc.edu 27 May 2007
// Update to SystemVerilog 17 Nov 2010 DMH
// External unified memory used by MIPS multicycle
// processor.
//------------------------------------------------

module memVideo(	input  logic        clk, we,
			input  logic [31:0] a,
			input  logic [31:0] wd,
			output logic [31:0] rd,
			input  logic [31:0] va,
			output logic [31:0] vdr,
			output logic [31:0] vdg,
			output logic [31:0] vdb);

  logic  [31:0] RAM[71:0];

  
  // initialize memory with instructions
  initial
    begin
      $readmemh("memfile_video.dat",RAM);  // "memfile.dat" contains your instructions in hex you must create this file
    end
	
	assign rd = RAM[a[31:2]]; // word aligned

	assign vdr = RAM[va[31:2]]; // word aligned
	assign vdg = RAM[va[31:2]+24]; // word aligned
	assign vdb = RAM[va[31:2]+48]; // word aligned

  always_ff @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule

module memMips1( input  logic        clk, we,
      input  logic [31:0] a,
      input  logic [31:0] wd, 
      output logic [31:0] rd);

  logic  [31:0] RAM[63:0];

  
  // initialize memory with instructions
  initial
    begin
      $readmemh("memfile_mips1.dat",RAM);  // "memfile.dat" contains your instructions in hex you must create this file
    end

  assign rd = RAM[a[31:2]]; // word aligned

  always_ff @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule

module memMips2( input  logic        clk, we,
      input  logic [31:0] a,
      input  logic [31:0] wd, 
      output logic [31:0] rd);

  logic  [31:0] RAM[63:0];

  
  // initialize memory with instructions
  initial
    begin
      $readmemh("memfile_mips2.dat",RAM);  // "memfile.dat" contains your instructions in hex you must create this file
    end

  assign rd = RAM[a[31:2]]; // word aligned

  always_ff @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule

				
				