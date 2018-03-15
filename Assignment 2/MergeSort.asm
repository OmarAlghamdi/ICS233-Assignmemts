# Omar Alghamdi
# 201528950
.data
prompt1:	.asciiz	"Enter the lenght of your array\n"
prompt2:	.asciiz	"Enter the elements of your array, one element by row\n"
msg1:		.asciiz	"The unsorted array is:\n"
msg2:		.ascii	"The sorted array is:\n"
.text
	la $a0, prompt1	# prompts for array size
	li $v0, 4
	syscall
	li $v0, 5	# reads array size
	syscall
	move $s0, $v0	# store array size
	move $a0, $s0
	sll $a0, $a0, 2	# allocate memory
	li $v0, 9
	syscall
	move $s1, $v0	# store array location
	sll $s2, $s0, 2	# store the last index
	add $s2, $s2, $s1
	jal read_array
	jal print_array
exit:	li $v0, 10
	syscall		
read_array:	la $a0, prompt2		# prompts for array content
		li $v0, 4
		syscall
		move $t0, $s1
	loop1:	li $v0, 5		# reads element 
		syscall
		sw $v0, ($t0)
		addi $t0, $t0, 4
		blt $t0, $s2, loop1	# read another element if has not reached the last index
		jr $ra
print_array:	la $a0, msg1
		li $v0, 4
		syscall
		move $t0, $s1
	loop2:	lw $a0, ($t0)		# prints an element
		li $v0, 1
		syscall
		li $a0, 44		# prints comma
		li $v0, 11
		syscall
		addi $t0, $t0, 4
		blt $t0, $s2, loop2
		jr $ra
merge:
merge_sort:

