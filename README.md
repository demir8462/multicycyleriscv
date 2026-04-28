# ELE432 - HW2: Multicycle RISC-V Controller

## 🎯 Objective
In this homework, a multicycle RISC-V **controller** was designed in SystemVerilog based on the FSM architecture described in the course material.

The controller includes:
- Main FSM (Finite State Machine)
- ALU Decoder
- Instruction Decoder

---

## 🧠 Design Overview

The controller generates control signals based on:
- Current FSM state
- Instruction fields (`op`, `funct3`, `funct7b5`)
- ALU zero flag

Key control outputs:
- `ALUSrcA`, `ALUSrcB`
- `ResultSrc`
- `AdrSrc`
- `ALUControl`
- `IRWrite`, `PCWrite`
- `RegWrite`, `MemWrite`

The design follows the multicycle control architecture described in the course textbook and lecture materials.

---

## 🧪 Simulation Results

### ❌ Initial Debug Phase

During early testing, errors were observed due to:
- Incorrect ALUControl encoding
- Incorrect handling of `ImmSrc` for R-type instructions

![Controller Test Errors](./controllertberror.png)

---

### ✅ Final Working Version

After fixing:
- ALU decoder logic (based on Table 1)
- Instruction decoder (`ImmSrc = xx` for R-type instructions)

All test vectors passed successfully:
