
##############################################################
# Homework #4
# name: AGNIESZKA GAWRYS
# sbuid: 111110966
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

clear_board:
    #Define your code here
	############################################
	move $t0, $a0 		#t0 = STARTING ADDRESS OF 2D ARRAY
	move $t1, $a1		# t1 = num ROWS
	move $t2, $a2		#t2 = num COLS
	li $t4, 0
	li $t5, 0
	li $t6, 0
	blt $t1, 2, returnError
	blt $t2, 2, returnError
	
calc_ending_address:
	li $t3, 2		#obj size
	mult $t2, $t3
	mflo $t4		#t4 = rowsize
	addi $t5, $t1, -1 	#num rows -1 = i
	mult $t4, $t5
	mflo $t5		#t5 = rowsize * i
	
	addi $t6, $t2, -1	#t6 = j (colnum =1)
	mult $t6, $t3
	mflo $t6 		#t6 = j * objsize
	
	add $t5, $t5, $t0	#starting address + (rowsize*i)
	add $t5, $t5, $t6	#t5 = ending address
	move $t4, $t0		#t4 = starting address
	li $t6, -1
clear_loop:
	sh $t6, ($t4)
	bge $t4, $t5, returnSuccess
	addi $t4, $t4, 2
	j clear_loop
returnError:
	li $v0, -1
	jr $ra
returnSuccess:
	li $v0, 0
	jr $ra

place:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	############################################
	addi $sp, $sp, -20
    	
    	sw $s0, 8($sp)
    	sw $s1, 12($sp)
    	sw $s2, 16($sp)
    	sw $s3, 20($sp)
    	sw $ra, 24($sp)
    	
    	move $s0, $a0		#starting address
    	move $s1, $a1		#num rows
    	move $s2, $a2		#num cols
    	move $s3, $a3		# row at which to put value
    				#t0 = col aat which to put value
    				#t1 = value to place
    	li $t2, 2
    	
    	blt $s1, $t2, returnError1
    	blt $s2, $t2, returnError1
   	
   	addi $t2, $s1, -1 	# t2 = rows -1
   	bgt $s3, $t2, returnError1
   	bltz $s3, returnError1
   	
   	addi $t3, $s2, -1	# t3 = cols -1
   	bgt $t0, $t3, returnError1
   	bltz $t0, returnError1
   	beq $t1, -1, place_value
   	li $t4, 2
   	blt $t1, $t4, returnError1
	# value is not -1 and not less than 2
	addi $t4, $t1, -1 	#value -1 = t4
	and $t4, $t4, $t1
	bnez $t4, returnError1 
	
place_value:
	#conditions were met   WANT starting addres + [(ncols * 2) * (t0-1)] + [2 * (t1-1)]
	li $t4, 2
	mult $t4, $s2		#row size = ncols * objsize
	mflo $t5
	#addi $t0, $t0, -1	# j= desired col - 1 
	#addi $s3, $s3, -1	# i = desired row - 1
	mult $t5, $s3	#row size * i
	mflo $t5
	mult $t4, $t0		# objsize * j
	mflo $t4
	
	add $t5, $t5, $s0	# address + (rowsize * i)
	add $t5, $t5, $t4	# + objsize*j = address where t place
	
	sh $t1, ($t5)
	j returnSuccess1
	
returnError1:
	li $v0, -1
	j returnComplete
returnSuccess1:
	li $v0, 0
	j returnComplete	
    	
returnComplete:
	lw $s0, 8($sp)
    	lw $s1, 12($sp)
        lw $s2, 16($sp)
    	lw $s3, 20($sp)
    	lw $ra, 24($sp)
    	addi $sp, $sp, 20
    	jr $ra

