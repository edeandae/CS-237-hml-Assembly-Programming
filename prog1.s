*----------------------------------------------------------------------
* Programmer: Eric Deanda
* Class Account: masc0741
* Assignment or Title: program #1a
* Filename: prog1.s
* Date completed: 03/09/2016 
*----------------------------------------------------------------------
* Problem statement:convert integers range 1-15 to latin
* Input: integer 1-15
* Output: that integer in latin is latinNumber
* Error conditions tested: tested with garbage.h68 for part of code that relies on register or memory location
* Included files: prog1.h68
* Method and/or pseudocode: calculate the chunk of storage memory that wants to be printed, save them 4 at a time
* References:Assembly Language programming the 68000 Family,Lecture Notes & Supplementary material, Alan Riggins
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start           * Program counter value after a reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
*
#minclude /home/ma/cs237/bsvc/iomacs.s
#minclude /home/ma/cs237/bsvc/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use
*
*----------------------------------------------------------------------
*
start:  initIO                 	 	* Initialize (required for I/O)
	setEVT					* Error handling routines
*	initF						* For floating point macros only	
	lineout		title	
	lineout		prompt		*prompt to enter integer from 1-15
	linein		buffer		*read the int argument
	cvta2			buffer,D0			*convert to two�s complement	
	subq.l          #1,D0		
	mulu            #16,D0		*number of bytes necessary to get the correct number
	lea             array,A0		*loads array to address register
	adda.L          D0,A0 		*latin word is now in A0
	move.l          (A0)+,answer 	*saves first 4 bytes at answer, then increments A0 address by 4
	move.l          (A0)+,answer+4	*saves second 4 bytes at answer+4, then increments A0 address by 4
	move.l          (A0)+,answer+8 	*saves third 4 bytes at answer+8, then increments A0 address by 4
	move.l          (A0),answer+12  *saves fourth 4 bytes at answer+12
	lineout         output		*prints output and subsequently the latin word stored at answer
	
        break                   	* Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
title:     dc.b    'Program #1, masc0741, Eric Deanda',0
prompt:    dc.b    'Please enter an integer in the range 1..15:',0
buffer:    ds.b    80
array:     dc.b    'unus.          ',0		*declaration of latin words
           dc.b    'duo.           ',0
		dc.b    'tres.          ',0
		dc.b    'quattuor.      ',0
		dc.b    'quinque.       ',0
		dc.b    'sex.           ',0
		dc.b    'septem.        ',0
		dc.b    'octo.          ',0
		dc.b    'novem.         ',0
		dc.b    'decem.         ',0
		dc.b    'undecim.       ',0
		dc.b    'duodecim.      ',0
		dc.b    'tredecim.      ',0
		dc.b    'quattuordecim. ',0
		dc.b    'quindecim.     ',0


output:             dc.b    'That number in Latin is '
answer:           ds.b    16				*number of bytes in each chunk
        end

