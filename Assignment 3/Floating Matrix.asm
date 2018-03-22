# Omar Alghamdi
# 201528950

.data
fMatrix:	.float	0:400	# allocate 400 bytes (100 words) statically and initalize them to 0
prompt1:	.asciiz	"Choose what you want to do\n"
choice1:	.asciiz	"1. Enter a Matrix of Single-Precision Floats\n"
prompt2:	.asciiz	"Enter the size of the matrix. size should be from 2 to 10\t"
prompt3:	.asciiz	"Enter matrix elements row by row\n"
choice2:	.asciiz	"2. Compute a Row Sum\n"
prompt4:	.asciiz	"Enter row number from 0 to N-1\n"
result1:	.asciiz	"the sum of the row = "
choice3:	.asciiz	"3. Compute a Column Sum\n"
prompt5:	.asciiz	"Enter column number from 0 to N-1\n"
result2:	.asciiz	"the sum of column = "
choice4:	.asciiz	"4. Locate the Minimum Element in the Matrix\n"
result3_1:	.asciiz	"the minimum = "
result3_2:	.asciiz	"\nit is in row: "
result3_3:	.asciiz	"\nand in column: "
choice5:	.asciiz	"5. Exit the Program\n"
errMSG1:	.asciiz	"invalid choice. please try again\n"
errMSG2:	.asciiz	"invalid matrix size. please try again\n"
errMSG3:	.asciiz	"invalid row number, please try again\n"
errMSG4:	.asciiz	"invalid column number, please try again\n"
.text
main:		jal choice		# calls function "choice" that prints the menu and asks user for input
		beq $v0, 1, sizeFill	# user chose to enter matrix size and its content
		beq $v0, 2, row		# user chose to view the sum of a row
		beq $v0, 3, column	# user chose to view the sum of a column
		beq $v0, 4, min		# user chose to view the least element in the matrix
		beq $v0, 5, exit	# user chose to exit the program
sizeFill:	la $a0, fMatrix		# loads the address of staticly allocated matrix
		jal size_content	# calls function "size_content" which reads the size of matrix and and its content and returns the size of matrix
		move $s0, $v0		# stores matrix size (N)
		j main			# returns to the menu
row:		la $a0, fMatrix		# loads the addressz of matrix
		move $a1, $s0		# passes the size of matrix
		jal rowSum		# calls function "rowSum" which asks user for a row number and prints the sum of its elements
		j main			# returns to the menu
column:		la $a0, fMatrix		# loads the addressz of matrix
		move $a1, $s0		# passes the size of matrix
		jal columnSum		# calls function "columnSum" which asks user for a column number and prints the sum of its elements
		j main			# returns to the menu
min:		la $a0, fMatrix		# loads the addressz of matrix
		move $a1, $s0		# passes the size of matrix
		jal minimum		# calls function "minimum" which prints the least element in the matrix
		j main			# returns to the menu
exit:		li $v0, 10		# exits the program
		syscall	

choice:		la $a0, prompt1		# prints the menu
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
	read1:	li $v0, 5		# reads user choice
		syscall
		blt $v0, 1, err1	# prints error message if user choice is either < 1
		bgt $v0, 5, err1	# or > 5
		jr $ra			# return user choice
	err1:	la $a0, errMSG1		# prints error message
		li $v0, 4
		syscall
		j read1			# reads another user choice
	

size_content:	move $t0, $a0		# matrix address
		la $a0, prompt2		# prompts for matrix size
		li $v0, 4
		syscall
	read2:	li $v0, 5		# reads matrix size
		syscall
		blt $v0, 2, err2	# prints error message if user choice either < 2
		bgt $v0, 10, err2	# or > 10
		move $t1, $v0		# matrix size (N)
		mul $t2, $v0, $v0	# calculates the address of the last element in matrix with size N
		sll $t2, $t2, 2
		addu $t2, $t2, $t0	# t2 = last address
		la $a0, prompt3		# prompts the user to enter matrix elements row by row
		li $v0, 4
		syscall
	fill:	li $v0, 6		# reads an element
		syscall
		swc1 $f0, ($t0)		# stores the element
		addiu $t0, $t0, 4
		blt $t0, $t2, fill	# reads another element while the last element is not entered
		move $v0, $t1		# returns the size (N)
		jr $ra			# returns to main function
	err2:	la $a0, errMSG2		# prints error message if the size of the matrix is not between 2 and 10
		li $v0, 4
		syscall
		j read2			# reads another size
