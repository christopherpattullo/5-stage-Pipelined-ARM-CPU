// CPU BLOCK
`timescale 1ns/10ps

module CPU (clk, reset);
    input logic clk, reset;

    // Datapath buses
    logic [63:0] currInstr, NextInstrB1, NextInstrB2, NextInstr;
    logic [63:0] ReadData1, ReadData2, ALUB, imm12EXT, ALUResult, MemReadData;
    logic [63:0] RegWriteData, DAddr9EXT, CondAddr19EXT, BrAddr26EXT, ALUImm;
    logic [63:0] BranchVal, ShiftOut, ResultOut, ALUResultBuff, ALUBIn;
    logic [63:0] BuffRes, BufBufRes, MemDataO, ALUAIn, Data1, Data2;
    logic [63:0] Forward1, Forward2, FinalWriteData, PastInstr, DRead2, DRead2Buff;

    // Instruction/control buses
    logic [31:0] InstrStor, instruction, instruction1, instruction2, instruction3;
    logic [4:0]  readReg2;
    logic [2:0]  ALUOp, ALUOp1, ALUOp2;

    // Scalar control/status signals
    logic Zero, Reg2Loc, Reg2Loc1, ShiftSel, ShiftSel1, ShiftSel2;
    logic MemRead, MemRead1, MemRead2, MemRead3;
    logic MemToReg, MemToReg1, MemToReg2, MemToReg3;
    logic MemWrite, MemWrite1, MemWrite2, MemWrite3;
    logic ALUSrc, ALUSrc1, RegWrite, RegWrite1, RegWrite2, RegWrite3, RegWrite4;
    logic Negative, Overflow, CarryOut, InstrCo1, InstrCo2;
    logic NegativeVal, ZeroVal, OverflowVal, CarryOutVal;
    logic SetFlags, SetFlags1, SetFlags2, ImmSel, ImmSel1;
    logic BSel, BTaken, BTakenBool, FWDSRC1, FWDSRC2, ALUSRC1, ALUSRC2;
    logic CBZ, BLT, CBZTrue, BLTTrue, CBZ1, BLT1, BTaken1, BSel1;
    logic zeroa, accNeg, realNeg, flagsNotSet, negRegSig;

    // -------------------------------------------------------------------------
    // Stage 1: Instruction Fetch + Branching Control
    control cnrlLogic (
        InstrStor[31:21], Reg2Loc, ShiftSel, MemRead, MemToReg, ALUOp, MemWrite,
        ALUSrc, RegWrite, SetFlags, ImmSel, BSel, BTaken, CBZ, BLT
    );

    PC         programCounter   (NextInstr, currInstr, reset, clk);
    instructmem instructionMemory (currInstr, InstrStor, clk);
    adder64    PCAdd            (currInstr, 64'b100, 1'b0, InstrCo1, NextInstrB1);
    adder64    PCBAdd           (PastInstr, BranchVal, 1'b0, InstrCo2, NextInstrB2);

    SignExtend19 SE19 (instruction[23:5], CondAddr19EXT);
    SignExtend26 SE26 (instruction[25:0], BrAddr26EXT);
    D_FF btbuff  (BTaken1, BTaken, reset, clk);
    D_FF bsbuff  (BSel1, BSel, reset, clk);
    D_FF cbzbuff (CBZ1, CBZ, reset, clk);
    D_FF bltbuff (BLT1, BLT, reset, clk);

    and #50 cbztaken (CBZTrue, zeroa, CBZ1);
    and64   zeroaccelerate (Data2, zeroa);
    not #50 unset (flagsNotSet, SetFlags2);
    and #50 negRegSignificance (negRegSig, flagsNotSet, Negative);
    and #50 accneg   (accNeg, NegativeVal, SetFlags2);
    or  #50 realneg  (realNeg, accNeg, negRegSig);
    and #50 blttaken (BLTTrue, realNeg, BLT1);
    or  #50 branch   (BTakenBool, BTaken1, CBZTrue, BLTTrue);

    genvar i;
    generate
        for (i = 0; i < 64; i++) begin : BRCTRL
            mux2_1 PCNEXTVAL   (NextInstrB1[i], NextInstrB2[i], BTakenBool, NextInstr[i]);
            mux2_1 PCimmediate (BrAddr26EXT[i], CondAddr19EXT[i], BSel1, BranchVal[i]);
            D_FF   PCbuff      (PastInstr[i], currInstr[i], reset, clk);
        end
    endgenerate

    generate
        for (i = 0; i < 32; i++) begin : regs1
            D_FF instrstr1 (instruction[i], InstrStor[i], reset, clk);
        end
        for (i = 0; i < 3; i++) begin : ALUOPeration
            D_FF ALUOPFF (ALUOp1[i], ALUOp[i], reset, clk);
        end
    endgenerate

    D_FF reg2locBuff  (Reg2Loc1, Reg2Loc, reset, clk);
    D_FF shhiftselbuff (ShiftSel1, ShiftSel, reset, clk);
    D_FF memreadbuff  (MemRead1, MemRead, reset, clk);
    D_FF memtoregBuff (MemToReg1, MemToReg, reset, clk);
    D_FF memwritebuff (MemWrite1, MemWrite, reset, clk);
    D_FF alusrcbuff   (ALUSrc1, ALUSrc, reset, clk);
    D_FF regwriteBuff (RegWrite1, RegWrite, reset, clk);
    D_FF setflagsbuff (SetFlags1, SetFlags, reset, clk);
    D_FF immsellbuff  (ImmSel1, ImmSel, reset, clk);

    // -------------------------------------------------------------------------
    // Stage 2: Insntruction Decode + Read Registers
    regfile file (
        ReadData1, ReadData2, FinalWriteData, instruction[9:5], readReg2,
        instruction3[4:0], RegWrite4, clk
    );

    forwardingCTRL forwarding (
        instruction[9:5], readReg2, instruction1[4:0], instruction2[4:0],
        RegWrite2, RegWrite3, FWDSRC1, FWDSRC2, ALUSRC1, ALUSRC2, reset
    );

    zeroExtend  ZE  (instruction[21:10], imm12EXT);
    SignExtend9 SE9 (instruction[20:12], DAddr9EXT);

    generate
        for (i = 0; i < 5; i++) begin : readingreg2
            mux2_1 reg2in (instruction[i + 16], instruction[i], Reg2Loc1, readReg2[i]);
        end
        for (i = 0; i < 64; i++) begin : ALUBin
            mux2_1 forwardingval1 (ResultOut[i], RegWriteData[i], FWDSRC1, Forward1[i]);
            mux2_1 forwardingval2 (ResultOut[i], RegWriteData[i], FWDSRC2, Forward2[i]);
            mux2_1 regoutalmost1  (ReadData1[i], Forward1[i], ALUSRC1, Data1[i]);
            mux2_1 regoutalmost2  (ReadData2[i], Forward2[i], ALUSRC2, Data2[i]);
            mux2_1 alub           (Data2[i], ALUImm[i], ALUSrc1, ALUB[i]);
            mux2_1 aluimmediate   (imm12EXT[i], DAddr9EXT[i], ImmSel1, ALUImm[i]);
        end
    endgenerate

    generate
        for (i = 0; i < 64; i++) begin : regs2
            D_FF aluain (ALUAIn[i], Data1[i], reset, clk);
            D_FF alubin (ALUBIn[i], ALUB[i], reset, clk);
            D_FF dread2 (DRead2[i], Data2[i], reset, clk);
        end
        for (i = 0; i < 32; i++) begin : regs22
            D_FF instrstr2 (instruction1[i], instruction[i], reset, clk);
        end
        for (i = 0; i < 3; i++) begin : ALUOPeritcs
            D_FF instrstr1 (ALUOp2[i], ALUOp1[i], reset, clk);
        end
    endgenerate

    D_FF shhiftselbuff1 (ShiftSel2, ShiftSel1, reset, clk);
    D_FF memreadbuff1   (MemRead2, MemRead1, reset, clk);
    D_FF memtoregBuff1  (MemToReg2, MemToReg1, reset, clk);
    D_FF memwritebuff1  (MemWrite2, MemWrite1, reset, clk);
    D_FF regwriteBuff1  (RegWrite2, RegWrite1, reset, clk);
    D_FF setflagsbuff1  (SetFlags2, SetFlags1, reset, clk);

    // -------------------------------------------------------------------------
    // Stage 3: Execute + Set Flags
    alu MainALU (
        ALUAIn, ALUBIn, ALUOp2, ALUResult, NegativeVal, ZeroVal, OverflowVal, CarryOutVal
    );

    D_FFEnable negLatch    (SetFlags2, Negative, NegativeVal, reset, clk);
    D_FFEnable ZeroLatch   (SetFlags2, Zero, ZeroVal, reset, clk);
    D_FFEnable OverflLatch (SetFlags2, Overflow, OverflowVal, reset, clk);
    D_FFEnable COLatch     (SetFlags2, CarryOut, CarryOutVal, reset, clk);

    generate
        for (i = 0; i < 64; i++) begin : resultselect
            mux2_1 resultsel (ALUResult[i], ShiftOut[i], ShiftSel2, ResultOut[i]);
        end
    endgenerate

    RightShifter LogicalRight (ShiftOut, ALUAIn, instruction1[15:10]);

    generate
        for (i = 0; i < 64; i++) begin : regs3
            D_FF alubuffer (ALUResultBuff[i], ALUResult[i], reset, clk);
            D_FF reso      (BuffRes[i], ResultOut[i], reset, clk);
            D_FF dread2    (DRead2Buff[i], DRead2[i], reset, clk);
        end
        for (i = 0; i < 32; i++) begin : regs32
            D_FF instrstr3 (instruction2[i], instruction1[i], reset, clk);
        end
    endgenerate

    D_FF memreadbuff2  (MemRead3, MemRead2, reset, clk);
    D_FF memtoregBuff2 (MemToReg3, MemToReg2, reset, clk);
    D_FF memwritebuff2 (MemWrite3, MemWrite2, reset, clk);
    D_FF regwriteBuff2 (RegWrite3, RegWrite2, reset, clk);

    // -------------------------------------------------------------------------
    // Stage 4: Memory
    datamem Mem (
        ALUResultBuff, MemWrite3, MemRead3, DRead2Buff, clk, 4'b1000, MemReadData
    );

    generate
        for (i = 0; i < 64; i++) begin : regs4
            D_FF reso1   (FinalWriteData[i], RegWriteData[i], reset, clk);
            D_FF memdata (MemDataO[i], MemReadData[i], reset, clk);
        end
        for (i = 0; i < 32; i++) begin : regs42
            D_FF instrstr2 (instruction3[i], instruction2[i], reset, clk);
        end
    endgenerate

    D_FF regwriteBuff3 (RegWrite4, RegWrite3, reset, clk);

    // -------------------------------------------------------------------------
    // Stage 5: WriteBack
    generate
        for (i = 0; i < 64; i++) begin : finalWrites
            mux2_1 regwritesel (BuffRes[i], MemReadData[i], MemToReg3, RegWriteData[i]);
        end
    endgenerate
endmodule

module CPU_testbench ();
    logic clk, reset;
    parameter PERIOD = 100000;

    initial begin
        clk <= 0;
        forever #(PERIOD / 2) clk = ~clk;
    end

    CPU dut (clk, reset);

    integer i;
    initial begin
        reset <= 1'b1;
        @(posedge clk);
        reset <= 1'b0;
        @(posedge clk);

        // Read every location, including just past the end of memory.
        for (i = 0; i <= 140; i++) begin
            @(posedge clk);
            #1000;
        end

        $stop;
    end
endmodule
