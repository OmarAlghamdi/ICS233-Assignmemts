# Omar Alghamdi
# 201528950
.data
prompt1:	.asciiz	"Enter the lenght of your array\n"
prompt2:	.asciiz	"Enter the elements of your array"
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
	jal read_array
	
read_array:
print_array:
merge:
merge_sort:
exit;	li $v0, 10
	syscall	