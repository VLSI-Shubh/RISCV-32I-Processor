# RISCV-32I-Processor

Welcome to the main branch of the RISCV-32I-Processor project. This branch contains the latest, stable, and working versions of the processor implementations.

## Project Overview

This repository implements the RISC-V 32I subset processor core in Verilog. It includes two main execution designs:

- **SingleCycle:** A simple single cycle implementation of the RISCV 32I core.
- **Pipeline:** A more advanced pipelined implementation.

The main branch contains fully functional and tested source files along with their corresponding testbenches. It serves as the central, most up-to-date snapshot of the project.

## Directory Structure
```
RISC-V-32I-Processor/
├── SingleCycle/
│ ├── rtl/
│ └── testbench/
├── Pipeline/
│ ├── rtl/
│ └── testbench/
└── README.md

```

## Current Status

- SingleCycle core is stable and capable of running basic instructions and simple programs.
- Pipelined core is under active development and testing.
- Test benches cover basic instruction tests and are being expanded for more complex scenarios.

## Usage

You can explore and use the implementations in the SingleCycle and Pipeline folders. Each design has its own source code and testbench setup to allow focused development and testing.

Contributions and feedback are welcome to improve both variants and extend functionality.

---

Check out the respective branches for detailed, work-in-progress versions focused on single cycle or pipelined designs.

Thank you for your interest in the RISCV-32I-Processor project!
