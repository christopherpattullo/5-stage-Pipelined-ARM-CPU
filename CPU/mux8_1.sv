//mux8_1
`timescale 1ns/10ps
module mux8_1 (I1, I2, I3, I4,I5, I6, I7, I8, SEL, O);
	input logic I1, I2, I3, I4, I5, I6, I7, I8;
	input logic[2:0] SEL;
	output logic O;
	logic BR1, BR2;

	mux4_1 mux1 (I1, I2, I3, I4, SEL[0], SEL[1], BR1);
	mux4_1 mux2 (I5, I6, I7, I8, SEL[0], SEL[1], BR2);
	mux2_1 mux3 (BR1, BR2, SEL[2], O);
	
endmodule

module mux8_1_testbench ();
	logic I1, I2, I3, I4, I5, I6, I7, I8, O;
	logic[2:0] SEL;
	
	mux4_1 dut (I1, I2, I3, I4, I5, I6, I7, I8, SEL, O);
	
	integer i;
	initial begin 
	
		for(i = 0; i < 2 ** 11; i++) begin
			{I1, I2, I3, I4, I5, I6, I7, I8, SEL[0], SEL[1], SEL[2]} = i; #10;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 