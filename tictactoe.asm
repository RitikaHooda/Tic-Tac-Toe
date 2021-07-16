## Instructions:
## Open Bitmap Display
## Bitmap Settings:
## Unit Width in Pixels: 1
## Unit Height in Pixels: 1
## Display Width in Pixels: 256
## Display Height in Pixels: 256
## Base address for display: 0x10010000 (static data)
##
## NOTE:
## Player 1 : X
## Player 2 : O

##### The positions entered by players will be interpreted as follows on the board:
##### 7 | 8 | 9th
##### 4 | 5 | 6th
##### 1 | 2 | 3


### The following data has been saved to kdata to avoid conflict with the .data positions that were used to draw the interface. 
.data 
	values:		 .word  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 
        #Valores of rolls ( 1 = x , 2 = 0 )         
	description: .asciiz "OLD GAME! The first player to form a diagonal, vertical or horizontal sequence wins. \ n"	
	enterPosition: .asciiz "Enter a position [1 - 9]:"	
	invalidin_msg: .asciiz " Invalid position ! \ n"
	player1_msg: .asciiz "Enter a position player 1:"
	player2_msg: .asciiz "Enter a position player 2:"
	fimjogadas_msg: .asciiz "Gave old! \ n"
	Player1vivedu_msg: .asciiz "Player 1 won! \ n"
	Player2vivedu_msg: .asciiz "Player 2 won! \ n"
	play_again_msg: .asciiz "Do you want to play again? \ n"
	
.text
.globl main
main:

	#Charges core values
	la  $s0, values            # VALUE ADDRESS
	li  $s1 , 1 #GAME COUNTER 

	#Display initial message
	li  $v0, 4 
	la  $a0 , description
	syscall
	
	#Load tray
	jal prints_board
	nop
	
player_play1:
	#Quest player play1
	li  $v0 , 4 
	la  $a0 , player1_msg
	syscall
	
	#Read Player 1's Play
	li  $v0 , 5 
	syscall
	move  $a0 ,  $v0
	#Save on s2 the move
	move  $s2 ,  $v0
	
	#Jump to check if play is valid
	jal check_play_valida
	nop
	beq  $v0 , 1 , move_validated 
	nop
	#If the move is not valid displays message and rereads
	li  $v0 , 4 
	la  $a0 , positioninvalida_msg
	syscall
	j player_play1
	nop
	#If the play was valid it records the play in memory and draws in the bitmap
move_validated:
	li  $a0 , 1 
	jal registrar_player
	nop
	move  $a2 ,  $s2 #Move to a2 the position to draw on the bitmap
	jal draws_xis
	nop

##### HERE GO CHECKS #####
	li  $v1 , 0 
	#Jump to check if he won
	jal check_player1_won
	nop
	beq  $v1 , 1 , end 
	nop
	#Jump to check if moves> 9
	jal check_game_player
	nop
	beq  $v1 , 1 , end 
	nop

#############################
player_play2:
	#Question2
	li  $v0 , 4 
	la  $a0 , player2_msg
	syscall
	
	#The player2 play
	li  $v0 , 5 
	syscall
	move  $a0 ,  $v0
	move  $s3 ,  $v0 #S3 save at move pos
	jal check_play_valida
	nop
	beq  $v0 , 1 , move_validated2 
	nop
	li  $v0 , 4 
	la  $a0 , positioninvalida_msg
	syscall
	j player_play2
	nop
	
play_was_validated2:
	li  $a0 , 2 
	jal registrar_player
	nop
	move  $a2 ,  $s3
	jal draws_y
	nop
	
##### PART TWO CHECKS #######
	li  $v1 , 0 

	jal check_player2_won
	nop
	beq  $v1 , 1 , end 
	nop

	jal check_game_player
	nop
	beq  $v1 , 1 , end 
	nop
	
	j player_play1
	nop	
	
#### HERE GO CHECKS ####	
			
end:
	li  $v0 , 50 
	la  $a0 , play_again_msg
	syscall
	
	beq  $a0 , 0 , zerar_tudo 
	nop

	li  $v0 , 10 
	syscall
				
					
						
							
									
