//ProgramCounter
`timescale 1ns/10ps
module PC (inAddr, outAddr, reset, CLK);
	input logic[63:0] inAddr;
	input logic reset, CLK;
	output logic[63:0] outAddr;
	
	genvar i;
	generate
	 for (i = 0; i < 64; i++) begin : genreg
		D_FFEnable addr (1'b1, outAddr[i], inAddr[i], reset, CLK);
	 end
	endgenerate
	
	
endmodule

module PC_testbench();
	logic clk, reset;
	logic[63:0] inAddr;
	logic[63:0] outAddr;

	
	parameter PERIOD = 1000; // period = length of clock
// Make the clock LONG to test
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
	
	PC dut (inAddr, outAddr, reset, clk);
	
	integer i;
	initial begin
		// Read every location, including just past the end of the memory.
		inAddr <= 32'b10010001000000000000001111100000;
		reset <= 1'b1;@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		reset <= 1'b0;@(posedge clk);
		inAddr <= 32'b0;  @(posedge clk);
		inAddr <= 32'b10010001000000000000001111100000;  @(posedge clk);
		inAddr <= 32'b10010001000000000000001001100000;  @(posedge clk);
		inAddr <= 32'b0;  										 @(posedge clk);
		inAddr <= 32'b10010001000000000000010000000001;  @(posedge clk);
		inAddr <= 32'b10010001000000000000001111100000;  @(posedge clk);
		
		$stop;
		
	end
endmodule 
