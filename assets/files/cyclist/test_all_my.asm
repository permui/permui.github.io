Begin:
    # Reg[1-5]: Used to record data
    addi	x1,     x0,     123 		# x1 = 123  Data
    addi	x2,     x1,     111 		# x2 = 234  Data
    addi	x3,     x2,     111 		# x3 = 345  Data
    addi	x4,     x3,     111 		# x4 = 456  Data
    addi	x5,     x4,     111 		# x5 = 567  Data
    # Reg[6-10]: Used to store test address
    addi	x6,     x0,     0x0 		
    addi	x7,     x0,     0x4 		
    addi	x8,     x0,     0x94 		
    addi	x9,     x0,     0x98
    addi	x10,    x0,     0x404
    # Reg[20]: Used to record score
    addi	x20,    x0,     0			# X20 = 0   
Test_1:
    sw		x1,     0(x6)		        # &(0x0) = 123
    sw		x2,     0(x7)		        # &(0x4) = 234
    lw		x11,    0(x6)		        # x11 = 123
    sw		x3,     0(x8)		        # &(0x94) = 345
    sw		x4,     0(x9)		        # &(0x98) = 567
    lw		x13,    0(x8)		        # x13 = 345
    lw		x12,    0(x7)		        # x12 = 234
    lw		x14,    0(x9)		        # x14 = 456
    addi    x11,    x11,    -345        # x11 = x11 - 345 = -222
    addi    x12,    x12,    -456        # x12 = x12 - 456 = -222
    bne		x11,    x12,    Test_2      # if Not Equal: Skip x20++
    addi	x20,    x20,    1			# x20++
Test_2:
    sw		x5,     0(x10)		        # &(0404) = 567
    lw      x11,    0(x7)               # x11 = &(0x4) = 234
    lw      x12,    0(x10)              # x12 = &(0x404) = 567
    addi    x11,    x11,    333         # x11 = x11 + 333 = 567     
    bne		x11,    x12,    Test_3      # if Not Equal: Skip x20++
    addi	x20,    x20,    1			# x20++
Test_3:
    lw      x11,    0(x6)               # x11 = &(0x0) = 123
    lw      x12,    0(x10)              # x12 = &(0x404) = 567
    addi	x11,    x11,    444		    # x11 = x11 + 444 = 567
    bne		x11,    x12,    Loop        # if Not Equal: Skip x20++
    addi	x20,    x20,    1			# x20++

Test_4:
    lui     x15,    0xFFF               # x15 = 0x00FFF000
    lui     x16,    0xFFE               # x16 = 0x00FFE000
    addi	x20,    x20,    1			# x20++
    jal     x17,    Test_5
    addi    x20,    x20,    -1          # Skip

Test_5:
    lui     x18,    0x1                 # x18 = 0x00001000
    add     x16,    x16,    x18         # x16 = 0x00FFF000
    addi	x20,    x20,    1			# x20++
    beq     x16,    x15,    Test_6      # if Equal, Skip x20--
    addi    x20,    x20,    -1          # x20--

Test_6:
    lui     x18,    0xFFFFF             # x18 = 0xFFFFF000
    slti    x15,    x18,    -1          # x15 = 1 (x18 < -1)
    lui     x17,    0x7FFFF             # x17 = 0x7FFFF000
    slt     x16,    x17,    x18         # x16 = 0 (x17 > x18)
    bne     x16,    x0,     Loop        # if Not Equal, Skip x20++
    addi    x20,    x20,    1           # x20++

Test_7:
    beq     x15,    x16,    Loop        # if Equal, Skip x20++
    addi    x20,    x20,    1           # x20++

Loop:
    #------------Useless Loop-----------------
    addi	x21,    x0,     7			
    bne		x21,    x20,    Loop	
    #------------Useless Loop-----------------

    #------------Start YAY Part---------------

Test_auipc:
    jal     x3,     Test_auipc_here     # now x3 is the 
Test_auipc_here:
    auipc   x4,     0x37a4e             # PC must be ??? here
    lui     x5,     0x37a4e
    add     x5,     x5,     x3          # should x5 == x4
    bne     x5,     x4,     YAY_Loop

Test_jalr:
    auipc   x4,     0
    jalr    x5,     x4,     12          # it should jump over the next instruction
    beq     x0,     x0,     YAY_Loop    # must goto YAY_Loop
    addi    x4,     x4,     8
    bne     x4,     x5,     YAY_Loop

Test_Bs:
    li      x1,     0xfead1234
    li      x2,     0x01234567
    blt     x2,     x1,     YAY_Loop
    bge     x1,     x2,     YAY_Loop
    bltu    x1,     x2,     YAY_Loop
    bgeu    x2,     x1,     YAY_Loop

Test_sltiu:
    addi    x1,     x0,     123
    sltiu   x2,     x1,     -1          # unsigned compare, x2 should be 1
    addi    x3,     x0,     1
    bne     x2,     x3,     YAY_Loop

Test_bit_arithmetic_i:
    addi    x1,     x0,     0x5fa     
    xori    x2,     x1,     0x4b7     # xor
    addi    x3,     x0,     0x14d
    bne     x2,     x3,     YAY_Loop

    ori     x2,     x1,     0x467     # or
    addi    x3,     x0,     0x5ff
    bne     x2,     x3,     YAY_Loop

    andi    x2,     x1,     0x53a     # and
    addi    x3,     x0,     0x53a
    bne     x2,     x3,     YAY_Loop

Test_shift_i:
    addi    x1,     x0,     0x234
    slli    x2,     x1,     4           # slli
    li      x3,     0x2340
    bne     x2,     x3,     YAY_Loop

    li      x1,     0xeabc6472
    srli    x2,     x1,     7           # srli
    li      x3,     0x1d578c8
    bne     x2,     x3,     YAY_Loop

    srai    x2,     x1,     7           # srai
    li      x3,     0xffd578c8
    bne     x2,     x3,     YAY_Loop

Test_arithmetic_R:
    addi    x1,     x0,     0x234
    addi    x5,     x0,     4
    sll     x2,     x1,     x5           # sll
    li      x3,     0x2340
    bne     x2,     x3,     YAY_Loop

    li      x1,     0xeabc6472
    addi    x5,     x0,     7

    srl     x2,     x1,     x5           # srl
    li      x3,     0x1d578c8
    bne     x2,     x3,     YAY_Loop

    sra     x2,     x1,     x5           # sra
    li      x3,     0xffd578c8
    bne     x2,     x3,     YAY_Loop 

    addi    x1,     x0,     123
    addi    x5,     x0,     -1
    sltu    x2,     x1,     x5          # sltu
    addi    x3,     x0,     1
    bne     x2,     x3,     YAY_Loop

    li      x1,     0x6c95a834
    li      x2,     0x84eb772d

    add     x3,     x1,     x2          # add
    li      x4,     0xf1811f61
    bne     x3,     x4,     YAY_Loop

    sub     x3,     x1,     x2          # sub
    li      x4,     0xe7aa3107
    bne     x3,     x4,     YAY_Loop

    xor     x3,     x1,     x2          # xor
    li      x4,     0xe87edf19
    bne     x3,     x4,     YAY_Loop

    or      x3,     x1,     x2          # xor
    li      x4,     0xecffff3d
    bne     x3,     x4,     YAY_Loop

    and     x3,     x1,     x2          # xor
    li      x4,     0x4812024
    bne     x3,     x4,     YAY_Loop

To_Success:
    j       Success

YAY_Loop:
    jal     x1,     YAY_Loop

Success:
    nop