############## PRINT TRAY ################################## #####################	
board_print:
# Passing the desired color into hexadecimal
li  $t1 , 0x00FF00 
#Initial address where it will be drawn
lui  $t0 , 0x1001 
# 1024 x 80 is the vertical distance from the beginning of the bitmap and where the first pixel will be drawn
li  $t5 , 1024 
li  $t6 , 80 
mult  $t5 ,  $t6
mflo  $t6
#VERTICAL
add  $t0 ,  $t0 ,  $t6
#HORIZONTAL
# Sum of initial address with 56 means increment by 56 pixels horizontal distance
addi  $t0 ,  $t0 , 56 
# counter
li  $t2 , 0 
first_horizontal_line:
	# STORE COLOR AT WISHED ADDRESS
	sw  $t1 , 0 ( $t0) 
	# INCREASING 4 IN 4 TO GO RIGHT
	addi  $t0 ,  $t0 , 4 
	# INCREASE COUNTER
	addi  $t2 ,  $t2 , 1 
	bne  $t2 , 224 , primeira_linha_horizontal 
	nop
	
#Change position to second line
lui  $t0 , 0x1001 
li  $t5 , 1024 
li  $t6 , 150 
mult  $t5 ,  $t6
mflo  $t6
#VERTICAL
add  $t0 ,  $t0 ,  $t6
#Horizontal
addi  $t0 ,  $t0 , 56 
li  $t2 , 0 
second_horizontal_line:
	sw  $t1 , 0 ( $t0) 
	addi  $t0 ,  $t0 , 4 
	addi  $t2 ,  $t2 , 1 
	bne  $t2 , 224 , second_horizontal_line 
	nop
# Draw vertical lines
lui  $t0 , 0x1001 
li  $t6 , 10 
mult  $t5 ,  $t6
mflo  $t6
#VERTICAL
add  $t0 ,  $t0 ,  $t6
#HORIZONTAL
addi  $t0 ,  $t0 , 320 
li  $t2 , 0 
first_vertical_line:
	addi  $t0 ,  $t0 , 1024 
	sw  $t1 , 0 ( $t0) 
	addi  $t2 ,  $t2 , 1 
	bne  $t2 , 200 , primeira_linha_vertical 
	nop
	
lui  $t0 , 0x1001 
#HORIZONTAL
addi  $t0 ,  $t0 , 660 
li  $t2 , 0 
#vertical
li  $t6 , 10 
mult  $t5 ,  $t6
mflo  $t6
add  $t0 ,  $t0 ,  $t6
second_vertical_line:
	addi  $t0 ,  $t0 , 1024 
	sw  $t1 , 0 ( $t0) 
	addi  $t2 ,  $t2 , 1 
	bne  $t2 , 200 , segunda_linha_vertical 
	nop


	jr  $ra
	nop

################################################## #######################################




#################### CHECK VALID PLAY ########################## #

check_play_valida:
	#Know if number is> = 1
	move  $t0 ,  $a0
	bge  $t0 , 1 , expiration_1 
	nop
	j alreadyinvalid
	nop

	#Know if number is <= 9	
validity_1:
	ble  $t0 , 9 , validity_2 
	nop
	j alreadyinvalid
	nop
	
validity_2:
	#Know if field has already been filled
	subu  $t1 ,  $t0 , 1 
	li  $t2 , 4 #tamanho the word 
	mult  $t1 ,  $t2
	mflo  $t3
	la  $t4 , values
	add  $t4 ,  $t4 ,  $t3
	lw  $t5 , 0 ( $t4) # $t5 Loads memory value for player selected position  
	beq  $t5 ,  $0 , valid_play # If the field in memory is 0 , the play is valid
	nop
	j alreadyinvalid
	nop
	
	#If the play is invalid returns 0
invalid_play:	
	li  $v0 , 0 
	jr  $ra
	nop
	#If the play is valid returns 1
valid_play:
	li  $v0 , 1 
	jr  $ra
	nop
	
################################################## #################################



####################### VALIDATED PLAY ######################### ###################
register_player:
	#If a0 = 1 move made by player1 , if a0 = 2 move made by player2
	beq  $a0 , 1 , play_made_by_player1 
	nop
	beq  $a0 , 2 , play_made_by_player2 
	nop

played_by_player1:
	addi  $s1 ,  $s1 , 1 #Increments play count 
	la  $t0 , values
	li  $t1 , 1 
	li  $t2 , 4 
	move  $t3 ,  $s2
	subu  $t3 ,  $t3 , 1 
	mult  $t3 ,  $t2
	mflo  $t4
	add  $t0 ,  $t0 ,  $t4
	sw  $t1 , 0 ( $t0) 
	jr  $ra
	nop
	
 played_by_player2:
	addi  $s1 ,  $s1 , 1 #Increments play count 
	la  $t0 , values
	li  $t1 , 2 
	li  $t2 , 4 
	move  $t3 ,  $s3
	subu  $t3 ,  $t3 , 1 
	mult  $t3 ,  $t2
	mflo  $t4
	add  $t0 ,  $t0 ,  $t4
	sw  $t1 , 0 ( $t0) 
	jr  $ra
	nop
	
