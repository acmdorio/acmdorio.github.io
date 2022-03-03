---
title: "S4PU - Simple Forth Processing Unit"
excerpt: "A stack-based 16-bit CPU architecture written in VHDL"
last_modified_at: 2018-11-10
priority: 12
header:
  teaser: /assets/images/s4pu.png
tags:
  - EDA
---

Simple Forth Processing Unit (S4PU) is a 16-bit stack-based CPU that explores some of the ideas seen on [Koopman's "Stack Computers: the new wave"](https://users.ece.cmu.edu/~koopman/stack_computers/index.html).

![S4PU](/assets/images/s4pu.png)


Design
----

The machine runs on a subset of the [Forth programming language](https://en.wikipedia.org/wiki/Forth_(programming_language)) with 32 instructions, thus being considered a [Minimal Instruction Set Computer (MISC)](https://en.wikipedia.org/wiki/Minimal_instruction_set_computer) architecture.
It fits what Koopman calls the "ML0 design":
  - Multiple Stacks: one dedicated to operating data and another to store return addresses.
  - Large Stack Buffer: although "large" is debatable, here it means the stack resides in on-chip memory and does not consume main memory bandwidth.
  - 0-Operand: there are no operands associated with most instructions' opcode, the top of the data stack is implicitly used instead.

As is the case with most stack computers, S4PU's strength and weakness is its simplicity.
While performance levels will never reach those of pipelined superscalar processors, stack-based CPUs are generally simpler, cheaper and less power-hungry.
This makes them suitable for applications such as embedded systems control.
More importantly, designs such as this one are really simple and easy to understand -- even more so than didatic [MIPS](https://en.wikipedia.org/wiki/MIPS_architecture) implementations -- and have their place, I believe, in teaching Computer Organization and Design.


Implementation
----

The processor was implemented in VHDL using Altera (which is now a part of Intel) [Quartus II](https://en.wikipedia.org/wiki/Altera_Quartus) and synthesis was targeted at an EP2C35F672C6 chip from the Cyclone II family of FPGAs, so that it could be physically prototyped.
Testbench simulations were performed in ModelSim.

In order to program the CPU, a simple assembler program was developed in Python to translate S4PU's assembly language into Memory Initialization File (.mif) format which was later loaded into the FPGA's memory cells standing for the computer's program memory.

I've made the whole project, including documentation (pt-BR), available on [GitLab](https://gitlab.com/baioc/s4pu).
{: .notice--info}
