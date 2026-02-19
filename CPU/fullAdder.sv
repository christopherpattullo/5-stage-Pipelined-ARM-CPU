//fulladder
`timescale 1ns/10ps

module fullAdder (A, B, CI, CO, S);
	input logic A, B, CI;
	output logic CO, S;
	logic B1, B2, B3;
	
	xor #50 xor1(S, A, B, CI);
	and #50 and1(B1, A, B);
	and #50 and2(B2, A, CI);
	and #50 and3(B3, B, CI);
	or #50 or1(CO, B1, B2, B3);
	
endmodule 

module fullAdder_testbench();
	logic A, B, CI, CO, S;
	
	fullAdder dut (A, B, CI, CO, S);
	
	integer i;
	initial begin 
		for(i = 0; i < 2 ** 3; i++) begin
			{A, B, CI} = i; #1000;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 