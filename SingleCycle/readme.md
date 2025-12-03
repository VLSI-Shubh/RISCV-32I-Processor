# Single Cycle Execution Project

## Overview
This project implements a single-cycle CPU architecture where each instruction executes in one clock cycle. It covers basic instruction types including data processing, load/store, and branch instructions.

## Features
- Single-cycle datapath: instruction fetch, decode, execute, memory, and write-back in one cycle
- RV32I subset:
  - R-type and I-type ALU operations (ADD/SUB/AND/OR/XOR/shift/SLT/SLTU, etc.)
  - Load and store (word) instructions
  - Branch instructions (e.g., BEQ/BNE) using PC-relative offsets
  - Support for LUI / AUIPC via the immediate generator
- Clean, modular Verilog: separate ALU, control, register file, PC, immediate generator, and memory

## Repository Structure

```
    src/                     
    ├── core_sc.v                 
    ├── alu.v               
    ├── alu_control.v        
    ├── control.v          
    ├── reg_file.v          
    ├── pc.v 
    ├── branch_unit.v                 
    ├── inst_mem.v           
    ├── imm.v          
    ├── mux.v       
    └── adder.v             

    tb/                      # Testbenches
    ├── modules testbench/    
    ├── tb1_core_sc.v         
    └── tb2_core_sc.v          
 

```
## Testbenches
There are two main core-level testbenches:

```tb1_core_sc.v ```

    - Loads a short program into instruction.mem.

    - Exercises one representative instruction from each supported class (R-type, I-type, load, store, branch, LUI, etc.).

    - Intended for quick sanity checks of the datapath and control.

```tb2_core_sc.v ```

    - Runs a small RISC-V program that computes 5! = 120.

    - Multiplication is implemented using a repeated-addition loop (Euclidean-style iterative algorithm) inside the program, not as a dedicated MUL instruction in hardware.

    - The final result is written into a chosen destination register (e.g., x10) so it can be inspected in the waveform.

    - Module-level testbenches inside tb/modules testbench/ are used to verify ALU, register file, immediate generator, and other building blocks individually before integrating them into the core.

## Project Structure
- `src/` - Source code for CPU implementation
- `tb/` - Test cases for various instructions


## How to Build and Run
1. Clone the repository
2. Build the project using the provided build script or Makefile
3. Run tests to verify instruction execution

## Notes
- The single-cycle design means the clock cycle is determined by the longest instruction path.
- Branch instructions update the program counter in the same cycle.

## Contributing
Feel free to fork and send pull requests for improvements or bug fixes.

## License
Open for educational and personal use under the [MIT License](../License.txt)

