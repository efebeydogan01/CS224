##
## Part 1 - Finds if an array is symmetric or not
##
##	v0 - syscall variable
##	s0 - holds the array starting address
##	s2 - holds length variable address
##	t3 - holds the length
##	s1 - loop counter i
##	t0 - byte offset
##	s4 - ending address of the array

#################################
#					 	#
#		text segment		#
#						#
#################################
	.text
	.globl __start



__start:
	li $v0, 1
	la $s0, array		# get array's address

	addi $s1, $0, 0		# i = 0
	la $s2, arrsize		# get length address
	lw $t3, 0($s2)		# get length

loop:
	slt $t0, $s1, $t3	# is i < length
	beq $t0, $0, done	# if not, then branch to done
 	
 	sll $t0, $s1, 2		# $t0 = i*4 (byte offset)
 	add $t0, $t0, $s0	# address of array[i]
 	lw $a0, 0($t0)		# $a0 = array[i]
 	li $v0, 1
 	syscall			# display array[i]
 	
 	la $a0, space		# print space
 	li $v0, 4
 	syscall
 	
 	
 	addi $s1, $s1, 1	# i = i + 1
 	j loop			# repeat

done:
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	addi $s1, $t3, -1	# $s1 = length - 1
	
	sll $s1, $s1, 2		# $s1 = $s1 * 4
	add $s4, $s0, $s1	# $s4 is the ending address, $s0 is the starting address

checkSymmetric:
	beq $s0, $s4, symm	# if the starting and ending addresses are the same, jump to symm because the array is a palindrome
	slt $t0, $s4, $s0
	beq $t0, 1, symm	# if the ending address is smaller than beginning address, the array is a palindrome
	
	lw $s1, 0($s0)		# $s1 is the first character to check in array
	lw $s2, 0($s4)		# $s2 is the second character to check in 
	
	bne $s1, $s2, notSymm 	# if the characters are not equal, the array is not a palindrome
	
	addi $s0, $s0, 4		# get the address of the next character
	addi $s4, $s4, -4		# get the address of the previous character
	j checkSymmetric
		
	


symm:
	la $a0, isSymmetric
	li $v0, 4
	syscall
	
	j finish
	


notSymm:
	la $a0, notSymmetric
	li $v0, 4
	syscall


finish: 





#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
array: .word 1,23, 32, 1
arrsize: .word 4
isSymmetric: .asciiz "The above array is symmetric"
notSymmetric: .asciiz "The above array is not symmetric"
endl:	.asciiz "\n"
space: .asciiz " "