start_game:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	
	addi $sp, $sp, -32
    	
	sw $s0, ($sp)
    	sw $s1, 4($sp)
    	sw $s2, 8($sp)
    	sw $s3, 12($sp)
    	sw $s4, 16($sp)
    	sw $s5, 20($sp)
    	sw $s6, 24($sp)
    	sw $ra, 28($sp)
    	
    	move $s0, $a0	#Starting address of array
	move $s1, $a1	#number of rows
	move $s2, $a2	#number of columns
	move $s3, $a3	#r1
	move $s4, $t0	#c1
	move $s5, $t1	#r2
	move $s6, $t2	#c2
	
	jal clear_board # call clear board
	bnez $v0, returnError2
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	move $t0, $s4
	li $t1, 2
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	bnez $v0, returnError2
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s5
	move $t0, $s6
	li $t1, 2
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place
	addi $sp, $sp, 8
	bnez $v0, returnError2
	
	j returnSuccess2
	
returnError2:
	li $v0, -1
	j return2
returnSuccess2:
	li $v0, 0
	j return2
return2:
	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
    	lw $s3, 12($sp)
    	lw $s1, 16($sp)
        lw $s2, 20($sp)
    	lw $s3, 24($sp)
    	lw $ra, 28($sp)
    	addi $sp, $sp, 32
    	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

merge_row:
	lw $t0, 0($sp)		#t0 contains direction
	addi $sp, $sp, -16
    	
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
    	
    	move $s0, $a0		#starting address of cell board
    	move $s1, $a1		#num rows total
    	move $s2, $a2		# num cols total
    	move $s3, $a3		#row where to merge ( i)
    	
    	li $t1, 2
    	
    	blt $s1, $t1 returnError3 	#return error is total rows is less than 2
    	blt $s2, $t1 returnError3	# return error is total columns is less than 2
    	
    	addi $t1, $s1, -1
    	bgt $s3, $t1, returnError3 	#if row is not in the range [0, n-1]
    	bltz $s3 returnError3
    	
	li $t1, 1
	beqz $t0, merge_row_leftright	# is direction is zero go to LEFT T O RIGHT MERGE
	beq $t0, $t1 merge_row_rightleft# if direction is 1 got to RIGHT TO LEFT MERGE
    
	j returnError3
	
merge_row_leftright:
	#if direction is 0
	#calculate first cell of the desired row  = starting address + [ (n_cols * 2) * i ]
	li $t0, 2
	mult $t0, $s2		# 2 * n_cols
	mflo $t0
	mult $t0, $s3		# result * i
	mflo $t0
	add $t0, $t0, $s0	# starting address of row
	addi $t1, $a2, -1	#counter variable end case
	move $t5, $s2
	li $t2, 0		#counter variable
merge_loop_leftright:
	
	lh $t3, ($t0)
	addi $t0, $t0, 2	#increment address to get the next cell
	lh $t4, ($t0)
	beq $t3, -1 cell_neg_one_LR	# if both values are -1 they shouldnt be added !, just skip loop
	beq $t3, $t4, add_values_LR
	j finally_LR
add_values_LR:
	add $t3, $t3, $t3	#double the repeating value
	addi $t0, $t0, -2
	sh $t3, ($t0)
	addi $t0, $t0, 2
	li $t3, -1
	sh $t3, ($t0)
	addi $t5, $t5, -1
	
	j finally_LR
cell_neg_one_LR:
	addi $t5, $t5, -1	#empty cell so total num of values goes down by one
	j finally_LR
finally_LR:
	#address is already incremented no matter the case (neg 1, not same, or same)
	addi $t2, $t2, 1
	beq $t2, $t1, returnSuccess3
	j merge_loop_leftright
	#if adjecent cells equal
	
	
merge_row_rightleft:
	#id direction is 1
	li $t0, 2
	mult $t0, $s2		# 2 * n_cols
	mflo $t0
	mult $t0, $s3		# result * i
	mflo $t0
	li $t1, 2
	addi $t2, $s2, -1	# t2 = max cols -1 = j
	mult $t1, $t2
	mflo $t1
	add $t0, $t0, $s0	# starting address of row
	add $t0, $t1, $t0	#ending address of row
	
	addi $t1, $s2, -1	#counter variable end case
	move $t5, $s2
	li $t2, 0		#counter variable
