# Pipelined Execution Project

## Project Status
The project has moved beyond the planning phase. The modules for the fetch, decode, execute, memory, and write back stages have been written and are under active refinement. Work is currently in progress for the hazard detection unit and the forwarding unit. These components are essential for resolving data hazards and ensuring proper instruction flow through the pipeline.

## Project Goal
To design and implement a five stage pipelined CPU architecture capable of executing the RV32I instruction set.

## Implemented Components
- Instruction fetch stage
- Instruction decode stage
- Execute stage
- Memory access stage
- Write back stage
- Pipeline registers between stages

## Work in Progress
- Hazard detection unit
- Forwarding unit

## Planned Features
- Complete hazard detection and data forwarding logic
- Static branch prediction for smoother pipeline flow
- Full datapath and control signal validation across all pipeline stages

## Next Steps
- Finish the hazard detection and forwarding units
- Integrate branch decision logic and update the control unit
- Perform module level and system level verification using sample RISC V programs
- Analyze performance, stalls, and forwarding behavior using waveform based debugging

## Contribution
Suggestions for design improvements or verification strategies are welcome.
