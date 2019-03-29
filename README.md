# MIPS Single Cycle Processor

We will be looking at an implementation of the MIPS processor, which in-
cludes the following functionalities:

- Memory-reference instructions (lw and sw)
- Arithmetic logic instructions (add, sub, and, or and slt)
- Control 
ow instructions (beq and j)

We will be working with 8-bit datapaths and 32-bit instruction widths.  We will be
implementing a register file of eight 8-bit registers. Instruction memory will
remain at 32-bits, and will contain a maximum of 256 instructions. The data
memory, however, will be 8-bits, and will contain a maximum of 256 words.