merge_loop_rightleft:
	
	lh $t3, ($t0)
	addi $t0, $t0, -2	#increment address to get the next cell
	lh $t4, ($t0)
	beq $t3, -1 cell_neg_one_RL	# if both values are -1 they shouldnt be added !, just skip loop
	beq $t3, $t4, add_values_RL
	j finally_RL
add_values_RL:
	add $t3, $t3, $t3	#double the repeating value
	addi $t0, $t0, 2
	sh $t3, ($t0)
	addi $t0, $t0, -2
	li $t3, -1
	sh $t3, ($t0)
	addi $t5, $t5, -1
	
	j finally_RL
cell_neg_one_RL:
	addi $t5, $t5, -1	#empty cell so total num of values goes down by one
	j finally_RL
finally_RL:
	#address is already incremented no matter the case (neg 1, not same, or same)
	addi $t2, $t2, 1
	beq $t2, $t1, returnSuccess3
	j merge_loop_rightleft
	#if adjecent cells equal
returnSuccess3:
	move $v0, $t5
	j complete_return3 
returnError3:
  	li $v0, -1
  	j complete_return3
complete_return3:

	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
    	lw $s3, 12($sp)
    	addi $sp, $sp, 16
    ############################################
	jr $ra

merge_col:
    	lw $t0, 0($sp)		#t0 contains direction
	addi $sp, $sp, -16
    	
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
    	
    	move $s0, $a0		#starting address of cell board
    	move $s1, $a1		#num rows total
    	move $s2, $a2		# num cols total
    	move $s3, $a3		# col where to merge ( j)
    	
    	li $t1, 2
    	
    	blt $s1, $t1 returnError4 	#return error is total rows is less than 2
    	blt $s2, $t1 returnError4	# return error is total columns is less than 2
    	
    	addi $t1, $s2, -1
    	bgt $s3, $t1, returnError4 	#if row is not in the range [0, m-1]
    	bltz $s3 returnError4
    	
	li $t1, 1
	beqz $t0, merge_col_bottomtop	# is direction is zero go to BOTTOM TO TOP MERGE
	beq $t0, $t1 merge_col_topbottom# if direction is 1 got to TOP TO BOTTOM MERGE
    
	j returnError4
    ############################################BOTTOM TO TOP
merge_col_bottomtop:
	#if direction is 0
	#calculate first cell of the desired row  = starting address + [ (n_cols * 2) * i ]
	li $t0, 2
	mult $t0, $s3		# obj size * j (given param)
	mflo $t2
	mult $t0, $s2		#2 * ncols
	mflo $t7		#t7 = by how much to increment the address
	mult $t0, $s2		# 2 * ncols
	mflo $t0	
	addi $t1, $s1, -1	# i = s1 -1
	mult $t0, $t1		# result * i
	mflo $t0
	
	add $t0, $t0, $s0	# starting address of column
	add $t0, $t0, $t2	# ending address of the column
	
	addi $t1, $s1, -1	#counter variable end case
	move $t5, $s1		#max number of values in column
	li $t2, 0		#counter variable
	
merge_loop_BT:
	lh $t3, ($t0)
	sub  $t0, $t0, $t7	#increment address to get the next cell
	lh $t4, ($t0)
	beq $t3, -1 cell_neg_one_BT	# if both values are -1 they shouldnt be added !, just skip loop
	beq $t3, $t4, add_values_BT
	j finally_BT
add_values_BT:
	add $t3, $t3, $t3 	#double the value
	add $t0, $t0, $t7	#go to the col value below
	sh $t3, ($t0)		#store the doubled value at the bottom cell
	sub $t0, $t0, $t7	
	li $t3, -1
	sh $t3, ($t0)		#store neg 1 in the top value of the two
	addi $t5, $t5, -1
	
	j finally_BT
	
cell_neg_one_BT:
	addi $t5, $t5, -1	#empty cell so total num of values goes down by one
	j finally_BT
