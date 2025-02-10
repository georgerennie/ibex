.section .text

csrw_flush:
	nop
	# Read minstret thrice with mstatus write that causes flush inbetween
	csrr s0, minstret
	csrsi mstatus, 1
	csrr s1, minstret
	csrr s2, minstret
	ret

jump_flush:
	nop
	# Read minstret thrice with jump that causes flush inbetween
	csrr s0, minstret
	j jump_flush_continue
jump_flush_continue:
	csrr s1, minstret
	csrr s2, minstret
	ret

print_vars:
	addi sp, sp, -16
	sw ra, 12(sp)

	mv a0, s0; call puthex; li a0, '\n'; call putchar
	mv a0, s1; call puthex; li a0, '\n'; call putchar
	mv a0, s2; call puthex; li a0, '\n'; call putchar
	li a0, '\n'; call putchar

	lw ra,12(sp)
	addi sp, sp, 16
	ret

.global main
main:
	addi sp, sp, -16
	sw ra, 12(sp)

	call csrw_flush
	call print_vars

	call csrw_flush
	call print_vars

	lw ra,12(sp)
	addi sp, sp, 16
	li a0, 0
	ret
