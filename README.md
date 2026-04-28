# ELE432 - HW2 + Preliminary Work 3  
## Multicycle RISC-V Processor & Controller

---

## 🎯 Objective

This work includes both:

- **HW2:** Design of a multicycle RISC-V controller  
- **Preliminary Work 3:** Integration of the controller with datapath and memory to build a complete multicycle RISC-V processor

The design follows the multicycle architecture described in the course material and textbook.

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

The system uses a **single unified memory** for both instructions and data.

---

## 🧪 Simulation Results

The design was verified using the provided testbench and memory file.

### ✅ Successful Execution

At the final cycle:

- `MemWrite = 1`
- `DataAdr = 0x00000064` (decimal 100)
- `WriteData = 0x00000019` (decimal 25)

This confirms:
mem[100] = 25

## 🧾 Controller Testbench Result (HW2)

The controller was verified independently using its dedicated testbench.

![Controller TB Result](./controllertberror.png)

---

## 📊 Multicycle Processor Waveform (Pre3)

The waveform below shows the correct execution of the full multicycle RISC-V processor.

At the final cycle:
- MemWrite = 1  
- DataAdr = 0x00000064  
- WriteData = 0x00000019  

This confirms correct execution.

![Processor Waveform](./basari.png)