################################################## ####################################

############# CHECK OUT OF PLAY ################################ ################
check_of_players:	
	li  $t0 , 10 
	beq  $s1 ,  $t0 , end_of_players
	nop
	
	li  $v1 , 0 
	jr  $ra
	nop
	
end_of_games:

	li  $v0 , 4 
	la  $a0 , fimjogadas_msg
	syscall
	
	li  $v1 , 1 
	jr  $ra
	nop
	
################################################## ###################################


################# CHECK PLAYER 1 WON ############################# #############
# If a sequence of 1 , 1 , 1 is found in memory for a horizontal , vertical or diagonal line , then player1 has won.
check_player1_won:
	la  $t0 , values
	lw  $t1 , 0 ( $t0) 
	lw  $t2 , 4 ( $t0) 
	lw  $t3 , 8 ( $t0) 
	
first_player_attempt1:
	beq  $t1 , 1 , player1_ valid1 
	nop
	j second attempt
	nop
valid1_player1:
	beq  $t2 , 1 , player1_ valid2 
	nop
	j second attempt
	nop
player1_valido2:
	beq  $t3 , 1 , player1_ won 
	nop
	j second attempt
	nop
second attempt:
	lw  $t1 , 12 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 20 ( $t0) 
	beq  $t1 , 1 , player1_ valid1_second 
	nop
	j third attempt
	nop
player1_valido1_second:
	beq  $t2 , 1 , player1_ valid2_second 
	nop
	j third attempt
	nop
player1_valido2_second:
	beq  $t3 , 1 , player1_ won 
	nop
	j third attempt
	nop
third_attempt:
	lw  $t1 , 24 ( $t0) 
	lw  $t2 , 28 ( $t0) 
	lw  $t3 , 32 ( $t0) 
	beq  $t1 , 1 , player1_valid1_ third 
	nop
	j fourth attempt
	nop
player1_valido1_third:
	beq  $t2 , 1 , player1_ valid2_3rd 
	nop
	j fourth attempt
	nop
player1_valido2_third:
	beq  $t3 , 1 , player1_ won 
	nop
	j fourth attempt
	nop
fourth attempt: #TEST THE VERTICALS NOW
	lw  $t1 , 0 ( $t0) 
	lw  $t2 , 12 ( $t0) 
	lw  $t3 , 24 ( $t0) 
	beq  $t1 , 1 , player1_valid1_four 
	nop
	j fifth attempt
	nop
player1_valido1_quarta:
	beq  $t2 , 1 , player1_ valid2_four 
	nop
	j fifth attempt
	nop
player1_valido2_quarta:
	beq  $t3 , 1 , player1_ won 
	nop
	j fifth attempt
	nop
fifth_attempt:
	lw  $t1 , 4 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 28 ( $t0) 
	beq  $t1 , 1 , player1_flight1_fifth 
	nop
	j Friday attempt
	nop
player1_valido1_fifth:
	beq  $t2 , 1 , player1_ valid2_fifth 
	nop
	j Friday attempt
	nop
player1_valido2_fifth:
	beq  $t3 , 1 , player1_ won 
	nop
	j Friday attempt
	nop
sixth attempt:
	lw  $t1 , 8 ( $t0) 
	lw  $t2 , 20 ( $t0) 
	lw  $t3 , 32 ( $t0) 
	beq  $t1 , 1 , player1_valid1_sex 
	nop
	j attempt
	nop
Player1_ Valid1_ Friday:
	beq  $t2 , 1 , player1_valido2_sexta 
	nop
	j attempt
	nop
player1_valido2_sexth:
	beq  $t3 , 1 , player1_ won 
	nop
	j attempt
	nop
seventh_attempt: #test diagonals now
	lw  $t1 , 0 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 32 ( $t0) 
	beq  $t1 , 1 , player1_valid1_setima 
	nop
	j attempted_ octave
	nop
player1_valido1_setima:
	beq  $t2 , 1 , player1_ valid2_setima 
	nop
	j attempted_ octave
	nop
