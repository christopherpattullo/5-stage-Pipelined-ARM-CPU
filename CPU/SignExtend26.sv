//zeroExtend
`timescale 1ns/10ps
module SignExtend26 (imm26, SEimm26);
	input logic[25:0] imm26;
	output logic[63:0]SEimm26;
	
	assign SEimm26[27:2] = imm26[25:0];
	assign SEimm26[1:0] = 2'b0;
	
	genvar i;
	generate
	 for (i = 28; i < 64; i++) begin : genBillAndMelinda
		or #50 ors (SEimm26[i], 1'b0, imm26[25]);
	 end
	endgenerate
endmodule

module SignExtend26_testbench ();
	logic[25:0] imm26;
	logic[63:0] SEimm26;
	
	SignExtend26 dut (imm26, SEimm26);

	initial begin 
	
		imm26 = 26'b11111111111111111111111111; #1000;
		imm26 = 26'b01111111111111111111111111; #1000;
		
	$stop;
	
	end //initial


endmodule 