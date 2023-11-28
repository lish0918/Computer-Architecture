##############################################################################
#
#  KURS: 1DT038 2018.  Computer Architecture
#	
# DATUM: 2023-11-07
#
#  NAMN: Linjing Shen			
#  NAMN: Alhassan Jawad
#  NAMN: Zezheng Zhang
#
##############################################################################

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a2, STR_str  #改为$a2，因为ascii中修改了$a0
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a2, STR_str
	la	$a1, to_upper
	jal	string_for_each
		
	la	$a0, STR_str
	jal	print_test_string	
	
	##
	### reverse_string
	##
	
	li	$v0, 4
	la	$a0, STR_reverse
	syscall
	
	la 	$a0, STR_str   
	jal	reverse_string
	
	la	$a0, STR_str
	jal	print_test_string	
	
	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra

##############################################################################
	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "Hunden"
STR_reverse:
	.asciiz "\n\nstring_reverse\n\n"	
Test:
	.asciiz "slj"
	
	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:
	#$a0, FIBONACCI_ARRAY
	#$a1, ARRAY_SIZE
        
  	loop:
  		beq $t0, $a1, done     # Done if i == N
  		lw $t1, 0($a0)        # address = ARRAY + 4*i   # n = A[i]
  		add $v0, $v0, $t1	# Sum = Sum + n
  		addi $a0, $a0, 4     	# 4*i
  		addi $t0, $t0, 1      # i++ 
  		j loop
  	done:
  		j end_for_all 
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:
	#$a0, STR_str
	li $v0, 0
	loop_1:
		lb $t0, 0($a0)			# = a0[i]
		beq $t0, $zero, done_1 	# Done if elem == NULL
		addi $a0, $a0, 1	#address++1
		addi $v0, $v0, 1	#length ++1
		j loop_1
	done_1:
		jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

	addi	$sp, $sp, -4		# PUSH return address to caller
	sw	$ra, 0($sp)
	
	loop_2:	
		lb $t4, 0($a2)          #$a2, STR_str
		beq $t4, $zero, done_2	# Done if elem == NULL
		jalr $a1		#$a1, ascii
		addi $a2, $a2, 1
		j loop_2
	
	done_2:	
	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4		
	jr	$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:
	li $t1, 'a'
	li $t2, 'z'
	
	blt $t4, $t1, not_lower #if $t0<$t1 -> done_4
	bgt $t4, $t2, not_lower #if $t0>$t2 -> done_4
	
	addi $t4, $t4, -32 #lower -> upper
	sb $t4, 0($a2)  #store byte
	
	not_lower:
	jr	$ra

##############################################################################
#
#  DESCRIPTION: Reverse the string
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################	
reverse_string:
	addi $sp, $sp, -8  # Allocates 8 bytes of space on the stack
	sw $ra, 4($sp)     # return address on the stack
    
	jal string_length	
	la  $a0, STR_str 
	move $t0, $v0      # Store the length in $t0

	beq $t0, $zero, done_4 #if the string is null

	add $t2, $a0, $t0 
	addi $t2, $t2, -1 #the end pointer	

	reverse_loop:
    		lb $t3, 0($a0)     # load the beginning character
    		lb $t4, 0($t2)     # load the end character

   		blt $t0, 2, done_4 

   		sb $t4, 0($a0)     # store the character from the end at the beginning
   		sb $t3, 0($t2)     # store the character from the beginning at the end
		
   		addi $a0, $a0, 1   # Move the beginning pointer forward
    		addi $t2, $t2, -1  # Move the end pointer backward
    		
    		addi $t0, $t0, -2

   		j reverse_loop

	done_4:
		lw $ra, 4($sp)     # Restore the return address
    		addi $sp, $sp, 8  # Deallocate the stack space
    		jr $ra             # Return

##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	
	
	.text
	.globl main

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	
	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	
	.text

	add	$t0, $a0, $zero	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "
	.text

	la	$t0, STR_the_ascii_value_is
	# Replace X with the input character
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a2)	# modify to $a2
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."	
	add	$a0, $t0, $zero #给a0,t1,t2重新赋�?�了
	li	$v0, 4
	syscall

	# Append the Ascii value
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall

	jr	$ra
