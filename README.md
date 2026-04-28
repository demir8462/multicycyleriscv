# ELE432 - HW2: Multicycle RISC-V Controller

## 🎯 Objective

In this homework, a multicycle RISC-V controller was designed in SystemVerilog based on the FSM architecture described in the course material.

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

Main outputs:
- `ImmSrc`
- `ALUSrcA`, `ALUSrcB`
- `ResultSrc`
- `AdrSrc`
- `ALUControl`
- `IRWrite`, `PCWrite`
- `RegWrite`, `MemWrite`

The design follows the multicycle control architecture described in the course textbook.

---

## 🧪 Simulation Result

The controller was simulated using the provided testbench and test vector file.

The final simulation completed successfully with: 0 error


### ✅ 0 Error Result (Transcript)

![Controller Result](./controllertberror.png)

---

## 📊 Testbench Waveform

The waveform below shows the behavior of the controller signals during simulation.

![Controller Waveform](./controllertb.png)

---

## 🛠️ Tools Used

- SystemVerilog
- QuestaSim / ModelSim

---

## 🚀 Notes

- The controller was debugged by comparing expected and actual outputs at each FSM state.
- Correct ALUControl encoding and proper handling of `ImmSrc` were critical for passing all tests.
- This controller will be used in **Lab 3** to build the complete multicycle RISC-V processor.

---

## ⏱️ Time Spent
1 hour for the controller
