//3:8 decoder
`timescale 1ns/10ps
module decoder3_8(I, EN, O);
	input logic[2:0] I;
	input logic EN;
	output logic[7:0] O;
	logic I2BAR, EN1, EN2;
	
	not #50 not1 (I2BAR, I[2]);
	
	and #50 and1 (EN1, EN, I2BAR);
	and #50 and2 (EN2, EN, I[2]);
	
	decoder2_4 dec1 (I[1:0], EN1, O[3:0]);
	decoder2_4 dec2 (I[1:0], EN2, O[7:4]);
	
endmodule

module decoder3_8_testbench ();
	logic[2:0] I;
	logic[7:0] O;
	logic EN;
	
	decoder3_8 dut (I, EN, O);
	
	integer i;
	initial begin 
		EN <= 1;
		for(i = 0; i < 2 ** 3; i++) begin
			I[2:0] = i; #1000;
		end
		EN <= 0;
		for(i = 0; i < 2 ** 2; i++) begin
			I[2:0] = i; #1000;
		end
		
	$stop;
	
	end //initial


endmodule 
	