rowSum:		move $t0, $a0		# stores matrix address
		la $a0, prompt4		# prompts for row number
		li $v0, 4
		syscall
	read3:	li $v0, 5		# reads user input
		syscall
		blt $v0, 0, err3	# prints error message it the index of the row is either < 0
		bgt $v0, $a1, err3	# or > N-1
		mul $t1, $a1, $v0	# calculates row address
		sll $t1, $t1, 2		
		addu $t1, $t1, $t0	# t1 = frist address in row
		sll $t2, $a1, 2		# calculates the last address or row
		addiu $t2, $t2, -4
		addu $t2, $t2, $t1	# t2 = last address in row
		lwc1 $f12, ($t1)	# moves the first element of the row to register f12
	loop1:	addiu $t1, $t1, 4	# goes to the next element in the row
		lwc1 $f0, ($t1)		# moves the next element to register f0
		add.s $f12, $f12, $f0	# adds the next element to the the value of register f12 and stores the result in f12
		blt $t1, $t2, loop1	# loops if last element in the row has not been added
		la $a0, result1		# prints the result of summation
		li $v0, 4
		syscall
		li $v0, 2
		syscall
		li $a0, 10
		li $v0, 11
		syscall
		jr $ra
	err3:	la $a0, errMSG3		# prints error message if the row index is out of range
		li $v0, 4
		syscall
		j read3			# reads another row index
columnSum:	move $t0, $a0		# stores matrix address
		la $a0, prompt5		# prompts for column number
		li $v0, 4
		syscall
	read4:	li $v0, 5		# reads user input
		syscall
		blt $v0, 0, err4
		bgt $v0, $a1, err4
		sll $t1, $v0, 2
		addu $t1, $t1, $t0	# frist address in column
		addiu $t2, $a1, -1
		mul $t2, $t2, $a1
		sll $t2, $t2, 2	
		addu $t2, $t2, $t1	# last address in column
		sll $t3, $a1, 2		# increment amount
		lwc1 $f12, ($t1)
	loop2:	addu $t1, $t1, $t3
		lwc1 $f0, ($t1)
		add.s $f12, $f12, $f0
		blt $t1, $t2, loop2
		la $a0, result2
		li $v0, 4
		syscall
		li $v0, 2
		syscall
		li $a0, 10
		li $v0, 11
		syscall
		jr $ra
	err4:	la $a0, errMSG4		# prints error message if the column index is out of range
		li $v0, 4
		syscall
		j read4			# reads another column index
minimum:	move $t0, $a0
		mul $t1, $a1, $a1
		sll $t1, $t1, 2
		addiu $t1, $t1, -4
		addu $t1, $t1, $a0	# last address	
		move $t2, $t0		# t2 = least address
	loop3:	addiu $t0, $t0, 4
		lwc1 $f0, ($t0)
		lwc1 $f1, -4($t0)
		c.lt.s $f0, $f1
		bc1f skip
		move $t2, $t0	
	skip:	blt $t0, $t1, loop3
		lwc1 $f12, ($t2)
		sub $t2, $t2, $a0
		srl $t2, $t2, 2
		div $t2, $a1
		la $a0, result3_1
		li $v0, 4
		syscall
		li $v0, 2
		syscall
		la $a0, result3_2
		li $v0, 4
		syscall
		mflo $a0
		li $v0, 1
		syscall
		la $a0, result3_3
		li $v0, 4
		syscall		
		mfhi $a0
		li $v0, 1
		syscall
		li $a0, 10
		li $v0, 11
		syscall				
		jr $ra