finally_BT:
	#address is already incremented no matter the case (neg 1, not same, or same)
	addi $t2, $t2, 1
	beq $t2, $t1, returnSuccess4
	j merge_loop_BT
	#if adjecent cells equal
    ############################################TOP TO BOTTOM
merge_col_topbottom:
		#if direction is 1
	#calculate first cell of the desired row  = starting address + [ (n_cols * 2) * i ]
	li $t0, 2
	mult $t0, $s3		# obj size * j (given param)
	mflo $t2
	mult $t0, $s2		#2 * nCOLS
	mflo $t7		#t7 = by how much to increment the address
	mult $t0, $s2		# 2 * ncols
	mflo $t0
	addi $t1, $s1, -1	# i = s1 -1
	mult $t0, $t1		# result * i
	mflo $t0
	
	add $t0, $t2, $s0	# starting address of column
	addi $t1, $s1, -1	#counter variable end case
	move $t5, $s1		#max number of values in column
	li $t2, 0		#counter variable
merge_loop_TB:
	lh $t3, ($t0)
	add  $t0, $t0, $t7	#increment address to get the next cell
	lh $t4, ($t0)
	beq $t3, -1 cell_neg_one_TB	# if both values are -1 they shouldnt be added !, just skip loop
	beq $t3, $t4, add_values_TB
	j finally_TB
add_values_TB:
	add $t3, $t3, $t3 	#double the value
	sub $t0, $t0, $t7	#go to the col value below
	sh $t3, ($t0)		#store the doubled value at the bottom cell
	add $t0, $t0, $t7	
	li $t3, -1
	sh $t3, ($t0)		#store neg 1 in the top value of the two
	addi $t5, $t5, -1
	
	j finally_TB
cell_neg_one_TB:
	addi $t5, $t5, -1	#empty cell so total num of values goes down by one
	j finally_TB
finally_TB:
	#address is already incremented no matter the case (neg 1, not same, or same)
	addi $t2, $t2, 1
	beq $t2, $t1, returnSuccess4
	j merge_loop_TB
returnSuccess4:
	move $v0, $t5
	j complete_return4 
returnError4:
  	li $v0, -1
  	j complete_return4
complete_return4:

	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
    	lw $s3, 12($sp)
    	addi $sp, $sp, 16
    ############################################
	jr $ra
	##################################
	##SHIFT ROW
	#################################
shift_row:
    	lw $t0, 0($sp)		#t0 contains direction
	addi $sp, $sp, -20
    	
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
    	sw $ra, 16($sp)
    	
    	move $s0, $a0		#starting address of cell board
    	move $s1, $a1		#num rows total
    	move $s2, $a2		# num cols total
    	move $s3, $a3		#row where to shift
    	
    	li $t1, 2
    	blt $s1, $t1 returnError5	#return error is total rows is less than 2
    	blt $s2, $t1 returnError5	# return error is total columns is less than 2
    	
    	addi $t1, $s1, -1
    	bgt $s3, $t1, returnError5 	#if row is not in the range [0, m-1]
    	bltz $s3 returnError5
    	
	li $t1, 1
	beqz $t0, shift_row_left	# is direction is zero go to LEFT SHIFT
	beq $t0, $t1 shift_row_right # if direction is 1 got to RIGHT SHIFT
	j returnError4
	
	
shift_row_left:
	move $a0, $s1
	move $a1, $s2
	move $a2, $s3		#args 2 = i 
	li $t1, 0
	move $a3, $t1		#let j = 0 , want the first col
	jal find_cell
	add $t1, $s0, $v0 	#starting address + return val = starting value of row
	move $s0, $t1
	addi $t2, $s2, -1		#stopping case for traversal
	li $t0, 0			#counter variable
	move $t3, $s2		#max num of elements shifted
	addi $t3, $t3, -1 	#first element cannot be shifted
	
