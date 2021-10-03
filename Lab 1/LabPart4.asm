##
## Part 4 - Computes a mathematical formula
##
##	v0 - syscall variable
##	s0 - holds b
## 	s1 - holds c
##	s2 - holds d
## 	t0 - holds the outcome of the operation


#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	prompt1: .asciiz "Enter A: "
	prompt2: .asciiz "\nEnter B: "
	prompt3: .asciiz "\nEnter C: "
	prompt4: .asciiz "\nEnter D: "
	lastPrompt: .asciiz "\nThe result of the \"(A / B) + (C * D - A) % B\" operation is: "
	
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
	
	# $t0 = (a / b)
	div $t0, $s0, $s1
	
	# $t1 = (c * d)
	mul $t1, $s2, $s3
	
	# $t1 = (c * d - a)
	sub $t1, $t1, $s0
	
	# (c * d - a) / b
	div $t1, $s1
	
	# $t1 = (c * d - a) % b
	mfhi $t1
	
	# $t0 = (a / b) + (c * d - a) % b
	add $t0, $t0, $t1
	
	# print the outcome of the operation
	li $v0, 4
	la $a0, lastPrompt
	syscall 
	
	move $a0, $t0
	li $v0, 1
	syscall
	










