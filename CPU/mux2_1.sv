//mux_2_1
`timescale 1ns/10ps
module mux2_1 (I1, I2, SEL, O);
	input logic I1, I2, SEL;
	output logic O;
	logic SEL_BAR, BR1, BR2;
	
	not #50 not1 (SEL_BAR, SEL);
	and #50 and1 (BR1, SEL_BAR, I1);
	and #50 and2 (BR2, SEL, I2);
	or #50 or1 (O, BR1, BR2);
	
endmodule 

module mux2_1_testbench();
	logic I1, I2, SEL, O;
	
	mux2_1 dut (I1, I2, SEL, O);
	
	integer i;
	initial begin 
		#100;
		for(i = 0; i < 2 ** 3; i++) begin
			{I1, I2, SEL} = i; #100;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 