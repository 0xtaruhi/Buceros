li t0, 0x40000000
# li t0, 0x00000000
li t1, 0
li t2, 1000000
# li t2, 2
li t3, 1
li t4, 0x00010000
1:
addi t1, t1, 1
bne t1, t2, 1b
li t1, 0
slli t3, t3, 1
beq t3, t4, 2f
3:
sw t3, 0(t0)
j  1b
2:
li t3, 1
j  3b