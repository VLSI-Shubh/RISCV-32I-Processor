# Pipelined Execution Project

## Project Status
The project features a fully operational five-stage pipelined RV32I RISC-V core, designed in Verilog, which incorporates both hazard detection and forwarding units to efficiently manage data hazards and maintain correct instruction execution.

## Project Goal
To design and implement a five-stage pipelined CPU architecture capable of executing the RV32I instruction set.

## Implemented Components
- Instruction fetch stage  
- Instruction decode stage  
- Execute stage  
- Memory access stage  
- Write back stage  
- Pipeline registers between stages  
- Hazard detection unit  
- Forwarding unit  

## Planned Features
- Refinement of hazard detection and data forwarding logic for more complex programs  
- Static branch prediction for smoother pipeline flow  
- Full datapath and control signal validation across all pipeline stages  

## Next Steps
- Extend and refine the verification environment using additional RISC‑V programs  
- Analyze stalls, forwarding behavior, and branch handling using waveform-based debugging  
- Improve documentation and add more example testcases  

## Directory Structure
```
PipelineExecution/
├── core/
│   └── core_pip.v                  # Top-level pipelined RV32I core
│
├── stages/                         # Pipeline stage logic only (no shared modules here)
│   ├── fetch.v                     # IF stage
│   ├── if_id_reg.v                 # IF/ID pipeline register
│   ├── decode.v                    # ID stage (interfaces with shared regfile, control, imm)
│   ├── id_ex_reg.v                 # ID/EX pipeline register
│   ├── execute.v                   # EX stage (ALU interface, branch, forwarding)
│   ├── ex_mem_reg.v                # EX/MEM pipeline register
│   ├── memory.v                    # MEM stage
│   ├── mem_wb_reg.v                # MEM/WB pipeline register
│   ├── hazard_unit.v               # Load–use hazard detection
│   └── forwarding_unit.v           # Forwarding/bypass logic
│
├── tb/
│   ├── stages_tb/                  # Testbenches for individual pipeline stages/hazard/forwarding
│   └── tb_1/                       # Integrated testbench for full pipelined core
│
├── synth/
│   ├── synth_core_pip.ys           # Synthesis script (run from inside synth/)
│   ├── show_core_pip.ys            # Schematic (SVG) generation script
│   ├── core_pip_synth.v            # Synthesized netlist (generated)
│   ├── core_pip.svg                # Block-level schematic of the pipelined core (generated)
│   └── synth_core_pip.log          # Synthesis log (generated)
│
└── NOTE Shared Modules             # external modules reused from Single-Cycle design.

```
## Shared Modules

The pipelined processor reuses several fundamental RTL modules from the Single-Cycle design.
These include:

- ALU  
- ALU Control  
- Register File  
- Control Unit  
- Immediate Generator  
- Program Counter  
- Branch Unit  
- Instruction Memory  
- Multiplexers  
- Adders  

These modules are not duplicated inside the PipleineExecution directory.  
Instead, the pipelined `core_pip.v` and the stage files reference them from the **Single Cycle** project directory.

This avoids code duplication and ensures that both the single-cycle and pipelined implementations stay consistent and share the same foundational components.

## Future Work
- Implement branch detection and prediction module to resolve control hazards and reduce pipeline stalls
- Perform comprehensive RISC-V instruction set verification using standard test suites
- Integrate with a basic software toolchain to compile and execute simple C programs on the pipelined core

## Contribution
Suggestions for design improvements, verification strategies, or additional test programs are welcome.


## License
Open for educational and personal use under the [MIT License](../License.txt)
