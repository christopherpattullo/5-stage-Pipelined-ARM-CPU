# 5-stage-Pipelined-ARM-CPU

A SystemVerilog implementation of a 64-bit, 5-stage pipelined ARM-like CPU.

## Overview

This project implements a classic 5-stage pipeline:

1. IF (Instruction Fetch)
2. ID (Instruction Decode / Register Read)
3. EX (Execute / ALU / Flags)
4. MEM (Data Memory)
5. WB (Write Back)

The top-level processor is `CPU/CPU.sv` (`module CPU`).

## Supported Instructions

The current control logic supports:

- `ADDI`
- `ADDS`
- `SUBS`
- `AND`
- `EOR`
- `LSR`
- `B` (unconditional branch)
- `CBZ`
- `BLT`
- `LDUR`
- `STUR`

## Project Structure

- `CPU/CPU.sv`: Top-level 5-stage pipelined CPU and integrated testbench.
- `CPU/control.sv`: Main control unit opcode decode.
- `CPU/alu.sv`, `CPU/adder64.sv`: Arithmetic/logic datapath blocks.
- `CPU/regfile.sv`: 32 x 64-bit register file.
- `CPU/forwardingCTRL.sv`: Forwarding/hazard bypass control.
- `CPU/PC.sv`: Program counter.
- `CPU/instructmem.sv`: Instruction ROM loaded from benchmark `.arm` file.
- `CPU/datamem.sv`: Byte-addressed data memory.
- `CPU/D_FF.sv`, `CPU/D_FFEnable.sv`: Pipeline storage primitives.
- `CPU/mux*.sv`, `CPU/decoder*.sv`, `CPU/SignExtend*.sv`, `CPU/zeroExtend.sv`: Utility modules.

## Running Benchmarks

Instruction memory uses a compile-time macro in `CPU/instructmem.sv` to load assembly code:

```systemverilog
`define BENCHMARK "../benchmarks/test01_AddiB.arm"
```

To run a different benchmark, change that line (or uncomment one of the alternatives in the file), then recompile.

## Notes

- Data and instruction memories are each configured to 1024 bytes by default.
- This is a course project codebase focused on pipeline behavior and instruction support rather than production synthesis flow.
