//shifter
`timescale 1ns/10ps
module RightShifter (valOut, valIn, shamt);
	input logic[63:0] valIn;
	input logic [5:0] shamt;
	output logic[63:0] valOut;
	logic[63:0] O1, O2, O3, O4, O5;
	
	genvar i;
	generate 
	 for (i = 0; i < 63; i++) begin : shift1
		mux2_1 sh1 (valIn[i], valIn[i + 1], shamt[0], O1[i]);
	 end
	 mux2_1 sh1 (valIn[63], 1'b0, shamt[0], O1[63]);//all bits for 1 shift set
	 
	 for (i = 0; i < 62; i++) begin : shift2
		mux2_1 sh2 (O1[i], O1[i + 2], shamt[1], O2[i]);
	 end
	 mux2_1 sh2_0 (O1[62], 1'b0, shamt[1], O2[62]);
	 mux2_1 sh2_1 (O1[63], 1'b0, shamt[1], O2[63]);
	 
	 for (i = 0; i < 60; i++) begin : shift4
		mux2_1 sh3 (O2[i], O2[i + 4], shamt[2], O3[i]);
	 end
	 for (i = 60; i < 64; i++) begin : shift4_rem
		mux2_1 sh3_r (O2[i], 1'b0, shamt[2], O3[i]); 
	 end
	 
	 for (i = 0; i < 56; i++) begin : shift8
		mux2_1 sh4 (O3[i], O3[i + 8], shamt[3], O4[i]);
	 end
	 for (i = 56; i < 64; i++) begin : shift8_rem
		mux2_1 sh4_r (O3[i], 1'b0, shamt[3], O4[i]);
	 end
	 
	 for (i = 0; i < 48; i++) begin : shift16
		mux2_1 sh5 (O4[i], O4[i + 16], shamt[4], O5[i]);
	 end
	 for (i = 48; i < 64; i++) begin : shift16_rem
		mux2_1 sh5_r (O4[i], 1'b0, shamt[4], O5[i]);
	 end
	 
	 for (i = 0; i < 32; i++) begin : shift32
		mux2_1 sh6 (O5[i], O5[i + 32], shamt[5], valOut[i]);
		mux2_1 sh6_r (O5[i + 32], 1'b0, shamt[5], valOut[i + 32]);
	 end
	endgenerate
endmodule

module RightShifter_testbench();
	logic[5:0] shamt;
	logic[63:0] valIn, valOut;
	
	RightShifter dut (valOut, valIn, shamt);
	
	integer i;
	initial begin 
		valIn = 64'b0101010101010101010101010101010101010101010101010101010101010101;
		for(i = 0; i < 2 ** 6; i++) begin
			shamt = i; #10000;
		end //forloop
		
	$stop;
	
	end //initial
	
endmodule 