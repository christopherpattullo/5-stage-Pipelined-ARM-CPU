//2:4 decoder
`timescale 1ns/10ps
module decoder2_4 (I, EN, O);
	input logic[1:0] I;
	input logic EN;
	output logic[3:0] O;
	logic I0BAR, I1BAR;
	
	not #50 not1 (I0BAR, I[0]);
	not #50 not2 (I1BAR, I[1]);
	
	and #50 and1 (O[0], I0BAR, I1BAR, EN);
	and #50 and2 (O[1], I[0], I1BAR, EN);
	and #50 and3 (O[2], I0BAR, I[1], EN);
	and #50 and4 (O[3], I[0], I[1], EN);
	
endmodule

module decoder2_4_testbench ();
	logic[1:0] I;
	logic[3:0] O;
	logic EN;
	
	decoder2_4 dut (I, EN, O);
	
	integer i;
	initial begin 
		EN <= 1;
		for(i = 0; i < 2 ** 2; i++) begin
			I[1:0] = i; #1000;
		end
		EN <= 0;
		for(i = 0; i < 2 ** 2; i++) begin
			I[1:0] = i; #1000;
		end
		
	$stop;
	
	end //initial


endmodule 