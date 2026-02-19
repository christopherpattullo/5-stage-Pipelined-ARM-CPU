//and64
`timescale 1ns/10ps

module and64 (I, O);
	input logic[63:0] I;
	output logic O;
	logic[3:0] intermediate;
	
	and #50 finalAnd (O, intermediate[0], intermediate[1], intermediate[2], intermediate[3]);
	
	genvar i;
	generate
		for (i = 0; i < 4; i++) begin : genAnd
			and16 ands (I[16*i + 15:16*i], intermediate[i]);
		end
	endgenerate
	
endmodule

module and64_testbench();
	logic[15:0] I;
	logic O;
	
	and16 dut (I, O);
	
	integer i;
	initial begin 
		#1000;
		I = 64'b0000000000000000000000000000000000000000000000000000000000000000; #1000;
		I = 64'b1111111111111111111111111111111111111111111111111111111111111111; #1000;
		I = 64'b0111111111111111111111111111111111111111111111111111111111111111; #1000;
		I = 64'b1011111111111111111111111111111111111111111111111111111111111111; #1000;
		for(i = 0; i < 2 ** 6 - 2; i++) begin
			I >>>= 1; #1000;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 