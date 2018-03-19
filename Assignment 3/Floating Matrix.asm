# Omar Alghamdi
# 201528950
.data
fMatrix:	.float	0:100
prompt:		.asciiz	"Choose what you want to do\m"
choice1:	.asciiz	"1. Enter a Matrix of Single-Precision Floats\n"
choice2:	.asciiz	"2. Compute a Row Sum\n"
choice3:	.asciiz	"3. Compute a Column Sum\n"
choice4:	.asciiz	"4. Locate the Minimum Element in the Matrix\n"
choice5:	.asciiz	"5. Exit the Program\n"
err:		.asciiz	"invalid choice. please try again"
.text
main:	jal choice
	beq $v0, 5, exit
	
exit:	li $v0, 10
	syscall	

choice:	la $a0, prompt	# prints the menu
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
read:	li $v0, 5	# reads user choice
	syscall
	bge $v0, 1, return
	ble $v0, 5, return
	la $a0, err	# prints error message
	li $v0, 4
	syscall
	j read
return:	jr $ra		# return user choice