##
## Part 2 - Recursive division
##	
##	a0 - holds the dividend
##	a1 - holds the divisor
##

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	promptDividend: .asciiz "Please enter the dividend: "
	promptDivisor: .asciiz "Please enter the divisor: "
	endl: .asciiz "\n"
	outcome: .asciiz "The result of the division is: "
	question: .asciiz "Enter 1 if you want to continue or any other number if you want to quit: "

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:

	prompt:
		la $a0, promptDividend
		li $v0, 4
		syscall
		
		# get the number
		li $v0, 5
		syscall
		
		move $t0, $v0		# $t0 = dividend
		
		la $a0, endl		# system call to print
		li $v0,4		# out a newline
		syscall
		
		la $a0, promptDivisor
		li $v0, 4
		syscall
		
		# get the number
		li $v0, 5
		syscall
		
		move $t1, $v0		# $t1 = divisor
		
		la $a0, endl		# system call to print
		li $v0,4		# out a newline
		syscall
		
		move $a0, $t0		# $a0 = dividend
		move $a1, $t1		# $a1 = divisor
		
		jal recursiveDivide
		
		move $t0, $v0		# store the outcome in $t0
		
		la $a0, outcome
		li $v0, 4
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall			# print the outcome
		
		la $a0, endl		# system call to print
		li $v0,4		# out a newline
		syscall	
		
		la $a0, question
		li $v0, 4
		syscall
		
		# get the number
		li $v0, 5
		syscall	
		move $t2, $v0
		
		la $a0, endl		# system call to print
		li $v0,4		# out a newline
		syscall	
		
		beq $t2, 1, prompt	# branch to beginning if the user wants to continue		
				
		li $v0,10  		# system call to exit
		syscall			#    bye bye
		
recursiveDivide:
	add $v0, $0, $0
recursion:
	addi $sp, $sp, -4		# make room on stack for $ra
	sw $ra, 0($sp)			# store $ra on stack
	
	bge $a0, $a1, else		# dividend >= divisor?, if yes then go to else
	addi $sp, $sp 4			# restore the stack
	jr $ra				# return
	else: 
		add $v0, $v0, 1		# increase the outcome by one
		sub $a0, $a0, $a1	# subtract the divisor from dividend
		jal recursion
		
		lw $ra, 0($sp)		# restore $ra
		addi $sp, $sp, 4	# restore stack
		jr $ra			# return
		
		
		
		
		
		
		
		
		
		