shift_loop_left:	
	addi $t1, $t1, 2
	lh $t4, ($t1)
	beq $t4, -1 ,unshiftable_SL	# if value is neg one, cannot be shifted
	move $t7, $t1
	
shift_value_left:
	addi $t7, $t7, -2
	lh $t5, ($t7)
	bgtz $t5, unshiftable_SL	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	addi $t7, $t7, 2
	li $t6, -1
	sh $t6, ($t7)
	addi $t7, $t7, -4
	blt $t7, $s0, finally_SL
	addi $t7, $t7, 2
	j shift_multiple_left
	
shift_multiple_left:			# if multiple shifts must be done
	addi $t7, $t7, -2
	lh $t5, ($t7)
	bgtz $t5, finally_SL	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	addi $t7, $t7, 2
	li $t6, -1
	sh $t6, ($t7)
	addi $t7, $t7, -4
	blt $t7, $s0, finally_SL
	addi $t7, $t7, 2
	j shift_multiple_left
unshiftable_SL:
	addi $t3, $t3, -1	#value was not shifted
	j finally_SL
finally_SL:
	addi $t0, $t0, 1
	beq $t0, $t2, return_success5
	j shift_loop_left	

################################################################# shift RIGHT
shift_row_right:
	move $a0, $s1
	move $a1, $s2
	move $a2, $s3		#args 2 = i 
	move $t1, $s2		# let j = n cols
	addi $t1, $t1, -1	#j = ncol - 1
	move $a3, $t1		#let j = 0 , want the first col
	jal find_cell
	add $t1, $s0, $v0 	#starting address + return val = starting value of row
	move $s0, $t1
	addi $t2, $s2, -1		#stopping case for traversal
	li $t0, 0			#counter variable
	move $t3, $s2		#max num of elements shifted
	addi $t3, $t3, -1 	#first element cannot be shifted
	
shift_loop_right:	
	addi $t1, $t1, -2
	lh $t4, ($t1)
	beq $t4, -1 ,unshiftable_SR	# if value is neg one, cannot be shifted
	move $t7, $t1
	
shift_value_right:
	addi $t7, $t7, 2
	lh $t5, ($t7)
	bgtz $t5, unshiftable_SR	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	addi $t7, $t7, -2
	li $t6, -1
	sh $t6, ($t7)
	addi $t7, $t7, 4
	bgt $t7, $s0, finally_SR
	addi $t7, $t7, -2
	j shift_multiple_right
	
shift_multiple_right:
	addi $t7, $t7, 2
	lh $t5, ($t7)
	bgtz $t5, finally_SR	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	addi $t7, $t7, -2
	li $t6, -1
	sh $t6, ($t7)
	addi $t7, $t7, 4
	bgt $t7, $s0, finally_SR
	addi $t7, $t7, -2
	j shift_multiple_right
	
unshiftable_SR:
	addi $t3, $t3, -1	#value was not shifted
	j finally_SR
finally_SR:
	addi $t0, $t0, 1
	beq $t0, $t2, return_success5
	j shift_loop_right
returnError5:
	li $v0, -1
	j return_complete5
return_success5:
	move $v0, $t3
	j return_complete5
return_complete5:
	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
    	lw $s3, 12($sp)
    	lw $ra, 16($sp)
    	addi $sp, $sp, 20
    	jr $ra
    	
##########################################################
#SHIFT COLUMN
##########################################################
shift_col:
	lw $t0, 0($sp)		#t0 contains direction
	addi $sp, $sp, -20
    	
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
    	sw $ra, 16($sp)
    	
    	move $s0, $a0		#starting address of cell board
    	move $s1, $a1		#num rows total
    	move $s2, $a2		# num cols total
    	move $s3, $a3		#row where to shift
    	
    	li $t1, 2
    	blt $s1, $t1 returnError6	#return error is total rows is less than 2
    	blt $s2, $t1 returnError6	# return error is total columns is less than 2
    	
    	addi $t1, $s1, -1
    	bgt $s3, $t1, returnError6 	#if row is not in the range [0, m-1]
    	bltz $s3 returnError6
    	
	li $t1, 1
	beqz $t0, shift_col_up	# is direction is zero go to UP
	beq $t0, $t1 shift_col_down # if direction is 1 got to TOP
	j returnError6

