##
## Part 1 - Counts the number of add and lw instructions
##
##	a0 - holds the address of the first label
##	a1 - holds the address of the second label
##	

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	message1: .asciiz "The number of add instructions in main is: "
	message2: .asciiz "The number of lw instructions in main is: "
	message3: .asciiz "The number of add instructions in the subprogram is: "
	message4: .asciiz "The number of lw instructions in the subprogram is: "
	endl: .asciiz "\n"



#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:

first_instruction:	la $a0, first_instruction
			la $a1, last_instruction
			
			jal count
			
			add $t0, $v0, $0	# $t0 = number of add operations
			add $t1, $v1, $0	# $t1 = number of lw operations
			
			la $a0, message1
			li $v0, 4
			syscall
			
			li $v0, 1
			addi $a0, $t0, 0	# print the no of add instructions in main
			syscall	
			
			la $a0, endl		# system call to print
			li $v0,4		# out a newline
			syscall
			
			la $a0, message2
			li $v0, 4
			syscall
			
			li $v0, 1
			addi $a0, $t1, 0	# print the no of lw instructions in main
			syscall	
			
			la $a0, endl		# system call to print
			li $v0,4		# out a newline
			syscall
			
			la $a0, first_sub
			la $a1, last_sub
			
			jal count
			
			add $t0, $v0, $0	# $t0 = number of add operations
			add $t1, $v1, $0	# $t1 = number of lw operations
			
			la $a0, message3
			li $v0, 4
			syscall
			
			li $v0, 1
			addi $a0, $t0, 0	# print the no of add instructions in subprogram
			syscall	
			
			la $a0, endl		# system call to print
			li $v0,4		# out a newline
			syscall
			
			la $a0, message4
			li $v0, 4
			syscall
			
			li $v0, 1
			addi $a0, $t1, 0	# print the no of lw instructions in subprogram
			syscall		
			
			li $v0,10  		# system call to exit
last_instruction:	syscall			#    bye bye

count:
first_sub:	addi $sp, $sp, -16	# make space on stack to store four registers
	sw $s0, 12($sp)		# save $s0 on stack ($s0 will be loop counter)
	sw $s1, 8($sp)		# save $s1 on stack ($s1 will be offset)
	sw $s2, 4($sp)		# save $s2 on stack
	sw $s3, 0($sp)		# save $s3 on stack
	
	add $v0, $0, $0
	add $v1, $0, $0
	
	add $s0, $a0, $0	# $s0 = starting label
	add $s1, $a1, $0	# $s1 = ending label

for:
	bgt $s0, $s1, done	# if you have reached the end, branch to done
	
	lw $s2, 0($s0)		# $s2 = instruction at the address
	
	add $s3, $s2, $0	# $s3 = instruction (will be changed)
	
	srl $s3, $s3, 26	# $s3 = first 6 bits of the instruction (opcode)

if_opcode_35:
	bne $s3, 35, if_opcode_0	# if the opcode is 35, the instruction is a lw instruction
	addi $v1, $v1, 1			# add 1 to $v1 for returning the number of lw operations
	addi $s0, $s0, 4			# get the next address
	j for
	
if_opcode_0:
	addi $s0, $s0, 4			# get the next address
	bne $s3, 0, for			# j jump back to beginning if the opcode isn't 0
	
	add $s3, $s2, $0		# get the full address again
	
	andi $s3, $s3, 63		# and with 63 to see if the last 6 bits are equal to 32
	
	bne $s3, 32, for		# branch to the beginning of the loop if funct field isn't 32
	
	addi $v0, $v0, 1		# add 1 to $v0 for returning the number of add operations
	j for
	
done:
	lw $s3, 0($sp)		# restore $s3
	lw $s2, 4($sp)		# restore $s2
	lw $s1, 8($sp)		# restore $s1
	lw $s0, 12($sp)		# restore $s0
	addi $sp, $sp, 16	# restore stack
last_sub:	jr $ra
	

	
	
	