Player1_valido2_setima:
	beq  $t3 , 1 , player1_ won 
	nop
	j attempted_ octave
	nop
eighth attempt:
	lw  $t1 , 8 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 24 ( $t0) 
	beq  $t1 , 1 , player1_valido1_itava 
	nop
	j player1_nao_won
	nop
player1_valido1_itava:
	beq  $t2 , 1 , player1_valido2_itava 
	nop
	j player1_nao_won
	nop
player1_valido2_oitava:
	beq  $t3 , 1 , player1_ won 
	nop
	j player1_nao_won
	nop
Player1_nao_won:
	li  $v1 , 0 
	jr  $ra
	nop
Player1_Won:
	li  $a1 , 1 
	li  $v0 , 55 
	la  $a0 , player1 won_msg
	syscall

	li  $v1 , 1 
	jr  $ra
	nop
	
################################################## ##################################


############### CHECK PLAYER 2 WON ############################## #############
# If a sequence of 1 , 1 , 1 is found in memory for a horizontal , vertical or diagonal line , then player2 has won.
check_player2_won:
	la  $t0 , values
	lw  $t1 , 0 ( $t0) 
	lw  $t2 , 4 ( $t0) 
	lw  $t3 , 8 ( $t0) 
	
first_player_treatment2:
	beq  $t1 , 2 , valid_2 player 
	nop
	j second_treatment_j2
	nop
valid2 player:
	beq  $t2 , 2 , valid_2 player2 
	nop
	j second_treatment_j2
	nop
player2_valido2:
	beq  $t3 , 2 , player2_won 
	nop
	j second_treatment_j2
	nop
second_treatment_j2:
	lw  $t1 , 12 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 20 ( $t0) 
	beq  $t1 , 2 , player2_ valid1_second 
	nop
	j third_treatment_j2
	nop
player2_valido1_second:
	beq  $t2 , 2 , player2_ valid2_second 
	nop
	j third_treatment_j2
	nop
player2_valido2_second:
	beq  $t3 , 2 , player2_won 
	nop
	j third_treatment_j2
	nop
third_treatment_j2:
	lw  $t1 , 24 ( $t0) 
	lw  $t2 , 28 ( $t0) 
	lw  $t3 , 32 ( $t0) 
	beq  $t1 , 2 , player2_flight1_third 
	nop
	j fourth attempt_j2
	nop
player2_valido1_third:
	beq  $t2 , 2 , player2_ valid2_3rd 
	nop
	j fourth attempt_j2
	nop
player2_valido2_third:
	beq  $t3 , 2 , player2_won 
	nop
	j fourth attempt_j2
	nop
fourth_treatment_j2:
	lw  $t1 , 0 ( $t0) 
	lw  $t2 , 12 ( $t0) 
	lw  $t3 , 24 ( $t0) 
	beq  $t1 , 2 , player2_ valid1_four 
	nop
	j quinta_tativa_j2
	nop
player2_valido1_quarta:
	beq  $t2 , 2 , player2_ valid2_four 
	nop
	j quinta_tativa_j2
	nop
player2_valido2_quarta:
	beq  $t3 , 2 , player2_won 
	nop
	j quinta_tativa_j2
	nop
tentative_j2:
	lw  $t1 , 4 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 28 ( $t0) 
	beq  $t1 , 2 , player2_flight1_fifth 
	nop
	j Friday_attractive_j2
	nop
player2_valido1_fifth:
	beq  $t2 , 2 , player2_ valid2_five 
	nop
	j Friday_attractive_j2
	nop
player2_valido2_fifth:
	beq  $t3 , 2 , player2_won 
	nop
	j Friday_attractive_j2
	nop
Friday_treatment_j2:
	lw  $t1 , 8 ( $t0) 
	lw  $t2 , 20 ( $t0) 
	lw  $t3 , 32 ( $t0) 
	beq  $t1 , 2 , player2_valido1_sexta 
	nop
	j setima_tentativa_j2
	nop
player2_valido1_sexth:
	beq  $t2 , 2 , player2_ valid2_sex 
	nop
	j setima_tentativa_j2
	nop
player2_valido2_sexth:
	beq  $t3 , 2 , player2_won 
	nop
	j setima_tentativa_j2
	nop
attempt_jima:
	lw  $t1 , 0 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 32 ( $t0) 
	beq  $t1 , 2 , player2_valid1_setima 
	nop
	j attempted_tave_j2
	nop
