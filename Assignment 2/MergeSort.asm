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
	move $a0, $s1
	move $a1, $s0
	jal merge_sort
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
merge:		sll $t0, $a1, 2		# allocate B[] on the stack
		move $fp, $sp		# B[n-1]
		sub $sp,$sp, $t0	# B[0]
		srl $t0, $a1, 1		# t0 = m = n/2
		move $t1, $zero		# t1 = i = 0
		move $t2, $t0		# t2 = j = m 
		move $t3, $zero		# t3 = k = 0
	while1:	bge $t1, $t0, while2	# i !< m
		bge $t2, $a1, while2	# j !< n
		sll $t4, $t1, 2		# A[i]
		add $t4, $a0, $t4	
		lw $t4, ($t4)
		sll $t5, $t2, 2		# A[j}
		add $t5, $a0, $t5 	
		lw $t5, ($t5)
		sll $t6, $t3, 2		# B[k]
		add $t6, $t6, $sp
	if:	bgt $t4, $t5, else1
		sw $t4, ($t6)		# B[k] = A[i]
		addi $t1, $t1, 1	# i++
		addi $t3, $t3, 1	# k++
		j while1
	else1:	sw $t5, ($t6)		# B[k] = A[j]
		addi $t2, $t2, 1	# j++
		addi $t3, $t3, 1	# k++
		j while1
	while2:	bge $t1, $t0, for	# i !< m
		sll $t4, $t1, 2		# A[i]
		add $t4, $a0, $t4	
		lw $t4, ($t4)
		sll $t6, $t3, 2		# B[k]
		add $t6, $t6, $sp
		sw $t4, ($t6)
		addi $t1, $t1, 1	# i++
		addi $t3, $t3, 1	# k++
		j while2
	for:	move $t1, $zero		# i = 0
	loop3:	sll $t4, $t1, 2		# A[i]
		add $t4, $a0, $t4	
		sll $t6, $t1, 2		# B[i]
		add $t6, $sp, $t6	
		lw $t6, ($t6)
		sw $t6, ($t4)		# A[i] = B[i]
		addi $t1, $t1, 1	# i++
		blt $t1, $t3, loop3	# i < k
		move $sp, $fp		# deallocate 
		jr $ra	
merge_sort:	bgt $a1, 1, else2	
		jr $ra			# base case
	else2:	addi $sp, $sp, -16	# allocate stack
		sw $a0, 8($sp)		# store A[0]
		sw $a1, 4($sp)		# store n
		sw $ra, ($sp)		# store the return address
		srl $s5, $a1, 1		# s5 = m =n/2
		sw $s5, 12($sp)		#store m
		lw $a0, 8($sp)
		lw $a1, 12($sp)
		jal merge_sort
		lw $s5, 12($sp)
		lw $a1, 4($sp)
		sub $a1, $a1, $s5
		sll $s5, $s5, 2
		lw $a0, 8($sp)
		add $a0, $a0, $s5
		jal merge_sort
		lw $a0, 8($sp)
		lw $a1, 4($sp)
		jal merge
		addi $sp, $sp, 16
		jr $ra
		