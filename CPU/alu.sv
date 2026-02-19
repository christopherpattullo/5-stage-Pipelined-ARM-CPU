//ALU
`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic[63:0] A, B;
	input logic[2:0] cntrl;
	output logic[63:0] result;
	output logic negative, zero, overflow, carry_out;
	logic[63:0] ADDO, ANDO, ORO, XORO;
	logic COHI;
	
	adder64 adder (A, B, cntrl[0], carry_out, ADDO); //adder and subtracter
	and64 zeroa (result, zero);
	
	genvar i;
	generate
	 for (i = 0; i < 64; i++) begin : genBillAndMelinda
		and #50 ands (ANDO[i], A[i], B[i]);
		or #50 ors (ORO[i], A[i], B[i]);
		xor #50 xors (XORO[i], A[i], B[i]);
		mux8_1 muxs (B[i], 1'b0, ADDO[i], ADDO[i], ANDO[i], ORO[i], XORO[i], 1'b0, cntrl, result[i]);
	 end
	endgenerate
	
	assign negative = result[63];
	
	and #50 COHIAnd (COHI, A[63], B[63]);
	xor #50 overfl (overflow, carry_out, COHI);
endmodule 