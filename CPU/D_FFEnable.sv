//DFF with enable
`timescale 1ns/10ps
module D_FFEnable(EN, q, d, reset, clk);
	//output reg q; //somethings wrong with storage, how can I wire it to itself if its an output?
	input reset, clk;
	input logic EN, d;
	output logic q;
	logic IN, OUT;
	
	mux2_1 mux1 (OUT, d, EN, IN);
	
	assign q = OUT;
	
	D_FF D_FF1 (OUT, IN, reset, clk);
	
endmodule

module D_FFEnable_testbench();
	logic EN, q, d, reset, clk;
	
	D_FFEnable dut (EN, q, d, reset, clk);
	
	initial begin 
	
		EN<=0; d<=1; reset<=1; clk<=0; #1000;
						 reset<=1; clk<=1; #1000;
						 reset<=0; clk<=0; #1000;
						 reset<=0; clk<=1; #1000;
						 reset<=0; clk<=0; #1000;
						 reset<=0; clk<=1; #1000;
		       d<=0; reset<=0; clk<=0; #1000;
		       d<=0; reset<=0; clk<=1; #1000;
				 
		EN<=1; d<=1; reset<=1; clk<=0; #1000;
						 reset<=1; clk<=1; #1000;
						 reset<=0; clk<=0; #1000;
						 reset<=0; clk<=1; #1000;
						 reset<=0; clk<=0; #1000;
						 reset<=0; clk<=1; #1000;
		       d<=0; reset<=0; clk<=0; #1000;
		       d<=0; reset<=0; clk<=1; #1000;

	$stop;
	
	end //initial


endmodule 
	
