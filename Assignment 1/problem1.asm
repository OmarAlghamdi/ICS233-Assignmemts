## ASAAD ALGHAMDI 201516850

.data
count: .space 26	## 26 Addresses for count values

.align 6		## Align them by adding the missing 6
digit: .space 4		## A word for digit counter

input: .space 1000	 
header: .asciiz "Letter\tCount\n"
str1: .asciiz "Character Count of input.txt:\n"
str2: .asciiz "Total Digits Found:\n"
str3: .asciiz "File not found. Program terminated!"

fileloc: .asciiz "input.txt"		## ENTER YOUR INPUT FILE NAME CORRECTLY or not.

.text

li $v0, 13
la $a0, fileloc		## OPEN FILE

syscall
bltz $v0, error

move $a0, $v0
li $v0, 14
li $a2, 1000
la $a1, input	
syscall			## READ FILE INTO INPUT LABEL WITH LIMIT OF 1024 characters.



la $t0, input		## During duration of THIS loop: $t0 = the address of file text $t1: is alphabet characters incrementer (Starts with 'a' = 0x61) 
loop:			##				 $t2 = the smallifyed INPUT file character.	$t3 = The address of the current $t1 character count
			##				 $t5 = the RAW INPUT file character extracted from $t0  $t6 = Temp. register to store & increment address DIGIT
			
			
lbu $t5, 0($t0)		## $t5 = Load byte from ADDRESS in $t0
beq $t5, $zero, countEND	## Did we reach null-character? If no, proceed!
blt $t5, 0x30, skip		## Is $t5 binary value LESS than the MINIMUM accepted range which starts with 0?	      if($t5 > 0
blt $t5, 0x3A, digits		## Is $t5 binary value LESS than the MAXIMUM accepted range for DIGITS which is less than ':' 	$t5 <= 9)	(HINT: The last digit character element 9. The next character is ':')
move $a0, $t5	##	If they're not digits, let's assume that they're letters. Make the capital letters small, 
jal smallify	##	and let the small stay small! (This function will only interact with characters in the range between A<= x <=Z or a<= x <=z

move $t2, $a0	## Move the return value of the function into $t2
blt $t2, 0x61, skip	## If the returned value is not within the range a <= x <= z
bgt $t2, 0x7A, skip		## THEN SKIP
li $t1, 0x61	## Load $t1 with the letter a [Keep it synchornized with $t3]
la $t3, count	## Load $t3 with the address [Keep it synchornized with $t1]
j charSearch ## Let's search!

skip:
addiu $t0, $t0, 1	## Increment the input address by 1 and go back to the start of the loop.
j loop

digits:	## Load the current value found at digit counter Address into $t6, Increment by 1 and save it as the new value at digit Address. then go back to the start of loop.
lbu $t6, digit
addiu $t6, $t6, 1
addiu $t0, $t0, 1
sb $t6, digit
j loop



charSearch:
bne $t2, $t1, unmatched 	
lbu $t4, 0($t3)	## Load the count value found at the address in $t3 into $t4.
addiu $t4, $t4, 1	## Increment $t4 by one
addiu $t0, $t0, 1	## Increment our Input file text Address by one
sb $t4, 0($t3)		## Store the new incremented $t4 count value in $t3
j loop	
unmatched:	
addiu $t3, $t3, 1	##Increment $t3 to move to the next character. [Example: 'a'+1 = 'b', 'b'+1 = 'c' .. etc]	-- Must be synchronized with $t1
addiu $t1, $t1, 1	##Increment the character counter address [Base Address = 'a' count value, Base Address + 1 = 'b' count value .. etc] -- Must be synchronized with $t3
j charSearch









countEND:

li $t0, 0x61	#Set $t0 to 'a'
la $t1, count	#Load the base Address of character counters
la $a0, str1	# Print smth nice
li $v0, 4
syscall
la $a0, header	# More print! "Letter 	Count"
syscall
print:
move $a0, $t0	# Prepare to print the first character
bgt, $t0, 0x7A, end	## If we exceed 'z', Stop.

li $v0, 11
move $a0, $t0
syscall			## Print character

li $a0, 0x9		## Load space
syscall			## Print space between letter and counter value to make it look nice [Example: a  20 ... b  30.. etc].. whatever
lbu $a0, 0($t1)		## Load counter value
li $v0, 1
syscall			## Print Counter value

la $a0, 0xA		## Print the breakspace character "\n".
li $v0, 11
syscall
addiu $t0, $t0, 1	## Increment the alphabet ['a' -> 'b', 'b' -> 'c' .. etc]
addiu $t1, $t1, 1	## Increment the count value address.

j print





end:
la $a0, str2	## print "Total digit count:"
li $v0, 4
syscall
lw $a0, digit	# Load the digit count value
li $v0, 1
syscall		## Print it.


li $v0, 10
li $a0, 0
syscall	## Terminate the program!


smallify:
blt $a0, 'A', else	## if($a0 < 'A' && $a0 > 'Z') -- meaning the argument has to be in the range between A and Z
bgt $a0, 'Z', else
addi $a0, $a0, 32	## then make it small letter
jr $ra
else:
move $v0, $a0	## else return the argument as it was received
jr $ra

error: ## In case the file wasn't found!
la $a0, str3
li $v0, 4
syscall
li $v0, 10
syscall
