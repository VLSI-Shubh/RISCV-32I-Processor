<p align="left">
  <img src="https://img.shields.io/badge/Single%20Cycle%20Execution%20RTL%20Design-Completed-brightgreen" />
  <img src="https://img.shields.io/badge/Single%20Cycle%20Functional%20Verification-Passed-brightgreen" />
  <img src="https://img.shields.io/badge/Single%20Cycle%20Synthesis-In%20Progress-yellow" />
  <img src="https://img.shields.io/badge/5%20Stage%20Pipeline%20Execution%20RTL%20Design-Completed-brightgreen" />
  <img src="https://img.shields.io/badge/5%20Stage%20Pipeline%20Functional%20Verification-Passed-brightgreen" />
  <img src="https://img.shields.io/badge/5%20Stage%20Pipeline%20Synthesis-Completed-brightgreen" />
  <img src="https://img.shields.io/badge/FPGA%20Implementation-Pending-orange" />
</p>


# RISCV-32I-Processor

Welcome to the main branch of the RISCV-32I-Processor project. This branch contains the latest, stable, and working versions of the processor implementations.

## Project Overview

This repository implements the RISC-V 32I subset processor core in Verilog. It includes two main execution designs:

- **Single Cycle:** A simple single cycle implementation of the RISCV 32I core.
- **Pipeline:** A more advanced pipelined implementation.

The main branch contains fully functional and tested source files along with their corresponding testbenches. It serves as the central, most up-to-date snapshot of the project.

### Shared Architecture Components

To maintain a clean architecture and avoid duplicating RTL code, the pipelined core directly imports and uses many modules from the Single Cycle implementation.  
These include:

- ALU  
- ALU Control  
- Register File  
- Control Unit  
- Immediate Generator  
- Program Counter  
- Branch Unit  
- MUX modules  
- Adders  
- Instruction Memory  

Only pipeline specific elements (stage logic, pipeline registers, hazard detection, forwarding paths) are implemented inside the Pipeline folder.  
This approach ensures both cores remain synchronized in functional behavior while reducing maintenance effort.


## Current Status

- The single-cycle core is stable and capable of running basic instructions and simple programs.  
- The pipelined core is stable and executes basic RV32I instructions/programs, but requires enhancements like branch prediction and MUL/DIV (M extension) for complex workloads.
- Test benches cover basic instruction tests and are being expanded for more complex scenarios.


## Usage

You can explore and use the implementations in the Single Cycle and Pipeline folders. Each design has its own source code and testbench setup to allow focused development and testing.

Contributions and feedback are welcome to improve both variants and extend functionality.

## License
Open for educational and personal use under the [MIT License](License.txt)
