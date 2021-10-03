# Count the number of 1 bits in a registers
	.text
# $t0: Register to be examined
# $t1: Mask
# $t2: Sum
# $t3: We have 32 bits to consider: keep track

# Initialization:
	add	$t0, $t0, 255		# 0x000000ff	# hard coded input
	addi	$t1, $zero, 1		# Mask: shift this from right to left
	add	$t2, $zero, $zero	# sum: $t2
	addi	$t3, $zero, 32		# No. of bits to be considered

# Main body:
next:
	beq	$t3, $zero, done	# Are we done?
	and	$t4, $t0, $t1
	beq	$t4, $zero, skip
	addi	$t2, $t2, 1		# sum++
skip:
	sll	$t1, $t1, 1
	addi	$t3, $t3, -1		# Processed a bit
# Check: Are there more bits to consider?
	j	next

# Print result and stop:
done:
	add	$a0, $t2, $zero		# $a0= sum
	li	$v0, 1			# Print sum	
	syscall				
	
# Stop:
	li	$v0, 10
	syscall
	
			
