
			.data
			board: .asciiz "  1   2   3\n1   |   |   \n ---+---+---\n2   |   |   \n ---+---+---\n3   |   |   \n"
			askMove: .asciiz "Player   insert your play (column|line):"
			invalidMove: .asciiz "**Invalid Move**\n"
			occupiedSpace: .asciiz "**Space already occupied**\n"
			x: .asciiz "X"
			o: .asciiz "O"
			won: .asciiz "\nPlayer   Won! \n"
			tie: .asciiz  "\nTie!!!"
			gameMenu: .asciiz "\n\nChoose an option:\n[1] New Game\t[99] Quit\nOption: "
			clean: .byte ' '
		.text
			.globl main
main:
			li $t1, 0		#initializing all the entries on board as null
			li $t2, 0
			li $t3, 0
			li $t4, 0
			li $t5, 0
			li $t6, 0
			li $t7, 0
			li $t8, 0
			li $t9, 0

			li $s0, 0
			li $s5, 0		#count of blocks filled

			la $s1, board		#loading board address in s1
			la $s2, askMove		#loading askmove msg in s2
			la $s3, won		#loading won message in s3

			lb $a1, clean		#load the byte ' ' in a1
			sb $a1, 14($s1)		#storing ' ' in board address + 14
			sb $a1, 18($s1)		#storing ' ' in board address + 18
			sb $a1, 22($s1)		#storing ' ' in board address + 22
			sb $a1, 40($s1)		#storing ' ' in board address + 40
			sb $a1, 44($s1)		#storing ' ' in board address + 44
			sb $a1, 48($s1)		#storing ' ' in board address + 48
			sb $a1, 66($s1)		#storing ' ' in board address + 66
			sb $a1, 70($s1)		#storing ' ' in board address + 70
			sb $a1, 74($s1)		#storing ' ' in board address + 74

PrintBoard:
			li $v0, 4
			la $a0, board		#loading address of updated board after each turn
			syscall

			beq $s5, 9, Tie		#if all 9 bloacks are filled and print board is called again, shows a tie

			add $s5, $s5, 1		#add number of blocks filled everytime printboard is called

			rem $t0, $s0, 2		#stores remainder of value stored in s0, when divided by 2 to get the player number
			add $s0, $s0, 1		#adds 1 to value in s0 each time printboard is called
			bnez $t0, Player0	#branch to player0(player using 0) if value stored in t0 is not equal to 0

PlayerX:
			lb $a1, x		#the symbol x loaded in register a1
			sb $a1, 7($s2)		#storing player number in askmove msg base address + 7
			sb $a1, 8($s3)		#storing player number in won msg base address + 8
			j Play			
Player0:
			lb $a1, o		#the symbol o loaded in register a1
			sb $a1, 7($s2)		#storing player number in askmove msg base address + 7
			sb $a1, 8($s3)		#storing player number in won msg base address + 8

Play:						
			li $v0, 4		#print askmove as acc to the player
			la $a0, askMove
			syscall

			li $v0, 5		#to read the int value given by user
			syscall
			move $s6, $v0		#move the vale to s6 from v0

			beq $s6, 11, J11	# if int is 11, go to J11, 21, go to J21,... and similarly others
			beq $s6, 21, J21
			beq $s6, 31, J31
			beq $s6, 12, J12
			beq $s6, 22, J22
			beq $s6, 32, J32
			beq $s6, 13, J13
			beq $s6, 23, J23
			beq $s6, 33, J33

			li $v0, 4		# if none of the above cases then invalid move
			la $a0, invalidMove	#print invalid move
			syscall
			j Play			#play called again

J11:
			bnez $t1, Occupied	#if value in t1 not zero, calling function occupied
			bnez $t0, O11		#if t0 not equal to 0, means its player0 turn

			X11:			#else playerx turn
			li $t1, 1		#loading 1 in t1 so that its occupied now by player1
			sb $a1, 14($s1)		#storing X in base address of board + 14
			j CheckVictory		#call checkvictory function

			O11:			#similar to playerx
			li $t1, 2
			sb $a1, 14($s1)
			j CheckVictory

