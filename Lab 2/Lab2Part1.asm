##
## Part 1 - Prints an array, checks if an array is symmetric and finds min and max values in an array
##
##	a0 - holds array starting address
##	a1 - holds array length
##	

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	array: .word 31, 32, 311, 32, 30
	arrsize: .word 5
	isSymmetric: .asciiz "The above array is symmetric"
	notSymmetric: .asciiz "The above array is not symmetric"
	endl:	.asciiz "\n"
	space: .asciiz " "
	noArray: .asciiz "The array has 0 elements"
	max: .asciiz "Max: "
	min: .asciiz "Min: "
	
	
#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:
	
	lw $a1, arrsize		# get length
	beq $a1, $0, noArr	# if the array length is 0, branch and tell the user that array has length 0
	
	la $a0, array		# get array's address
	
	jal PrintArray
	la $a0, array
	jal CheckSymmetric
	la $a0, array
	jal FindMinMax
	
	add $t0, $v0, $0	# copy the min value
	add $t1, $v1, $0	# copy the max value
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	li $v0, 4	
	la $a0, max		# print the max value
	syscall
	
	li $v0, 1
	addi $a0, $t1, 0
	syscall	
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	li $v0, 4	
	la $a0, min		# print the min value
	syscall
	
	li $v0, 1
	addi $a0, $t0, 0
	syscall	
	
	li $v0,10  		# system call to exit
	syscall			#    bye bye
	
PrintArray:
	addi $sp, $sp, -16	# make space on stack to store four registers
	sw $s0, 12($sp)		# save $s0 on stack ($s0 will be loop counter i)
	sw $s1, 8($sp)		# save $s1 on stack ($s1 will be offset)
	sw $s2, 4($sp)		# save $s2 on stack
	sw $s3, 0($sp)		# save $s3 on stack
	add $s2, $a0, $0	# copy the address of the array into $s2, since $a0 will be used for syscalls
	
	addi $s0, $0, 0		# i = 0

	loop:
		# loop to print the contents of the array
		slt $s3, $s0, $a1	# is i < length
		beq $s3, $0, loopDone	# if not, then branch to done
 	
 		sll $s1, $s0, 2		# $s1 = i*4 (byte offset)
 		add $s1, $s1, $s2	# address of array[i]
 		lw $a0, 0($s1)		# $a0 = array[i]
 		li $v0, 1
 		syscall			# display array[i]
 	
 		la $a0, space		# print space
 		li $v0, 4
 		syscall
 	
 	
 		addi $s0, $s0, 1	# i = i + 1
 		j loop			# repeat

	loopDone:
		la $a0, endl		# system call to print
		li $v0,4		# out a newline
		syscall
		
		add $a0, $s2, $0	# restore $a0
		lw $s3, 0($sp)		# restore $s3
		lw $s2, 4($sp)		# restore $s2
		lw $s1, 8($sp)		# restore $s1
		lw $s0, 12($sp)		# restore $s0
		addi $sp, $sp, 16	# restore stack
		jr $ra
	
# PrintArray subprogram over

CheckSymmetric:
	
	addi $sp, $sp, -16
	sw $s0, 12($sp)		# save $s0 on stack ($s0 will be the starting address of the array)
	sw $s1, 8($sp)		# save $s1 on stack ($s1 will be the ending address of the array)
	sw $s2, 4($sp)		# save $s2 on stack
	sw $s3, 0($sp)		# save $s3 on stack
	add $s0, $a0, $0	# copy the address of the array into $s0, since $a0 will be used for syscalls
	
	addi $s1, $a1, -1	# $s1 = length - 1
	sll $s1, $s1, 2		# $s1 = $s1 * 4
	add $s1, $s0, $s1	# $s1 is the ending address, $s0 is the starting address

	check: 
	beq $s0, $s1, symm	# if the starting and ending addresses are the same, jump to symm because the array is a palindrome
	slt $s2, $s1, $s0
	beq $s2, 1, symm	# if the ending address is smaller than beginning address, the array is a palindrome
	
	lw $s2, 0($s0)		# $s2 is the first character to check in array
	lw $s3, 0($s1)		# $s3 is the second character to check in array
	
	bne $s2, $s3, notSymm 	# if the characters are not equal, the array is not a palindrome
	
	addi $s0, $s0, 4	# get the address of the next character
	addi $s1, $s1, -4	# get the address of the previous character
	j check
		

	symm:
		la $a0, isSymmetric
		li $v0, 4
		syscall
		
		li $v0, 1	# return 1
	
		j finish
	


	notSymm:
		la $a0, notSymmetric
		li $v0, 4
		syscall
		li $v0, 0	# return 0

	finish: 
		lw $s3, 0($sp)		# restore $s3
		lw $s2, 4($sp)		# restore $s2
		lw $s1, 8($sp)		# restore $s1
		lw $s0, 12($sp)		# restore $s0
		addi $sp, $sp, 16	# restore stack
		jr $ra
# CheckSymmetric subprogram over

FindMinMax:

	addi $sp, $sp, -12	# make space on stack to store three registers
	sw $s0, 8($sp)		# save $s0 on stack ($s0 will be loop counter i)
	sw $s1, 4($sp)		# save $s1 on stack ($s1 will be offset)
	sw $s2, 0($sp)		# save $s2 on stack
	
	addi $s0, $0, 0		# i = 0
	
	lw $v0, 0($a0)		# $v0 is min
	lw $v1, 0($a0)		# $v1 is max 
	
	checkValues:
		slt $s1, $s0, $a1	# is i < length
		beq $s1, $0, found	# if not then finish the loop
	
		sll $s1, $s0, 2		# $s1 = i*4 (byte offset)
		add $s1, $s1, $a0	# address of array[i]
	
		lw $s1, 0($s1)		# $s1 is array[i] 
	
		slt $s2, $s1, $v0	# if array[i] < min
		bne $s2, 1, contMax	# if the value isn't smaller, than branch to check max
		add $v0, $s1, $0	# set the new min value
		j cont
	
	contMax:
		slt $s2, $v1, $s1	# if array[i] > max
		bne $s2, 1, cont	# if the value isn't bigger, than continue
		add $v1, $s1, $0	# set the new max value
	
	cont:
		addi $s0, $s0, 1	# i = i + 1
		j checkValues
	
	found:
		lw $s2, 0($sp)		# restore $s2
		lw $s1, 4($sp)		# restore $s1
		lw $s0, 8($sp)		# restore $s0
		addi $sp, $sp, 12	# restore stack
		jr $ra
# FindMinMax subprogram over
 
noArr:
	li $v0, 4
	la $a0, noArray
	syscall 
	
	li $v0,10  		# system call to exit
	syscall			#    bye bye




