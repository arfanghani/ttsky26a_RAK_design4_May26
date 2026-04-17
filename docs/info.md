<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is a simple 8-bit CPU.

It runs a very small program stored inside the chip and repeats it over and over.

What the CPU does step by step:
It looks at a number in memory (this is the instruction).
It figures out what that number means (this is decoding).
It performs a simple action based on it.
It moves to the next instruction.
Program instructions

Each instruction is 8 bits (1 byte).

Only the top 4 bits are used to decide what happens:

0x1 → increase register R0 by 1
0x2 → increase register R1 by 1
0x3 → increase register R2 by 1
0x4 → increase register R3 by 1
0x0 → do nothing (NOP)
Memory
The CPU has a small built-in memory (32 bytes).
This memory stores the program.
A copy of this memory is also shown in simulation so you can see it in GTKWave.
Program flow

The CPU uses a “program counter” (PC):

It starts at 0
Goes 0 → 1 → 2 → 3 → 4
Then loops back to 0 again

So the program runs in a loop forever.
## How to test

run simulations
n the waveform:

PC counts up (0, 1, 2, 3, 4, repeat)
Instruction changes (10, 20, 30, 40, 00)
Registers change:
R0 increases when instruction is 0x10
R1 increases when instruction is 0x20
etc.
## External hardware
None is required for simulation.
List external hardware used in your project (e.g. PMOD, LED display, etc), if any
