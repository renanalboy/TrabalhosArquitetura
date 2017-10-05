`timescale 1ns / 1ns
module talu();

  logic clk;
  logic [31:0] a, b, y, y_expected;
  logic [2:0]  f;
  logic        zero, zero_expected;

  logic [31:0] vectornum, errors;
  logic [103:0] testvectors[10000:0];

  // instantiate device under test
  alu dut(a, b, f, y, zero);

  // generate clock
  always begin
    clk = 1; #50; clk = 0; #50;
  end

  // at start of test, load vectors
  initial begin
    $readmemh("alu.tv", testvectors);
    vectornum = 0; errors = 0;
  end

  // apply test vectors at rising edge of clock
  always @(posedge clk)
    begin
      #1; 
      f = testvectors[vectornum][102:100];
      a = testvectors[vectornum][99:68];
      b = testvectors[vectornum][67:36];
      y_expected = testvectors[vectornum][35:4];
      zero_expected = testvectors[vectornum][0];
    end

 // check results on falling edge of clock
 always @(negedge clk) 
   begin
     if (y !== y_expected || zero !== zero_expected) begin
       $display("Error in vector %d", vectornum);
       $display(" Inputs : a = %h, b = %h, f = %b", a, b, f);
       $display(" Outputs: y = %h (%h expected), zero = %h (%h expected)", 
         y, y_expected, zero, zero_expected); 
       errors = errors+1;
     end
     vectornum = vectornum + 1;
     if (testvectors[vectornum][0] === 1'bx) begin
       $display("%d tests completed with %d errors", vectornum, errors);
       $stop;
     end
   end

endmodule
