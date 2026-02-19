////register file
`timescale 1ns/10ps

module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, 
						ReadRegister2, WriteRegister, RegWrite, clk);
	input logic	[4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	input logic RegWrite, clk;
	output logic [63:0] ReadData1, ReadData2;
	logic[31:0] RegEN;
	logic[63:0] RegO[31:0];
	logic invertedCLK;
	
	assign RegO[31] = 32'b0;
	
	decoder5_32 decoder (WriteRegister, RegWrite, RegEN);
	not #50 clkinv (invertedCLK, clk);
	genvar i, j;
	generate
	 for (i = 0; i < 31; i++) begin : genreg
		for (j = 0; j < 64; j++) begin : genindex
			D_FFEnable latches(RegEN[i], RegO[i][j], WriteData[j], 1'b0, invertedCLK);
		end
	 end
	 
	 for (i = 0; i < 64; i++) begin : genmux
            logic [31:0] bit_column;

            for (j = 0; j < 32; j++) begin : compileCols
                assign bit_column[j] = RegO[j][i];
            end

            mux32_1 mux1S (bit_column, ReadRegister1, ReadData1[i]);
				mux32_1 mux2S (bit_column, ReadRegister2, ReadData2[i]);
        end
	endgenerate

        
	
endmodule 
	
