##
## Part 2 - Reads input from the user and performs x= a * (b - c) % d
##
##	v0 - syscall variable
##	a0 - holds strings and integers to be printed
##	s0 - holds a
##	s1 - holds b
##	s2 - holds c
## 	s3 - holds d
##	t0 - holds the outcome

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	prompt1: .asciiz "Enter a: "
	prompt2: .asciiz "\nEnter b: "
	prompt3: .asciiz "\nEnter c: "
	prompt4: .asciiz "\nEnter d: "
	lastPrompt: .asciiz "\nThe result of the \"a * (b - c) % d\" operation is: "



#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:
	# Prompt the user to enter a
	li $v0, 4
	la $a0, prompt1
	syscall 
	
	# Get a
	li $v0, 5
	syscall
	
	# Store a in $s0
	move $s0, $v0
	
	# Prompt the user to enter b
	li $v0, 4
	la $a0, prompt2
	syscall
	
	# Get b
	li $v0, 5
	syscall
	
	# Store b in $s1
	move $s1, $v0
	
	# Prompt the user to enter c
	li $v0, 4
	la $a0, prompt3
	syscall
	
	# Get c
	li $v0, 5
	syscall
	
	# Store c in $s2
	move $s2, $v0
	
	# Prompt the user to enter d
	li $v0, 4
	la $a0, prompt4
	syscall
	
	# Get d
	li $v0, 5
	syscall
	
	# Store d in $s3
	move $s3, $v0
	
	# $t0 = (b - c)
	sub $t0, $s1, $s2
	
	# $t0 = a * (b - c)
	mult $t0, $s0
	mflo $t0 
	
	# $t0 = a * (b - c) % d
	div $t0, $s3
	mfhi $t0
	
	# print the outcome of the operation
	li $v0, 4
	la $a0, lastPrompt
	syscall 
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	
	
	
	
	
	
	
	
	
	
	














	
