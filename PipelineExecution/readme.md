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

pipeline_execute/
├── core/
│ └── core_pip.v # Top-level pipelined RV32I core
├── stages/ # Individual pipeline stage modules (IF, ID, EX, MEM, WB)
└── tb/
    ├── stages_tb/ # Testbenches for individual stage modules
    └── tb_1/ # First integrated testbench for the pipelined core

```
## Future Work
- Implement branch detection and prediction module to resolve control hazards and reduce pipeline stalls
- Perform comprehensive RISC-V instruction set verification using standard test suites
- Integrate with a basic software toolchain to compile and execute simple C programs on the pipelined core

## Contribution
Suggestions for design improvements, verification strategies, or additional test programs are welcome.
