addi	sp,sp,-32
sw	s0,28(sp)
addi	s0,sp,32
# li	a5,536870912
li  a5, 0
sw	a5,-20(s0)
li	a5,123
sw	a5,-24(s0)
lw	a5,-20(s0)
addi	a4,a5,4
sw	a4,-20(s0)
lw	a3,-24(s0)
li	a4,10
div	a4,a3,a4
sw	a4,0(a5)
li	a5,0
mv	a0,a5
lw	s0,28(sp)
addi	sp,sp,32
jr	ra