shift_col_up:	#up starts at top and stores value farthest up
	move $a0, $s1
	move $a1, $s2
	li $t1, 0
	move $a2, $t1
	move $a3, $s3		#let j = 0 , want the first col
	jal find_cell
	
	li $t0, 2
	mult $t0, $s2		# ncols*2
	mflo $t8		#increment by obj size * n 
	add $t1, $s0, $v0 	#starting address + return val = first column value
	move $s0, $t1
	addi $t2, $s1, -1		#stopping case for traversal (now rows -1 )
	li $t0, 0			#counter variable
	move $t3, $s1		#max num of elements shifted
	addi $t3, $t3, -1 	#first element cannot be shifted
	
shift_loop_up:	
	add $t1, $t1, $t8
	lh $t4, ($t1)
	beq $t4, -1 ,unshiftable_SU	# if value is neg one, cannot be shifted
	move $t7, $t1
	
shift_value_up:
	sub $t7, $t7, $t8
	lh $t5, ($t7)
	bgtz $t5, unshiftable_SU	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	add $t7, $t7, $t8
	li $t6, -1
	sh $t6, ($t7)
	li $t9, 2
	mult $t9, $t8
	mflo $t9
	sub $t7, $t7, $t9
	blt $t7, $s0, finally_SU
	add $t7, $t7, $t8
	j shift_multiple_up
	
shift_multiple_up:			# if multiple shifts must be done
	sub $t7, $t7, $t8
	lh $t5, ($t7)
	bgtz $t5, finally_SU	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	add $t7, $t7, $t8
	li $t6, -1
	sh $t6, ($t7)
	li $t9, 2
	mult $t8, $t9		#increment address times 2
	mflo $t9
	sub $t7, $t7, $t9
	blt $t7, $s0, finally_SU
	add $t7, $t7, $t8
	j shift_multiple_up
unshiftable_SU:
	addi $t3, $t3, -1	#value was not shifted
	j finally_SU
finally_SU:
	addi $t0, $t0, 1
	beq $t0, $t2, return_success6
	j shift_loop_up	
###########################################################################################END OF SHIFT UP
shift_col_down:	#starts at bottom and sotres value farthest down
	#up starts at top and stores value farthest up
	move $a0, $s1
	move $a1, $s2
	addi $t1, $s1, -1	#nrow -1 
	move $a2, $t1
	move $a3, $s3		
	jal find_cell
	
	li $t0, 2
	mult $t0, $s2		# ncols*2
	mflo $t8		#increment by obj size * n 
	add $t1, $s0, $v0 	#starting address + return val = first column value
	move $s0, $t1
	addi $t2, $s1, -1		#stopping case for traversal (now rows -1 )
	li $t0, 0			#counter variable
	move $t3, $s1		#max num of elements shifted
	addi $t3, $t3, -1 	#first element cannot be shifted
	
shift_loop_down:	
	sub $t1, $t1, $t8
	lh $t4, ($t1)
	beq $t4, -1 ,unshiftable_SD	# if value is neg one, cannot be shifted
	move $t7, $t1
	
shift_value_down:
	add $t7, $t7, $t8
	lh $t5, ($t7)
	bgtz $t5, unshiftable_SD	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	sub $t7, $t7, $t8
	li $t6, -1
	sh $t6, ($t7)
	li $t9, 2
	mult $t8, $t9		#increment address times 2
	mflo $t9
	add $t7, $t7, $t9
	bgt $t7, $s0, finally_SD
	sub $t7, $t7, $t8
	j shift_multiple_down
	
