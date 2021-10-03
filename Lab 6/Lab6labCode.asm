
##
## Part 4 -  Program to find the average of the elements of a square matrix
##
##	$s0 - holds the array size
##	$s1 - holds the array starting address	
##	$s3 - N (number of rows and columns)

#################################
#					 	#
#     	 data segment		#
#						#
#################################

.data
	dimensionPrompt: .asciiz "Enter the dimension of the matrix: "
	endl: .asciiz "\n"
	askUser: .asciiz "(Enter 1) Display a desired matrix element \n(Enter 2) Obtain the average of the matrix elements in a row-major \n(Enter 3) Obtain the average of matrix elements in a column-major \n(Enter 4) Create new array \n(Enter -1) Exit"
	enterSelection: .asciiz "Enter a number for selection: "
	goodbye: .asciiz "See you later"
	enterRow: .asciiz "Enter the row number of the element: "
	enterCol: .asciiz "Enter the column number of the element: "
	theElement: .asciiz "The element at the specified position is: "
	invalid: .asciiz "Invalid selection, please try again"

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text
	.globl __start
	
__start:	
	la $a0, dimensionPrompt		# ask the user for dimension
	li $v0, 4		
	syscall
	
	# get the dimension
	li $v0, 5
	syscall
	
	# store dimension in $s0
	add $s0, $v0, $0
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	move $s3, $s0		# $s3 = N
	mul $s0, $s0, $s0	# calculate N*N (size of the matrix)
	
	sll $a0, $s0, 2		# determine the number of bytes needed for dynamic allocation
	
	li $v0, 9		# dynamic allocation
	syscall
	
	move $s1, $v0		# $s1 holds the starting address of the array
init:
	# initialize the array values
	li $t0, 0		# $t0 keeps track of array
	move $t1, $s1		# $t1 holds the current address
loop1:
	beq $t0, $s0, initDone	# if the array has been initialized, jump to done
	addi $t0, $t0, 1	# add 1 to loop variable
	sw $t0, 0($t1)		# initialize the value
	addi $t1, $t1, 4	# increment the address
	
	j loop1			# jump to start of the loop
		
initDone:
	la $a0, askUser		# present operations
	li $v0, 4		
	syscall
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	la $a0, enterSelection		# ask the user for operation
	li $v0, 4		
	syscall
	
	# get the selection
	li $v0, 5
	syscall
	
	move $t0, $v0		# $t0 = the operation the user wants
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
operations:
	beq $t0, -1, exit	# if -1 is entered, jump to the exit
	beq $t0, 1, dispElement	# jump to display selection
	beq $t0, 2, rowAvg	# jump to finding the averages of the rows
	beq $t0, 3, colAvg	# jump to finding the averages of the columns
	beq $t0, 4, __start	# jump to start again
	
	la $a0, invalid		# ask the user for dimension
	li $v0, 4		
	syscall
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	j initDone

dispElement:
	la $a0, enterRow	# ask for row number
	li $v0, 4		
	syscall
	
	# get the row number
	li $v0, 5
	syscall
	
	move $t2, $v0		# $t2 = row number
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	la $a0, enterCol	# ask for column number
	li $v0, 4		
	syscall
	
	# get the column number
	li $v0, 5
	syscall
	
	move $t3, $v0		# $t3 = column number
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	
	addi $t2, $t2, -1	# (i-1)
	mul $t2, $t2, $s3	# (i-1) * N
	sll $t2, $t2, 2		# $t2 = (i-1) * N * 4
	
	addi $t3, $t3, -1	# (j-1)
	sll $t3, $t3, 2		# $t3 = (j-1) * 4
	
	add $t2, $t2, $t3	# $t2 = displacement of the element wrt to the beginning
	
	add $t2, $t2, $s1	# $t2 = address of the element
	
	lw $t2, 0($t2)		# $t2 = the element to print
	
	la $a0, theElement	# system call to print
	li $v0,4		# out the message
	syscall
	
	move $a0, $t2		# $a0 = the element
	
	li $v0, 1
	syscall
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall

	j initDone		# jump to initDone to let the user select again
rowAvg:
	li $t0, 0		# loop variable	
	li $t3, 0
	li $t5, 0		# $t5 will hold the sum
loopBegin:
	beq $t0, $s3, loopOver
	
	li $t1, 0		# initialize second loop variable
insideLoop:
	beq $t1, $s3, insideLoopOver	# jump to the end of the loop
	
	sll $t4, $t3, 2		# index * 4
	add $t4, $t4, $s1	# $t4 = address of the element to be added
	
	lw $t4, 0($t4)		# $t4 = the element that will be added
	
	add $t5, $t5, $t4	# add the value to the sum
	addi $t1, $t1, 1	# increment loop variable
	addi $t3, $t3, 1	# $t3 = $t3 + 1
	j insideLoop
insideLoopOver:
	addi $t0, $t0, 1	# increment loop variable
	j loopBegin
loopOver:	
	div $a0, $t5, $s0	# $a0 = sum / N*N
	
	li $v0, 1
	syscall
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	j initDone		# jump to initDone to let the user select again
colAvg:	
	li $t0, 0		# loop variable	
	li $t5, 0		# $t5 will hold the sum
loopBegin2:
	beq $t0, $s3, loopOver2
	
	move $t3, $t0		# $t3 will be used for index
	
	li $t1, 0		# initialize second loop variable
insideLoop2:
	beq $t1, $s3, insideLoopOver2	# jump to the end of the loop
	
	sll $t4, $t3, 2		# index * 4
	add $t4, $t4, $s1	# $t4 = address of the element to be added
	
	lw $t4, 0($t4)		# $t4 = the element that will be added
	
	add $t5, $t5, $t4	# add the value to the sum
	addi $t1, $t1, 1	# increment loop variable
	add $t3, $t3, $s3	# $t3 = $t3 + N
	j insideLoop2
insideLoopOver2:
	addi $t0, $t0, 1	# increment loop variable
	j loopBegin2
loopOver2:	

	div $a0, $t5, $s0	# $a0 = sum / N*N
	
	li $v0, 1
	syscall
	
	la $a0, endl		# system call to print
	li $v0,4		# out a newline
	syscall
	j initDone		# jump to initDone to let the user select again
	
exit:

	la $a0, goodbye		# print goodbye message
	li $v0, 4		
	syscall
	
	li $v0,10  		# system call to exit
	syscall			#    bye bye
