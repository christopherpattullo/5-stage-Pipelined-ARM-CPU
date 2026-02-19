//zeroExtend
`timescale 1ns/10ps
module zeroExtend (imm12, ZEimm12);
	input logic[11:0] imm12;
	output logic[63:0]ZEimm12;
	
	assign ZEimm12[11:0] = imm12[11:0];
	assign ZEimm12[63:12] = 0;
endmodule

module zeroExtend_testbench ();
	logic[11:0] imm12;
	logic[63:0] ZEimm12;
	
	zeroExtend dut (imm12, ZEimm12);
	
	integer i;
	initial begin 
	
		for(i = 0; i < 2 ** 5; i++) begin
			imm12 = i; #10;
		end //forloop
		
	$stop;
	
	end //initial


endmodule 