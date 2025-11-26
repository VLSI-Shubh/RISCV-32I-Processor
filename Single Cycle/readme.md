# Single Cycle Execution Project

## Overview
This project implements a single-cycle CPU architecture where each instruction executes in one clock cycle. It covers basic instruction types including data processing, load/store, and branch instructions.

## Features
- Instruction fetch, decode, execute done in a single cycle
- Support for arithmetic, memory, and control instructions
- Simple design suitable for educational purposes and CPU concept demonstration

## Project Structure
- `src/` - Source code for CPU implementation
- `tests/` - Test cases for various instructions
- `docs/` - Documentation related to single cycle execution design (Not there yet, will add all the document I referred in order to do the project)

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
Specify project license if any.

