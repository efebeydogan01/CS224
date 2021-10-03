##
## Part 2 - Reverses the decimal number supplied by the user and prints the reversed number in hexadecimal form
##
##	a0 - holds the number
##	v0 - holds the reverse number
##		

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	prompt: .asciiz "Please enter a decimal number: "
	message: .asciiz "Your number in reverse in hexadecimal format is: "
	endl:	.asciiz "\n"
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:
	# ask the user to enter the number
	li $v0, 4
	la $a0, prompt
	syscall 
	
	# get the number
	li $v0, 5
	syscall
	
	add $a0, $v0, 0		# copy the number in $a0
	
	jal reverseBits
	
	add $s0, $v0, $0	# put the number in $s0
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	la $a0, message
	li $v0, 4
	syscall
	
	
	add $a0, $s0, $0
	li $v0, 34
	syscall			# print the number in hexadecimal
	
	li $v0,10  		# system call to exit
	syscall			#    bye bye
	
reverseBits:

	addi, $sp, $sp, -20	# allocate space on the stack
	sw $s0, 16($sp)		# store $s0 in stack ($s0 will be final number)
	sw $s1, 12($sp)		# store $s1 in stack
	sw $s2, 8($sp)		# store $s2 in stack
	sw $s3, 4($sp)		# store $s3 in stack
	sw $s4, 0($sp)		# store $s4 in stack
	                                               
	li $s0, 0		# set final to 0
	li $s1, 0x80000000	# set this to 2^31
	li $s2, 31		# srl variable
	li $s3, 1		# sll variable
	
	shiftRight:
		blt $s2, 1, shiftLeft	# if srl < 1, branch
		and $s4, $s1, $a0	# AND operation between number and the variable
		srlv $s4, $s4, $s2	# shift the result as necessary
		add $s0, $s0, $s4	# add the values to reverse
		subi $s2, $s2, 2	# subtract 2 from srl variable
		srl $s1, $s1, 1	
		j shiftRight	
	shiftLeft:
		bgt $s3, 31, done	# if all the numbers have been shifted, exit
		and $s4, $s1, $a0
		sllv $s4, $s4, $s3
		add $s0, $s0, $s4
		addi $s3, $s3, 2
		srl $s1, $s1, 1
		j shiftLeft
done:
	add $v0, $s0, $0	# return value
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)		# restore the registers
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	addi $sp, $sp, 20
	jr $ra

# end of reverseBits
