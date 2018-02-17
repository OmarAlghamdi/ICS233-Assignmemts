.data 
prompt1:	.asciiz "Please enter the size of the matrix\n"
prompt2:	.asciiz "You cannot have matrix of size less than 2, please try again\n"
prompt3:	.asciiz "Please Enter matrix content. Enter the the integers row by row\n"
prompt4:	.asciiz "This is the menu options. Enter integer correspond to your choice\n"

errMessage1:	.asciiz "ERROR: Invalid menu option"
errMessage2:	.asciiz "ERROR: You entered invalid row/column number\n"

option1:	.asciiz "1: Display a specific row\n"
prompt4_1:	.asciiz "Enter the row number. Frist row is 0\n"
option2:	.asciiz "2: Display a specific column\n"
prompt4_2:	.asciiz "Enter column number. Frist column is 0\n"
option3:	.asciiz "3: Display the main diagonal\n"
option4:	.asciiz "4: Exit the program\n"

.text
		la $a0, prompt1		# program start
		li $v0, 4
		syscall
readSize:	li $v0, 5		# read size
		syscall
		move $s0, $v0
		bge $s0, 2 allocation	# allocate memory if matrix size >= 2
		la $a0, prompt2		# prompt for correct matrix size
		li $v0, 4
		syscall
		j readSize
allocation:	mul $a0, $s0, $s0	# calculate memory size
		sll $a0, $a0, 2
		move $t0, $a0
		li $v0, 9		# allocate memory
		syscall
		move $s1, $v0		# store memory address
		move $s2, $s1
		add $t0, $t0, $s1	# calculate last word index
		la $a0, prompt3		# prompt for data entry
		li $v0, 4
		syscall
fillMatrix:	li $v0, 5		# read user date
		syscall
		sw $v0, ($s2)		# store user date
		add $s2, $s2, 4		# calculate next address
		blt $s2, $t0, fillMatrix# branch if there is more space to fill
menu:		la $a0, prompt4		# print menu
		li $v0, 4
		syscall	
		la $a0, option1
		li $v0, 4
		syscall	
		la $a0, option2
		li $v0, 4
		syscall	
		la $a0, option3
		li $v0, 4
		syscall	
		la $a0, option4
		li $v0, 4
		syscall
readChoice:	li $v0, 5		# reads user choice
		syscall
		ble $v0, 1, menu	# reprint the menu if the choice is invalid
		bgt $v0, 4, menu
		
		beq $v0, 4, exit	# choice 4: exit
		
exit:		li $v0, 10		# terminate
		syscall