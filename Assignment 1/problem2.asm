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
		blt $v0, 1, menu	# reprint the menu if the choice is invalid
		bgt $v0, 4, menu
		beq $v0, 1, rowDis	# choice 1: display row
		beq $v0, 2, colDis	# choice 2: display column
		beq $v0, 3, diaDis	# choice 3: display the main diagonal
		beq $v0, 4, exit	# choice 4: exit
rowDis:		la $a0, prompt4_1	# prompt for row number
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		bltz $v0, err2		# branch if out of range
		bge $v0, $s0, err2
		mul $t0, $v0, $s0	# calculate row address	
		sll $t0, $t0, 2	
		add $t0, $t0, $s1
		move $t1, $zero
printRow:	lw $a0, ($t0)		# print row
		li $v0, 1
		syscall
		li $a0, 9		# print tap
		li $v0, 11
		syscall
		addi $t1, $t1, 1
		addi $t0, $t0, 4
		blt $t1, $s0, printRow
		li $a0, 10		# print new line
		li $v0, 11
		syscall
		j menu
colDis:		la $a0, prompt4_2	# prompt for column number
		li $v0, 4
		syscall
		li $v0, 5
		syscall	
		bltz $v0, err2		# branch if out of range
		bge $v0, $s0, err2
		move $t0, $v0	# calculate column address
		sll $t0, $t0, 2
		add $t0, $t0, $s1
		move $t1, $zero
		mul $t2, $s0, 4		# increment amount
printCol:	lw $a0, ($t0)		# print column
		li $v0, 1
		syscall
		li $a0, 9		# print tap
		li $v0, 11
		syscall
		addi $t1, $t1, 1
		add $t0, $t0, $t2
		blt $t1, $s0, printCol
		li $a0, 10		# print new line
		li $v0, 11
		syscall
		j menu
diaDis:		addi $t2, $s0, 1	# calculate increment
		sll $t2, $t2, 2
		move $t0, $s1
		move $t1, $zero
printDia:	lw $a0, ($t0)
		li $v0, 1
		syscall
		li $a0, 9		# print tap
		li $v0, 11
		syscall
		addi $t1, $t1, 1
		add $t0, $t0, $t2
		blt $t1, $s0, printDia
		li $a0, 10		# print new line
		li $v0, 11
		syscall
		j menu	
err2:		la $a0, errMessage2	# invalid row
		li $v0, 4
		syscall
		j menu
		syscall
exit:		li $v0, 10		# terminate
		syscall
