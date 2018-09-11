#main hw4



.data
newline:  .asciiz "\n"
comma:    .asciiz ", "

.text
.globl _start


####################################################################
# This is the "main" of your program; Everything starts here.
####################################################################

_start:

	##################
	# CLEAR BOARD
	##################
	
	#load in values and call clear board
	li $a0, 0xffff0000
	li $a1, 6
	li $a2,	5
	jal clear_board
	# print return value	
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	
	###################
	#PLACE
	###################
	
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 4
	li $a3, 0
	li $t0, 0
	li $t1, 2
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8
	
	###################
	#START GAME
	###################
	addi $sp, $sp, -12
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 4
	li $a3, 2
	li $t0, 3
	li $t1, 2
	li $t2, 2
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	jal start_game

	addi $sp, $sp, 12
	
	####################
	# MERGE ROW
	####################
	
	addi $sp, $sp, -4
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 4
	li $a3, 2
	li $t0, 0
	
	sw $t0, 0($sp)
	jal merge_row

	addi $sp, $sp, 4
	
	#####################
	#MERGE COLUMN
	#####################
	addi $sp, $sp, -8
   	#calling place to test addition of columns
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 4
	li $a3, 1
	li $t0, 2
	li $t1, 4
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8

	addi $sp, $sp, -4
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 4
	li $a3, 2
	li $t0, 1
	
	sw $t0, 0($sp)
	jal merge_col

	addi $sp, $sp, 4
	
	#######################
	#SHIFT ROW
	#######################
	#PLACE VALUE FOR TESTING
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 5
	li $a3, 1
	li $t0, 1
	li $t1, 4
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	#jal place

	addi $sp, $sp, 8
	########################
	
	
	addi $sp, $sp, -4
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 5
	li $a3, 1
	li $t0, 0
	
	sw $t0, 0($sp)
	jal shift_row

	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
   	
	li $a0, 0xffff0000
	li $a1, 4
	li $a2, 5
	li $a3, 1
	li $t0, 1
	
	sw $t0, 0($sp)
	jal shift_row

	addi $sp, $sp, 4
	#######################
	#SHIFT COL
	#######################
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 5
	li $a2, 4
	li $a3, 1
	li $t0, 2
	li $t1, 4
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8
	########################
	
	
	addi $sp, $sp, -4
   	
	li $a0, 0xffff0000
	li $a1, 5
	li $a2, 4
	li $a3, 2
	li $t0, 1
	
	sw $t0, 0($sp)
	jal shift_col

	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
   	
	li $a0, 0xffff0000
	li $a1, 5
	li $a2, 4
	li $a3, 2
	li $t0, 0
	
	sw $t0, 0($sp)
	jal shift_col

	addi $sp, $sp, 4
	
	########################PLACEING VALUES
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 6
	li $a2, 5
	li $a3, 3
	li $t0, 3
	li $t1, 1024
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 6
	li $a2, 5
	li $a3, 4
	li $t0, 3
	li $t1, 4
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 6
	li $a2, 5
	li $a3, 1
	li $t0, 0
	li $t1, 1024
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8
	addi $sp, $sp, -8
   	
	li $a0, 0xffff0000
	li $a1, 6
	li $a2, 5
	li $a3, 1
	li $t0, 1
	li $t1, 2
	
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place

	addi $sp, $sp, 8
	
	li $a0, 0xffff0000
	li $a1, 6
	li $a2, 5
	li $a3, 'U'
	jal user_move
	
	
.include "hw4.asm"	