Player2_valido1_setima:
	beq  $t2 , 2 , player2_ valid2_setima 
	nop
	j attempted_tave_j2
	nop
Player2_valido2_setima:
	beq  $t3 , 2 , player2_won 
	nop
	j attempted_tave_j2
	nop
octave_attractive_j2:
	lw  $t1 , 8 ( $t0) 
	lw  $t2 , 16 ( $t0) 
	lw  $t3 , 24 ( $t0) 
	beq  $t1 , 2 , player2_valido1_itava 
	nop
	j player2_nao_ won
	nop
Player2_valido1_oitava:
	beq  $t2 , 2 , player2_valido2_itava 
	nop
	j player2_nao_ won
	nop
Player2_valido2_oitava:
	beq  $t3 , 2 , player2_won 
	nop
	j player2_nao_ won
	nop
Player2_nao_won:
	li  $v1 , 0 
	jr  $ra
	nop
Player2_Won:
	li  $a1 , 1 
	li  $v0 , 55 
	la  $a0 , player2won_msg
	syscall
	li  $v1 , 1 
	jr  $ra
	nop
################################################## #################################



######### DRAW X ####################
draw_xis:

	li  $t1 , 0x00FF00 
	lui  $t0 , 0x1001 
	ori  $t2 ,  $0 , 0 

##### The positions entered by players will be interpreted as follows on the board:
##### 7 | 8 | 9th
##### 4 | 5 | 6th
##### 1 | 2 | 3

beq  $a2 , 1 , xis_sete 
nop

beq  $a2 , 2 , xis_oito 
nop

beq  $a2 , 3 , xis_nove 
nop

beq  $a2 , 4 , xis_quatro 
nop

beq  $a2 , 5 , xis_cinco 
nop

beq  $a2 , 6 , xis_seis 
nop

beq  $a2 , 7 , xis_um 
nop

beq  $a2 , 8 , xis_dois 
nop

beq  $a2 , 9 , xis_tres 
nop

xis_um:	
	#VERTICAL
	I li  $t3 , 30 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	addi  $t0 ,  $t0 , 140 
	j first_line
	nop
	
xis_dois:
	#VERTICAL
	I li  $t3 , 30 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	addi  $t0 ,  $t0 , 440 	
	j first_line
	nop	
xis_tres:
	#VERTICAL
	I li  $t3 , 30 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	add  $t0 ,  $t0 , 760 
	j first_line
	nop	
xis_quatro:
	#VERTICAL
	li  $t3 , 100 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	add  $t0 ,  $t0 , 140 	
	j first_line
	nop
xis_cinco:
	#VERTICAL
	li  $t3 , 100 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	add  $t0 ,  $t0 , 440 
	j first_line
	nop
xis_seis:
	#VERTICAL
	li  $t3 , 100 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	add  $t0 ,  $t0 , 760 
	j first_line
	nop	
xis_sete:
	#VERTICAL
	li  $t3 , 170 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	addi  $t0 ,  $t0 , 140 
	j first_line
	nop
xis_oito:
	#VERTICAL
	li  $t3 , 170 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	add  $t0 ,  $t0 , 440 
	j first_line
	nop
xis_nove:
	#VERTICAL
	li  $t3 , 170 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	#HORIZONTAL
	add  $t0 ,  $t0 , 760 
	j first_line
	nop
	
first line:
	addi  $t0 ,  $t0 , 1024 
	addi  $t0 ,  $t0 , 4 
	sw  $t1 , 0 ( $t0) 
	addi  $t2 ,  $t2 , 1 
	bne  $t2 , 30 , primeira_linha 
	nop
	subu  $t0 ,  $t0 , 120 
	ori  $t2 ,  $0 , 0 
second line:
	sub  $t0 ,  $t0 , 1024 
	addi  $t0 ,  $t0 , 4 
	sw  $t1 , 0 ( $t0) 
	addi  $t2 ,  $t2 , 1 	
	bne  $t2 , 30 , segunda_linha 
	nop
	jr  $ra
	nop

# - END DRAW X - #

####### DRAW 0 ###########
draw_y:
				
	li  $t1 , 0x00FF00 	
	lui  $t0 , 0x1001 
	ori  $t2 ,  $0 , 0 

beq  $a2 , 1 , y_sete 
nop

beq  $a2 , 2 , y_oito 
nop

beq  $a2 , 3 , y_nove 
nop

beq  $a2 , 4 , y_quatro 
nop

