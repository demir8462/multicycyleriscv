# ELE432 - HW2: Multicycle RISC-V Controller

## Objective

In this homework, a multicycle RISC-V controller was designed in SystemVerilog.

The controller includes:
- Main FSM
- ALU Decoder
- Instruction Decoder

---

## Design Overview

The controller generates the required multicycle control signals using the current FSM state, instruction fields, and the ALU Zero signal.

Main outputs:
- `ImmSrc`
- `ALUSrcA`, `ALUSrcB`
- `ResultSrc`
- `AdrSrc`
- `ALUControl`
- `IRWrite`, `PCWrite`
- `RegWrite`, `MemWrite`

---

## Simulation Result

The controller was simulated using the provided controller testbench and test vector file.

The final simulation completed successfully with:

```text
40 tests completed with 0 errors
