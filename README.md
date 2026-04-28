# ELE432 - HW2 + Preliminary Work 3  
## Multicycle RISC-V Controller & Processor

---

## 🎯 Objective

This work includes both:

- **HW2:** Design of a multicycle RISC-V controller  
- **Preliminary Work 3:** Integration of the controller with datapath and memory to build a complete multicycle RISC-V processor

The design follows the multicycle architecture described in the course material.

---

## 🧠 Design Overview

### 🔹 Controller (HW2)

The controller is implemented using an FSM-based architecture and consists of:

- Main FSM (Finite State Machine)
- ALU Decoder (`aludec`)
- Instruction Decoder (`instrdec`)

The controller generates control signals based on:
- FSM state
- Instruction fields (`op`, `funct3`, `funct7b5`)
- ALU zero flag

#### Main Outputs:
- `ImmSrc`
- `ALUSrcA`, `ALUSrcB`
- `ResultSrc`
- `AdrSrc`
- `ALUControl`
- `IRWrite`, `PCWrite`
- `RegWrite`, `MemWrite`

---

### 🔹 Multicycle Processor (Pre3)

The processor consists of:

- `controller`
- `datapath`
- Unified `memory`

Key datapath components:
- Program Counter (PC)
- Instruction Register
- Register File
- ALU
- Immediate Extender
- Internal registers (A, B, ALUOut)

A **single unified memory** is used for both instructions and data.

---

## 🧪 Simulation Results

### 🔹 Controller (HW2)

The controller was tested independently and passed all test cases with **0 errors**.

![Controller Testbench Result](./controllertberror.png)

---

### 🔹 Multicycle Processor (Pre3)

The full processor was simulated using the provided testbench and memory file.

### ✅ Successful Execution

At the final cycle:

- `MemWrite = 1`
- `DataAdr = 0x00000064` (decimal 100)
- `WriteData = 0x00000019` (decimal 25)

This confirms:
mem[100] = 25

which matches the expected program result.

---

## 📊 Multicycle Processor Waveform

The waveform below shows the correct execution of the processor and the final memory write operation.

![Processor Waveform](./basari.png)

---

## 📈 Observations

- The FSM correctly transitions through fetch, decode, execute, memory, and writeback stages.
- ALU operations and immediate decoding are consistent with instruction types.
- Proper coordination between controller and datapath ensures correct execution.
- The final memory write confirms end-to-end system correctness.

---

## 🛠️ Tools Used

- SystemVerilog  
- QuestaSim / ModelSim  
- Quartus Prime Lite  

---

## ⏱️ Time Spent

- HW2 (Controller): ~1 hour  
- Preliminary Work 3 (Integration & Debug): ~3–4 hours  

---

## 🚀 Notes

- Debugging was performed by comparing expected FSM behavior with waveform outputs.
- Correct ALUControl encoding and proper ImmSrc selection were critical.
- The design successfully passes the provided testbench (**Simulation succeeded**).

---
