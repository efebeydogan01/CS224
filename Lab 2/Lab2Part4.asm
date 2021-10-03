##
## Part 4 - Counting bit pattern occurence in a number
##
##	a0 - stores bit pattern to be counted
##	a1 - holds the number to be checked
##	a2 - holds bit pattern length

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	enterNumber: .asciiz "Please enter the number: "
	enterPattern: .asciiz "Please enter the bit pattern: "
	enterLength: .asciiz "Please enter the pattern length: "
	endl:	.asciiz "\n"
	number: .word 0xabccbaab
	bitPattern: .word 0x0000000c 
	patternLength: .word 12
	message1: .asciiz "The number "
	message2: .asciiz " contains the bit pattern "
	comma: .asciiz ", "
	message3: .asciiz " times."
	
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:
	
	la $a0, enterNumber	# ask the user for number
	li $v0, 4		
	syscall
	
	# get the number
	li $v0, 5
	syscall
	
	add $t1, $v0, $0	# store the number in $t1
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	la $a0, enterPattern	# ask the user for pattern
	li $v0, 4		
	syscall
	
	# get the pattern
	li $v0, 5
	syscall
	
	add $t2, $v0, $0	# store pattern in $t2
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	la $a0, enterLength	# ask the user for pattern length
	li $v0, 4		
	syscall
	
	# get the pattern length
	li $v0, 5
	syscall
	
	add $t3, $v0, $0	# store pattern in $t3
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	add $a0, $t2, $0	# load the pattern in $a0
	add $a1, $t1, $0	# load the number in $a1
	add $a2, $t3, $0	# load the pattern length in $a2
	
	jal countPattern
	
	add $t0, $v0, $0	# contain the number of occurences in $t0
	
	# print message
	la $a0, message1
	li $v0, 4
	syscall
	
	# print number in hexadecimal
	move $a0, $a1
	li $v0, 34
	syscall
	
	# print message
	la $a0, message2
	li $v0, 4
	syscall
	
	# print bit pattern in hexadecimal
	move $a0, $v1
	li $v0, 34
	syscall
	
	# print message
	la $a0, comma
	li $v0, 4
	syscall
	
	# print the number of occurences
	add $a0, $t0, $0	# put number of occurences in $a0
	li $v0, 1
	syscall
	
	# print message
	la $a0, message3
	li $v0, 4
	syscall
	
	
	li $v0,10  		# system call to exit
	syscall			#    bye bye
	
countPattern:
	addi $sp, $sp, -20	# make space on stack to store five registers
	sw $s0, 16($sp)		# save $s0 on stack (contains shift amount)
	sw $s1, 12($sp)		# save $s1 on stack (contains bit pattern)
	sw $s2, 8($sp)		# save $s2 on stack (contains the number)
	sw $s3, 4($sp)		# save $s3 on stack (contains the length, loop counter)
	sw $s4, 0($sp)		# save $s4 on stack
	
	addi $s0, $a2, -32	# $s0 = length - 32
	mul $s0, $s0, -1	# $s0 = 32 - length (the amount that pattern needs to be shifted left and then right
	
	sllv $s1, $a0, $s0	# $s1 contains the bit pattern in left most digits
	srlv $s1, $s1, $s0	# $s1 contains the bit pattern in its least significant digits
	
	add $s2, $a1, $0	# $s2 = number
	add $s3, $a2, $0	# $s3 = pattern length (loop counter)
	add $v0, $0, $0		# $v0 = number of occurences of pattern in the number
	
	loop:
		bgt $s3, 32, finished
		
		sllv $s4, $s2, $s0
		srlv $s4, $s4, $s0	# get the numbers digits to compare in least significant digits
		
		bne $s4, $s1, notEq	# branch if pattern is not equal
		srlv $s2, $s2, $a2	# shift the number to the right so the digits already compared are no longer contained		
		addi $v0, $v0, 1	# add 1 to number of occurences if equal
		add $s3, $s3, $a2	# increment the counter
		j loop
		
		notEq:
			addi $s3, $s3, 1	# increment the counter
			srlv $s2, $s2, $a2	# shift the number to the right
			j loop
		
	finished:
		add $v1, $s1, $0	# return the bit pattern in $v1
		lw $s4, 0($sp)
		lw $s3, 4($sp)
		lw $s2, 8($sp)		# restore the registers
		lw $s1, 12($sp)
		lw $s0, 16($sp)
		addi $sp, $sp, 20
		jr $ra

# end of countPattern subprogram
