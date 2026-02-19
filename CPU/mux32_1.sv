//32:1 mux
`timescale 1ns/10ps
module mux32_1 (I, SEL, O);
	input logic[31:0] I;
	input logic[4:0] SEL;
	output logic O;
	logic BR1, BR2;
	
	mux16_1 mux1 (I[15:0], SEL[3:0], BR1);
	mux16_1 mux2 (I[31:16], SEL[3:0], BR2);
	mux2_1 mux3 (BR1, BR2, SEL[4], O);
	
endmodule

module mux32_1_testbench;

	logic[31:0] I;
	logic[4:0] SEL;
	logic O;
	
	mux32_1 dut (I, SEL, O);
	
	integer i;
	initial begin 
		I[31:0] <= 32'b10101010101010101010101010101010;
		for(i = 0; i < 2 ** 5; i++) begin
			SEL[4:0] = i; #1000;
		end //forloop
	
		I[31:0] <= 32'b01010101010101010101010101010101;
		for(i = 0; i < 2 ** 5; i++) begin
			SEL[4:0] = i; #1000;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 