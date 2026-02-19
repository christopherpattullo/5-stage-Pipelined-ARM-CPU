//decoder5:32
`timescale 1ns/10ps
module decoder5_32 (I, EN, O);
	input logic[4:0] I;
	input logic EN;
	output logic[31:0] O;
	logic[7:0] ENS;
	
	decoder3_8 u_en(I[4:2], EN, ENS[7:0]);
	
  genvar i;
  generate
    for (i = 0; i < 8; i++) begin : gendec
      decoder2_4 ex(I[1:0], ENS[i], O[(i + 1)*4 - 1: i * 4]);
    end
  endgenerate
endmodule

module decoder5_32_testbench ();
	logic[4:0] I;
	logic[31:0] O;
	logic EN;
	
	decoder5_32 dut (I, EN, O);
	
	integer i;
	initial begin 
		EN <= 1;
		for(i = 0; i < 2 ** 5; i++) begin
			I[4:0] = i; #1000;
		end
		EN <= 0;
		for(i = 0; i < 2 ** 5; i++) begin
			I[4:0] = i; #1000;
		end
		
	$stop;
	
	end //initial


endmodule 