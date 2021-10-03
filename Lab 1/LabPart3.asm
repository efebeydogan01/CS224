##
## Part 3 - Finds the min, max, avg values of an array
##
##	v0 - syscall variable
##	s0 - holds the array starting address
## 	s1 - loop counter i
## 	t3 - array length
##	t4 - min element of array
##	t5 - max element of array
##	t6 - average of the values in the array


#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	array: .word 1, 1, 1, 1, 1
	arrsize: .word 5
	position: .asciiz "Position (hex): "
	value: .asciiz "Value (int): "
	endl: .asciiz "\n"
	commaSpace: .asciiz ", "
	avg: .asciiz "Average: "
	max: .asciiz "Max: "
	min: .asciiz "Min: "
	memAddr: .asciiz "Memory Address  Array Element\n"
	pos: .asciiz "Position (hex)  Value (int)\n"
	equals: .asciiz "==============  =============\n"
	sixSpaces: .asciiz "      "

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:
	li $v0, 1
	la $s0, array		# $s0 = array starting address

	addi $s1, $0, 0		# i = 0
	la $s2, arrsize		# get length address
	lw $t3, 0($s2)		# $t3 = get length
	
	lw $t4, 0($s0)		# $t4 = first element in array (min)
	lw $t5, 0($s0)		# $t5 = first element in array (max)
	li $t6, 0		# $t6 will be used for keeping track of the sum
	
	# code for printing the layout
	la $a0, memAddr
	li $v0, 4
	syscall
	
	la $a0, pos
	syscall
	
	la $a0, equals
	syscall
	
	# start the loop
loop:
	slt $t0, $s1, $t3	# is i < length
	beq $t0, $0, done	# if not, then branch to done
 	
 	sll $t0, $s1, 2		# $t0 = i*4 (byte offset)
 	add $t0, $t0, $s0	# address of array[i]
 	
# 	la $a0, position	# output prompt message on terminal
#	li $v0,4		# syscall 4 prints the string
#	syscall	
 	
 	li $v0, 34
 	add $a0, $0, $t0	# print the address in hexadecimal format
 	syscall 

  	la $a0, sixSpaces	# print space
 	li $v0, 4
 	syscall
 	
#	la $a0, value		# output prompt message on terminal
#	li $v0,4		# syscall 4 prints the string
#	syscall 	 	
 	 	 	 	
 	lw $a0, 0($t0)		# $a0 = array[i]
 	add $t6, $t6, $a0	# add the element to the sum
 	li $v0, 1
 	syscall			# display array[i]
 	
 	slt $t1, $a0, $t4	# if array[i] < min
 	bne $t1, 1, contMax	# if the value isn't smaller, than branch to check max
 	andi $t4, $a0, 0xffff	# set the new min value
 	j contMin
contMax:
	slt $t1, $t5, $a0	# if array[i] > max
	bne $t1, 1, contMin	# if the value isn't bigger, than continue
	andi $t5, $a0, 0xffff	# set new max value	
contMin:	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
 	
 	addi $s1, $s1, 1	# i = i+1
 	j loop			# repeat
 	
done:
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	div $t6, $t6, $t3	# calculate the average
	
	li $v0, 4	
	la $a0, avg		# print the average
	syscall
	
	li $v0, 1
	addi $a0, $t6, 0
	syscall
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	li $v0, 4	
	la $a0, max		# print the max value
	syscall
	
	li $v0, 1
	addi $a0, $t5, 0
	syscall	
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	li $v0, 4	
	la $a0, min		# print the min value
	syscall
	
	li $v0, 1
	addi $a0, $t4, 0
	syscall	
	
	
	
	
	
	
	
	
 	
 	
 	
 	