beq  $a2 , 5 , y_cinco 
nop

beq  $a2 , 6 , y_seis 
nop

beq  $a2 , 7 , y_um 
nop

beq  $a2 , 8 , y_dois 
nop

beq  $a2 , 9 , y_tres 
nop

y_um:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 120 
	#VERTICAL
	I li  $t3 , 30 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop

y_dois:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 420 
	#VERTICAL
	I li  $t3 , 30 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_tres:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 740 
	#VERTICAL
	I li  $t3 , 30 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_four:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 120 
	#VERTICAL
	li  $t3 , 100 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_cinco:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 420 
	#VERTICAL
	li  $t3 , 100 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_seis:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 740 
	#VERTICAL	
	li  $t3 , 100 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_sete:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 120 
	#VERTICAL
	li  $t3 , 170 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_oito:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 420 
	#VERTICAL
	li  $t3 , 170 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
y_nove:
	#HORIZONTAL
	addi  $t0 ,  $t0 , 740 
	#VERTICAL
	li  $t3 , 170 
	li  $t4 , 1024 
	mult  $t3 ,  $t4
	mflo  $t5
	add  $t0 ,  $t0 ,  $t5
	j draw_y
	nop
	
draw_y:	
	second part:
		addi  $t0 ,  $t0 , 108 
		addi  $t0 ,  $t0 , 30720 
		li  $t 2 , 0 
	second_line:
		sw  $t1 , 0 ( $t0) 
		subu  $t0 ,  $t0 , 4 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 15 , segunda_linha_h 
		nop
	third part:
		ori  $t2 ,  $0 , 0 
	first_diagonal:
		sw  $t1 , 0 ( $t0) 
		subu  $t0 ,  $t0 , 1024 
		sub  $t0 ,  $t0 , 4 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 9 , primeira_diagonal 
		nop
	fourth part:
		ori  $t2 ,  $0 , 0 
	first_line:
		sw  $t1 , 0 ( $t0)	 
		subu  $t0 ,  $t0 , 1024 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 15 , primeira_linha_v 
		nop
	fifth part:
		ori  $t2 ,  $0 , 0 
	second_diagonal:
		sw  $t1 , 0 ( $t0) 
		addi  $t0 ,  $t0 , 4 
		subu  $t0 ,  $t0 , 1024 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 9 , segunda_diagonal 
		nop
	friday_part:
		ori  $t2 ,  $0 , 0 
	second_line:
		sw  $t1 , 0 ( $t0) 
		addi  $t0 ,  $t0 , 4 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 15 , segunda_linha_ho 
		nop
	seventh_part:
		ori  $t2 ,  $0 , 0 
	third_diagonal:
		sw  $t1 , 0 ( $t0) 
		addi  $t0 ,  $t0 , 4 
		addi  $t0 ,  $t0 , 1024 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 9 , terceira_diagonal 
		nop
	octave_part:
		ori  $t2 ,  $0 , 0 
	second_vertical:
		sw  $t1 , 0 ( $t0) 
		addi  $t0 ,  $t0 , 1024 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 15 , segunda_vertical 
		nop
	ninth_part:
		ori  $t2 ,  $0 , 0 
	fourth_diagonal:
		sw  $t1 , 0 ( $t0) 
		addi  $t0 ,  $t0 , 1024 
		subu  $t0 ,  $t0 , 4 
		addi  $t2 ,  $t2 , 1 
		bne  $t2 , 9 , quarta_diagonal 
		nop
		
		jr  $ra
		nop
		
######### END DRAW Y #################

######### RESET MEMORY AND SCREEN ###########
reset_all:
	li  $s1 , 1 
	la  $t0 , values
	sw  $0 , 0 ( $t0) 
	sw  $0 , 4 ( $t0) 
	sw  $0 , 8 ( $t0) 
	sw  $0 , 12 ( $t0) 
	sw  $0 , 16 ( $t0) 
	sw  $0 , 20 ( $t0) 
	sw  $0 , 24 ( $t0) 
	sw  $0 , 28 ( $t0) 
	sw  $0 , 32 ( $t0) 
	
	lui  $t1 , 0x1001 
	li  $t 2 , 0 
	
#Paint everything black
loop :
        sw  $0 , ( $t1)
	addi  $t1 ,  $t1 , 4 
	addi  $t2 ,  $t2 , 1 
	bne  $t2 , 65536 , loop  
	nop
	
	j main
	nop
