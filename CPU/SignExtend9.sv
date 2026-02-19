//zeroExtend
`timescale 1ns/10ps
module SignExtend9 (imm9, SEimm9);
	input logic[8:0] imm9;
	output logic[63:0]SEimm9;
	
	assign SEimm9[8:0] = imm9[8:0];
	
	genvar i;
	generate
	 for (i = 9; i < 64; i++) begin : genBillAndMelinda
		or #50 ors (SEimm9[i], 1'b0, imm9[8]);
	 end
	endgenerate
endmodule

module SignExtend9_testbench ();
	logic[8:0] imm9;
	logic[63:0] ZEimm9;
	
	SignExtend9 dut (imm9, ZEimm9);
	
	integer i;
	initial begin 
	
		imm9 = 9'b111111111; #1000;
		imm9 = 9'b011111111; #1000;
		
	$stop;
	
	end //initial


endmodule 