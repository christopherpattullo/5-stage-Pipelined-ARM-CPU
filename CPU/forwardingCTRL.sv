//fulladder
`timescale 1ns/10ps

module forwardingCTRL (DataReg1, DataReg2, WriteReg1, WriteReg2, WriteEN1, WriteEN2, FWDSRC1, FWDSRC2, ALUSRC1, ALUSRC2, reset);
	input logic[4:0] DataReg1, DataReg2, WriteReg1, WriteReg2;
	input logic reset, WriteEN1, WriteEN2;
	output logic FWDSRC1, FWDSRC2, ALUSRC1, ALUSRC2;
	//need to include regwrites and make sure that it isnt x31, this can be put into alusrc
	always_comb begin
		if (reset) begin
			FWDSRC1 = 0;
			FWDSRC2 = 0;
			ALUSRC1 = 0;
			ALUSRC2 = 0;
		end
		//check if any of the previously written to registers are now being read (exclude X31 and make sure write flag is TRUE)
		ALUSRC1 = (((DataReg1 == WriteReg1) && WriteEN1) || ((DataReg1 == WriteReg2) && WriteEN2)) && DataReg1 != 31;
		ALUSRC2 = (((DataReg2 == WriteReg1) && WriteEN1) || ((DataReg2 == WriteReg2) && WriteEN2)) && DataReg2 != 31;
		//set equal to the correct one, doesnt matter if not chosen by mux with flags above
		//make sure that it takes the most recent value (set flags assuming it will always be 1 unless its 0)
		FWDSRC1 = ~(DataReg1 == WriteReg1);
		FWDSRC2 = ~(DataReg2 == WriteReg1);
	end
	
	
endmodule 
