//and16
`timescale 1ns/10ps
module and16 (I, O);
	input logic[15:0] I;
	output logic O;
	logic[3:0] intermediate;
	
	and #50 finalAnd (O, intermediate[0], intermediate[1], intermediate[2], intermediate[3]);
	
	genvar i;
	generate
		for (i = 0; i < 4; i++) begin : genNor
			nor #50 ors (intermediate[i], I[i*4], I[i*4 + 1], I[i*4 + 2], I[i*4 + 3]);
		end
	endgenerate
	
endmodule

module and16_testbench();
	logic[15:0] I;
	logic O;
	
	and16 dut (I, O);
	
	integer i;
	initial begin 
		#1000;
		I = 16'b0000000000000000; #1000;
		I = 16'b1111111111111111; #1000;
		I = 16'b0111111111111111; #1000;
		I = 16'b1011111111111111; #1000;
		for(i = 0; i < 2 ** 16; i++) begin
			I = i; #1000;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 