J21:
			bnez $t2, Occupied	#similar to case one, just the address is changed
			bnez $t0, O21

			X21:
			li $t2, 1
			sb $a1, 18($s1)
			j CheckVictory

			O21:
			li $t2, 2
			sb $a1, 18($s1)
			j CheckVictory

J31:
			bnez $t3, Occupied	#similar to case one, just the address is changed
			bnez $t0, O31

			X31:
			li $t3, 1
			sb $a1, 22($s1)
			j CheckVictory

			O31:
			li $t3, 2
			sb $a1, 22($s1)
			j CheckVictory

J12:
			bnez $t4, Occupied	#similar to case one, just the address is changed
			bnez $t0, O12

			X12:
			li $t4, 1
			sb $a1, 40($s1)
			j CheckVictory

			O12:
			li $t4, 2
			sb $a1, 40($s1)
			j CheckVictory

J22:
			bnez $t5, Occupied	#similar to case one, just the address is changed
			bnez $t0, O22

			X22:
			li $t5, 1
			sb $a1, 44($s1)
			j CheckVictory

			O22:
			li $t5, 2
			sb $a1, 44($s1)
			j CheckVictory

J32:
			bnez $t6, Occupied	#similar to case one, just the address is changed
			bnez $t0, O32

			X32:
			li $t6, 1
			sb $a1, 48($s1)
			j CheckVictory

			O32:
			li $t6, 2
			sb $a1, 48($s1)
			j CheckVictory

J13:
			bnez $t7, Occupied	#similar to case one, just the address is changed
			bnez $t0, O13

			X13:
			li $t7, 1
			sb $a1, 66($s1)
			j CheckVictory

			O13:
			li $t7, 2
			sb $a1, 66($s1)
			j CheckVictory

J23:
			bnez $t8, Occupied	#similar to case one, just the address is changed
			bnez $t0, O23

			X23:
			li $t8, 1
			sb $a1, 70($s1)
			j CheckVictory

			O23:
			li $t8, 2
			sb $a1, 70($s1)
			j CheckVictory

J33:
			bnez $t9, Occupied	#similar to case one, just the address is changed
			bnez $t0, O33

			X33:
			li $t9, 1
			sb $a1, 74($s1)
			j CheckVictory

			O33:
			li $t9, 2
			sb $a1, 74($s1)
			j CheckVictory

Occupied:
			li $v0, 4			#print message occupied space and call play again
			la $a0, occupiedSpace
			syscall
			j Play

CheckVictory:
			and $s7, $t1, $t2		#bitwise ands t1 & t2 and stores in s7
			and $s7, $s7, $t3		#bitwise ands s7 and t3 and stores in s7
			bnez $s7, Victory		#if s7==1(true), then victory(by case 1)

			and $s7, $t4, $t5		#all are similar to earlier case
			and $s7, $s7, $t6
			bnez $s7, Victory

			and $s7, $t7, $t8
			and $s7, $s7, $t9
			bnez $s7, Victory

			and $s7, $t1, $t4
			and $s7, $s7, $t7
			bnez $s7, Victory

			and $s7, $t2, $t5
			and $s7, $s7, $t8
			bnez $s7, Victory

			and $s7, $t3, $t6
			and $s7, $s7, $t9
			bnez $s7, Victory

			and $s7, $t1, $t5
			and $s7, $s7, $t9
			bnez $s7, Victory

			and $s7, $t7, $t5
			and $s7, $s7, $t3
			bnez $s7, Victory
			j PrintBoard		#if nothing, print board again

Victory:
			li $v0, 4		#print board
			la $a0, board
			syscall

			li $v0, 4		#print won message
			la $a0, won
			syscall
			j MenuNewGame		#jump to menu new game

Tie:
			li $v0, 4		#print the tie message
			la $a0, tie
			syscall

MenuNewGame:
			li $v0,4		#print the gamemenu message
			la $a0, gameMenu
			syscall

			li $v0,5		#take the user input if they want to play or quit
			syscall
			bne $v0, 99, main	#if equals 99, go to main to start game again	

			li $v0, 10		#exit the code otherwise 
			syscall
