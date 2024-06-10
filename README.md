# Image application with piXo

## Overview
    
this project is a picosoc based application designed to use picorv32 core and exploring it on an FPGA for image processing tasks, basically approximate multiplication and output the results on a monitor. It is inspired from these projects : [picosoc-w-approximation](https://github.com/LukeVassallo/picosoc-w-approximation) and [AxE](https://github.com/pouriahassani/AxE)

## Risc-v

RISC-V is an open standard instruction set architecture (ISA) based on established reduced instruction set computing (RISC) principles.
PicoRV32 is a CPU core that implements the RISC-V RV32IMC Instruction Set. 

This means that all the configurations are 32-bit implementations that have 32 or 16 registers. Also the required base instruction set is present, and there are options to also enable the multiplication and division instructions; and (as the name suggests) there is an option for having compact instructions.


## SoC architecture
Below is the block diagram of the system to develop, all the i/o are not showed, they are detailed in the Wiki's documentation.

![systemm drawio](https://github.com/omarchadib/picosoc_image_application/assets/171576890/cef4b044-2833-4f15-8825-e9e5b0c70e46)
<sup> Fig1. block diagram of the system on chip (SoC) alongside with the display controller

## approximate computing

Approximate computing involves sacrificing computational accuracy for gains in speed, power, and area efficiency. Approximate circuits, by utilizing fewer components, may occasionally produce inaccurate outputs, resulting in simpler implementation. This technology finds application in scenarios where a certain degree of error in the output is acceptable, such as video signals intended for human consumption. The PCPI interface is used to extend picorv32 into approximate piXo core.

## Files order
[pico_single core](https://github.com/omarchadib/picosoc_image_application/tree/main/pico_singlecore/src) : it contains picorv32.v with a memory module that simulates RAM behaviour, also a testbench to test cpu's native memory interface with a simple firmware

[picosoc](https://github.com/omarchadib/picosoc_image_application/tree/main/picosoc) : simulates the system on chip (cpu,memory,uart) 

[tools](https://github.com/omarchadib/picosoc_image_application/tree/main/tools) : some tools for compilation
