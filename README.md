# RISCV-32I-Processor

This branch focuses on the ongoing development of the single cycle execution. All the latest, stable files can be found in the main branch; this branch is dedicated specifically to single cycle execution.

**Important:**  
Please do **not** fork or clone this branch, as it is under continuous development and the modules may not perform as expected.

The current version of this setup is functional and capable of executing both individual instructions and simple, straightforward tasks.

Development is ongoing to enhance the processor's versatility to handle more complex tasks.

## Directory Structure (for this branch)

```
├── SingleCycle/
│ ├── src/
  └── testbench/
        └── tb1
        └── tb2


The testbench section is actively evolving, as it is used for current testing purposes.

- **tb1**: The first test bench, which executes random basic instructions of each type and provides all the required expected outputs.
- **tb2**: Intended to perform a simple factorial calculation. Since there is no MUL block yet, multiplication will be implemented using Euclidean algorithm-style repeated addition.
- Additional test benches are planned to cover more complex tasks as development progresses.
