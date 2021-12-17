li t0, 0xffff
li s0, 0x20000000
sw t0, 0(s0)
lw t1, 0(s0)
add t1, t1, t0
jal x0, 0