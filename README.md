# RISC_V-Core
This Project implements a 5 stage pipelining RISCV processor using a single ported byte addressable memory for both data and instructions.
RISC-VIM Core


A 32-bit RISC-V core written in Verilog and an instruction set simulator supporting RV32IM.
This core has been tested against a co-simulation model and exercised on FPGA.



Features: 


	- 32-bit RISC-V ISA CPU core.
	- Support RISC-V integer (I), multiplication and division (M), extensions (RV32IM).
	- Implements base ISA spec v2.1 
	- Support for instruction/ data unified Memory.
	- configured with 5 pipeline stages and result forwarding options.
	- support load-use hazard detection and correction
	- support control hzarads detection and correction with static branch predictor


Assumptions: 

	- Supports Big-endian memory organization
	- 1 Unified memory for instructions and Data
	- Pipeline Implementation
	- supports memory of 4 kB
	- branch outcome decided in Memory stage


What Works: All RISC-VI 40 instructions and Integer Multiplication and division instructions (8 Instructions)
