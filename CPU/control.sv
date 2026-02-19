//controlLogic/*
`timescale 1ns/10ps
module control (Logic, Reg2Loc, ShiftSel, MemRead, MemToReg, ALUOp, MemWrite, 
						ALUSrc, RegWrite, SetFlags, ImmSel, BSel, BTaken, CBZ, BLT);
	output logic Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags, ImmSel, BSel, BTaken, CBZ, BLT;
	output logic[2:0] ALUOp;
	input logic[10:0] Logic;
	
	always_comb begin
		casez (Logic)
			11'b1001000100?: begin//ADDI
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00000110;
				ALUOp[2:0] = 3'b010;
				ImmSel = 1'b0;
				BSel = 1'b0;
				BTaken = 0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b10101011000: begin//ADDS
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00000011;
				ALUOp[2:0] = 3'b010;
				ImmSel = 1'b0;
				BSel = 1'b0;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b11101011000: begin//SUBS
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00000011;
				ALUOp[2:0] = 3'b011;
				ImmSel = 1'b0;
				BSel = 1'b0;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b10001010000: begin//AND
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00000010;
				ALUOp[2:0] = 3'b100;
				ImmSel = 1'b0;
				BSel = 1'b0;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b000101?????: begin//Unconditional Branch	
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b01000000;
				ALUOp[2:0] = 3'b011;
				ImmSel = 1'b0;
				BSel = 1'b0;//0 = imm26
				BTaken = 1'b1;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b01010100???: begin//Conditional Branch	.LT
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b01000000;
				ALUOp[2:0] = 3'b011;
				ImmSel = 1'b0;
				BSel = 1'b1;//0 = imm19
				BTaken = 1'b0; //and with NEGATIVE
				CBZ = 1'b0;
				BLT = 1'b1;
				end
			11'b10110100???: begin//CBZ	
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b10000001;
				ALUOp[2:0] = 3'b000;
				ImmSel = 1'b0;
				BSel = 1'b1;//0 = imm19
				BTaken = 1'b0; //and with ZeroRaw
				CBZ = 1'b1;
				BLT = 1'b0;
				end
			11'b11001010000: begin//EOR
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00000010;
				ALUOp[2:0] = 3'b110;
				ImmSel = 1'b0;
				BSel = 1'b1;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b11111000010: begin//LDUR
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00110110;
				ALUOp[2:0] = 3'b010;
				ImmSel = 1'b1;//DAddr9
				BSel = 1'b1;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b11111000000: begin//STUR
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b10001100;
				ALUOp[2:0] = 3'b010;
				ImmSel = 1'b1;//DAddr9
				BSel = 1'b1;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			11'b11010011010: begin//LSR UNFINISHED 
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b01000110;
				ALUOp[2:0] = 3'b010;
				ImmSel = 1'b1;//DAddr9
				BSel = 1'b1;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			default: begin
				{Reg2Loc, ShiftSel, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, SetFlags} = 8'b00000000;
				ALUOp[2:0] = 3'b000;
				ImmSel = 1'b0;
				BSel = 1'b0;
				BTaken = 1'b0;
				CBZ = 1'b0;
				BLT = 1'b0;
				end
			
		endcase
	end
endmodule
