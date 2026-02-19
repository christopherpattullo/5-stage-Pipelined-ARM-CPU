//mux4_1
`timescale 1ns/10ps
module mux4_1 (I1, I2, I3, I4, SEL1, SEL2, O);
	input logic I1, I2, I3, I4, SEL1, SEL2;
	output logic O;
	logic BR1, BR2;

	mux2_1 mux1 (I1, I2, SEL1, BR1);
	mux2_1 mux2 (I3, I4, SEL1, BR2);
	mux2_1 mux3 (BR1, BR2, SEL2, O);
	
endmodule

module mux4_1_testbench ();
	logic I1, I2, I3, I4, SEL1, SEL2, O;
	
	mux4_1 dut (I1, I2, I3, I4, SEL1, SEL2, O);
	
	integer i;
	initial begin 
	
		for(i = 0; i < 2 ** 6; i++) begin
			{I1, I2, I3, I4, SEL1, SEL2} = i; #10;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 