shift_multiple_down:			# if multiple shifts must be done
	add $t7, $t7, $t8
	lh $t5, ($t7)
	bgtz $t5, finally_SD	# if adjacent value is not -1, cannot be shifted 
	sh $t4, ($t7)
	sub $t7, $t7, $t8
	li $t6, -1
	sh $t6, ($t7)
	li $t9, 2
	mult $t8, $t9		#increment address times 2
	mflo $t9
	add $t7, $t7, $t9
	bgt $t7, $s0, finally_SD
	sub $t7, $t7, $t8
	j shift_multiple_down
unshiftable_SD:
	addi $t3, $t3, -1	#value was not shifted
	j finally_SD
finally_SD:
	addi $t0, $t0, 1
	beq $t0, $t2, return_success6
	j shift_loop_down
returnError6:
	li $v0, -1
	j return_complete6
return_success6:
	move $v0, $t3
	j return_complete6
return_complete6:
	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
    	lw $s3, 12($sp)
    	lw $ra, 16($sp)
    	addi $sp, $sp, 20
    	jr $ra 	
############################################
#CHECK STATE
#############################################
check_state:
    addi $sp, $sp, -16
    	
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
    	sw $ra, 12($sp)
    	
    	move $s0, $a0		#starting address of cell board
    	move $s1, $a1		#num rows total
    	move $s2, $a2		# num cols total
    	move $s3, $a3		#row where to shift
    	move $a0, $s1
    	move $a1, $s2
    	addi $a2, $s1, -1
    	addi $a3, $s2, -1
    	jal find_cell		#find the max address
    	move $t0, $s0		#t0 = starting address = s0
    	add $t1, $s0, $v0	#t1 = ending address 
	li $t2, 2048		#to check if the game is won
	mult $s1, $s2		
	mflo $t4		#max amount of elements in the board
	li $t5, 0
	j loop_2048_check
empty_cell_inc:
	addi $t5, $t5, 1
	j loop_2048_check
loop_2048_check:
	lh $t3, ($t0)
	beq $t3, $t2, game_won
	addi $t0, $t0, 2
	bltz $t3, empty_cell_inc
	ble $t0, $t1, loop_2048_check
	bgtz $t5, game_not_done
	li $t5, 0
	li $t4, 0
	li $t3, 0
	li $t2, 0	#clear up these variables
	addi $t7, $s2, -1		#ncols -1
	move $t0, $s0
	j merge_row_check
next_row_check:
	addi $t0, $t0, 2	#dont want to check the ending values no diagonals
	li $t5, 0
	bgt $t0, $t1, merge_col_preloop
	j merge_row_check
merge_row_check:
	lh $t2, ($t0)
	addi $t0, $t0, 2
	lh $t3, ($t0)
	addi $t5, $t5, 1
	beq $t2, $t3, game_not_done
	beq $t5, $t7, next_row_check
	blt $t0, $t1, merge_row_check
	
merge_col_preloop:	#no mergable rows, all spaces filled, must check cols
	 move $t0, $s0		#original address
	 li $t2, 2
	 mult $t2, $s2		#ncols * 2
	 mflo $t2		#how much to increment by 
	 li $t5, 0		#counter variable
	 addi $t6, $s1, -1	#nrows -1 is how many elements in each col must be checked
	 li $t7, 0
	 
	 
merge_col_check:
	lh $t3, ($t0)
	add $t0, $t0, $t2	#cell below
	lh $t4, ($t0)
	addi $t5, $t5, 1
	beq $t3, $t4, game_not_done
	bne $t5, $t6, merge_col_check
	move $t0, $s0
	li $t5, 0
	addi $t7, $t7, 1		#j = current col * 2
	li $t3, 2
	mult $t3, $t7
	mflo $t8
	add $t0 $t0 $t8			#new starting address
	addi $t4, $s1, -1
	mult $t3, $t4
	mflo $t3
	add $t4, $t3, $s0		#starting address of the last column
	bgt $t0, $t4, game_lost
	j merge_col_check
    ############################################
game_won:
	li $v0, 1
	j return_complete7
game_lost:
	li $v0, -1
	j return_complete7
