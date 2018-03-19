# Omar Alghamdi
# 201528950
.data
fMatrix:	.float	0:400
prompt1:	.asciiz	"Choose what you want to do\n"
prompt2:	.asciiz	"Enter the size of the matrix. size should be from 2 to 10\t"
prompt3:	.asciiz	"Enter matrix elements row by row\n"
choice1:	.asciiz	"1. Enter a Matrix of Single-Precision Floats\n"
choice2:	.asciiz	"2. Compute a Row Sum\n"
choice3:	.asciiz	"3. Compute a Column Sum\n"
choice4:	.asciiz	"4. Locate the Minimum Element in the Matrix\n"
choice5:	.asciiz	"5. Exit the Program\n"
errMSG1:	.asciiz	"invalid choice. please try again"
errMSG2:	.asciiz	"invalid matrix size. please try again"
.text
main:		jal choice
		beq $v0, 1, sizeFill
		beq $v0, 5, exit
sizeFill:	la $a0, fMatrix
		jal size
exit:		li $v0, 10
		syscall	

choice:	la $a0, prompt1	# prints the menu
	li $v0, 4
	syscall
	la $a0, choice1
	li $v0, 4
	syscall
	la $a0, choice2
	li $v0, 4
	syscall
	la $a0, choice3
	li $v0, 4
	syscall
	la $a0, choice4
	li $v0, 4
	syscall
	la $a0, choice5
	li $v0, 4
	syscall
read1:	li $v0, 5	# reads user choice
	syscall
	blt $v0, 1, err1
	bgt $v0, 5, err1
	jr $ra		# return user choice
err1:	la $a0, errMSG1	# prints error message
	li $v0, 4
	syscall
	j read1
	

size:	move $t0, $a0	# matrix address
	la $a0, prompt2
	li $v0, 4
	syscall
read2:	li $v0, 5
	syscall
	bge $v0, 2, input
	ble $v0, 10, input
	la $a0, errMSG2	# prints error message
	li $v0, 4
	syscall
	j read2
input:	move $t1, $v0	# matrix size	
	mul $t2, $v0, $v0
	sll $t2, $t2, 2
	addu $t2, $t2, $t0	# last address
	la $a0, prompt3
	li $v0, 4
	syscall
fill:	li $v0, 5	# reads element
	syscall
	sw $v0, ($t0)	# stores element
	addiu $t0, $t0, 4
	blt $t0, $t2, fill
	move $v0, $t1	# returns the size (N)
	jr $ra




