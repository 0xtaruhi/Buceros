addi t2, x0, 100
LOOP:
add t3, t3, t1
addi t1, t1, 1
bne t1, t2, LOOP
jal ra, 0