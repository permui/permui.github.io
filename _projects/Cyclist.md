---
layout: distill
title: Cyclist
description: A RISC-V Single Cycle Processor in Verilog
img: /assets/files/cyclist/cyclist_on_Nexys_A7.jpg
importance: 3
category: course project
show_author: false
permalink: /projects/cyclist
show: true
---

This is the course project of **Computer Systems I**, the first course in a trilogy on computer systems. The first part deals with digital logic and computer organization, while the second and third will include operating system and computer architecture respectively.

Since a single cycle processor executes one instruction in each cycle, just like riding a bicycle, I named it _Cyclist_. It implements the instructions colored green in the following picture from RV32I Base Instruction Set, RISC-V ISA:

<img src="{{ site.baseurl }}/assets/files/cyclist/cyclist_support_instructions.jpg" alt="cyclist_support_instructions" style="width:100%" class="center" />

The following is a brief summary of the design and test process, which may be helpful to you if you are working on a similar project. This processor will be improved to a pipelined processor with more instructions supported in the following semester, but that will appear in another project page when completed.

## Design

I examined the instruction table along with the [RISC-V specification](https://riscv.org/technical/specifications/) and divided the instructions into 10 types, summarized in the following table:

| Type      | Instructions                                                |
| --------- | ----------------------------------------------------------- |
| U(lui)    | `LUI`                                                       |
| U(auipc)  | `AUIPC`                                                     |
| J         | `JAL`                                                       |
| I(jalr)   | `JALR`                                                      |
| B         | `BEQ`,`BNE`,`BLT`,`BGE`,`BLTU`,`BGEU`                       |
| I(load)   | `LW`                                                        |
| S         | `SW`                                                        |
| I(a/l)    | `ADDI`,`SLTI`,`SLTIU`,`XORI`,`ORI`,`ANDI`                   |
| I(a/l)spe | `SLLI`,`SRLI`,`SRAI`                                        |
| R         | `ADD`,`SUB`,`SLL`,`SLT`,`SLTU`,`XOR`,`SRL`,`SRA`,`OR`,`AND` |

Careful examination of each type of instructions yields the following **datapath** and **control signal** design.

<img src="{{ site.baseurl }}/assets/files/cyclist/cyclist_datapath.svg" alt="datapath diagram" style="width: 100%">

<div class="caption">
    The datapath diagram of Cyclist, drawn with <a href="https://github.com/jgraph/drawio" target="_blank">draw.io</a>
</div>

| Inst Type | ImmType | ALUop  | ALUSrc | WriteBackSrc | PCSrc    | RegWrite | MemWrite |
| --------- | ------- | ------ | ------ | ------------ | -------- | -------- | -------- |
| R         | R       | R      | rs2    | ALU          | PC4      | Enable   | Disable  |
| I(load)   | Iord    | IloadS | imm    | DataMem      | PC4      | Enable   | Disable  |
| I(a/l)ord | Iord    | Ial    | imm    | ALU          | PC4      | Enable   | Disable  |
| I(a/l)spe | Ispe    | Ial    | imm    | ALU          | PC4      | Enable   | Disable  |
| S         | S       | IloadS | imm    | -            | PC4      | Disable  | Enable   |
| B         | B       | B      | rs2    | -            | BSuccess | Disable  | Disable  |
| J         | J       | J      | -      | PC4          | PCimm    | Enable   | Disable  |
| U(lui)    | U       | U      | -      | imm          | PC4      | Enable   | Disable  |
| U(auipc)  | U       | U      | -      | PCimm        | PC4      | Enable   | Disable  |
| I(jalr)   | Iord    | Ijalr  | imm    | PC4          | ALU      | Enable   | Disable  |

<div class="caption">
    The control signal table of Cyclist. Notice that the first column denotes the instruction types mentioned above.
</div>

Encode these into Verilog, we have got a processor! Simple, right?

## Test

I made this [testing asm]({{ site.baseurl }}/assets/files/cyclist/test_all_my.asm) and converted it to [a coe file]({{ site.baseurl }}/assets/files/cyclist/test_all_my.coe) using a [Python script]({{ site.baseurl }}/assets/files/cyclist/asm_to_coe.py). The coe file initializes the instruction memory, from which machine instructions will be fechted. The assembly is designed in such a way that if something goes wrong, the processor will get stuck in an infinite loop.

After fixing some bugs, it run through the end in simulation and works just well on board. Test success!

## Run some C Code

The moment I finished the test, I realized that I can actually run C code on my just designed processor. The process is simple. 

1. Write a main function, do some operations and give the result as the return value.
2. Use `riscv32-unknown-elf-gcc` to compile it into relocatable file (`.o` file). 
3. Use `readelf` to extract the encoded `main` function.
4. format it into a `coe` file, push it to Vivado and download it to the board.

Here is an example that add from 0 to 99. The code is 

<d-code block language="javascript">

int main() {
    int sum = 0;
    for (int i = 0; i < 100; ++i) {
        sum += i;
    }
    return sum;
}

</d-code>

and the result is `4950` = `0x1356`, as the board output says:

<img src="{{ site.baseurl }}/assets/files/cyclist/the_sum100_down.jpg" alt="board_output_right" style="width:80%" class="center" />
