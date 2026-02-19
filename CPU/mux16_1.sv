//mux16_1

module mux16_1 (I, SEL, O);
	input logic[15:0] I;
	input logic [3:0] SEL;
	output logic O;
	logic BR1, BR2, BR3, BR4;
	
	mux4_1 mux1(I[0], I[1], I[2], I[3], SEL[0], SEL[1], BR1);
	mux4_1 mux2(I[4], I[5], I[6], I[7], SEL[0], SEL[1], BR2);
	mux4_1 mux3(I[8], I[9], I[10], I[11], SEL[0], SEL[1], BR3);
	mux4_1 mux4(I[12], I[13], I[14], I[15], SEL[0], SEL[1], BR4);
	mux4_1 mux5(BR1, BR2, BR3, BR4, SEL[2], SEL[3], O);
	
endmodule

module mux16_1_testbench;

	logic[15:0] I;
	logic[3:0] SEL;
	logic O;
	
	mux16_1 dut (I, SEL, O);
	
	integer i;
	initial begin 
		I[15:0] <= 16'b1010101010101010;
		#700;
		for(i = 0; i < 2 ** 4; i++) begin
			SEL[3:0] = i; #700;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 