game_not_done:
	li $v0, 0
	j return_complete7
return_complete7:
	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
    	lw $ra, 12($sp)
    	addi $sp, $sp, 16
    	jr $ra 	

user_move:
    	addi $sp, $sp, -24
    	
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
    	sw $ra, 20($sp)
    	
    	move $s0, $a0		#starting address of cell board
    	move $s1, $a1		#num rows total
    	move $s2, $a2		# num cols total
    	move $s3, $a3		#char direction
   	li $s4, 0		#counter variable
   	li $t0, 'L'
   	beq $t0, $s3, user_move_left
   	li $t0, 'R'
   	beq $t0, $s3, user_move_right
   	li $t0, 'U'
   	beq $t0, $s3, user_move_up
   	li $t0, 'D'
   	beq $t0, $s3, user_move_down
   	j returnError8
user_move_left:
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 0
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_row
	addi $sp, $sp, 4
	bltz $v0, returnError8
	###################MERGE ROW FOR LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 0
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal merge_row
	addi $sp, $sp, 4
	bltz $v0, returnError8
	#####################SHIFT ROW LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 0
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_row
	addi $sp, $sp, 4
	bltz $v0, returnError8
	
	addi $s4, $s4, 1
	beq $s4, $s1, enter_check_state
	j user_move_left
	
user_move_right:
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4		# num cols total
    	li $t0, 1
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_row
	addi $sp, $sp, 4
	bltz $v0, returnError8
	###################MERGE ROW FOR LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 1
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal merge_row
	addi $sp, $sp, 4
	bltz $v0, returnError8
	#####################SHIFT ROW LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 1
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_row
	addi $sp, $sp, 4
	bltz $v0, returnError8
	
	addi $s4, $s4, 1
	beq $s4, $s1, enter_check_state
	j user_move_right
user_move_up:
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 0
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_col
	addi $sp, $sp, 4
	bltz $v0, returnError8
	###################MERGE ROW FOR LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 0
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal merge_col
	addi $sp, $sp, 4
	bltz $v0, returnError8
	#####################SHIFT ROW LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 0
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_col
	addi $sp, $sp, 4
	bltz $v0, returnError8
	
	addi $s4, $s4, 1
	beq $s4, $s2, enter_check_state
	j user_move_up
	
user_move_down:
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4		# num cols total
    	li $t0, 1
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_col
	addi $sp, $sp, 4
	bltz $v0, returnError8
	###################MERGE ROW FOR LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 1
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal merge_col
	addi $sp, $sp, 4
	bltz $v0, returnError8
	#####################SHIFT ROW LEFT
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	move $a3, $s4
    	li $t0, 1
    	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal shift_col
	addi $sp, $sp, 4
	bltz $v0, returnError8
	
	addi $s4, $s4, 1
	beq $s4, $s2, enter_check_state
	j user_move_down
   	
enter_check_state:
	move $a0, $s0		#starting address of cell board
    	move $a1, $s1		#num rows total
    	move $a2, $s2		# num cols total
    	jal check_state
    	move $v1, $v0
    	li $v0, 0
    	j complete_return8 
returnError8:
	li $v0, -1
	li $v1, -1
	j complete_return8    
complete_return8:
	lw $s0, ($sp)
    	lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
    	lw $s4, 16($sp)
    	lw $ra, 20($sp)
    	addi $sp, $sp, 24
    	jr $ra 	

find_cell:
	move $t0, $a0	#num rows
	move $t1, $a1	#num cols
	move $t2, $a2	# i  (0, n-1)
	move $t3, $a3	# j  (0, m-1)
	
	li $t4, 2	#obj size
	mult $t1, $t4	#row size = ncols* 2
	mflo $t5
	mult $t5, $t2	# row size * i
	mflo $t5
	mult $t3, $t4	# obj size * j 
	mflo $t4
	
	add $t4, $t5, $t4	# add this value to the starting address to get [i][j] 
	move $v0, $t4
	
	jr $ra
	
#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


