//SignExtend19
`timescale 1ns/10ps
module SignExtend19 (imm19, SEimm19);
	input logic[18:0] imm19;
	output logic[63:0] SEimm19;
	
	assign SEimm19[20:2] = imm19[18:0];
	assign SEimm19[1:0] = 0;
	
	genvar i;
	generate
	 for (i = 21; i < 64; i++) begin : genBillAndMelinda
		or #50 ors (SEimm19[i], 1'b0, imm19[18]);
	 end
	endgenerate
endmodule

module SignExtend19_testbench ();
	logic[18:0] imm19;
	logic[63:0] SEimm19;
	
	SignExtend19 dut (imm19, SEimm19);
	
	integer i;
	initial begin 
	
		imm19 = 26'b1111111111111111111; #1000;
		imm19 = 26'b0111111111111111111; #1000;
		
	$stop;
	
	end //initial


endmodule 