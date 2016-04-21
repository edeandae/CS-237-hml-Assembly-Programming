*----------------------------------------------------------------------
* Programmer: Eric De Anda
* Class Account: masc0741
* Assignment or Title: program 3
* Filename: prog3.s
* Date completed:April 18,2016
*----------------------------------------------------------------------
* Problem statement:sort between 1-100 integers size word
* Input: 1-100 amount of unsigned integers
* Output: unsorted integers and afterwards sorted integers
* Error conditions tested: 
* Included files: datafile.s, prog3.s
* Method and/or pseudocode: radix sort
* References: Lecture Notes & Supplemental Material, Alan Riggins Lecture
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
ARRAY_SIZE:       EQU   $6000                *Datafile Reference
ARRAY:            EQU   ARRAY_SIZE+2        *Start of Array


start:  initIO                        * Initialize (required for I/O)
        setEVT                                * Error handling routines
*        initF                                * For floating point macros only


        lea ARRAY,A2                        *load address of ARRAY at A2
        lea output,A3                        *load address of output at A3
        move.w ARRAY_SIZE,D7                *take ARRAY_SIZE to D7 
        subq.w #1,D7                        *subtracts #1 to Array size to run it N times only
        lineout title                        *prints Assignment & name
        lineout        unsrtd                *prints "unsorted array"
print:        
        move.w (A2)+,D0                *moves a word to D0 to test it
        andi.l #$0000FFFF,D0                *compared D0 to -1
        cvt2a (A3),#6                 *converts 2 to ascii
        stripp (A3),#6                *gets rid of leading zeros
        adda.l D0,A3                        
        move.b #',',(A3)+                        *dynamically terminating
        move.b #' ',(A3)+
        dbra D7,print                                *Doing it Array size amount of times
        clr.b -2(A3)
        lineout        output




        
                                        
        moveq        #15,D7                                *puts 15 in D7 to do outer loop 16
        clr.l        D6                                *clears D6 to have it zeroed out
        


        move.w        ARRAY_SIZE,D3
        subq.w        #1,D3
outer:        *************outer loop                        
        move.w        ARRAY_SIZE,D3
        subq.w        #1,D3
        clr.l        D4
        clr.l        D5


        lea        array,A2                        *A2=array address
*******initialization before starting to put in buckets
        movea.l        A2,A0                        *copy array address to A0
        move.w        ARRAY_SIZE,D0        *size 10 D0=10
        asl.w        #1,D0                                *D0=20
        adda.l        D0,A0                                *zero bucket:(size*2)+ARRAY
        movea.l        A0,A1        
        adda.l        D0,A1                                *one bucket:((size*2)+ARRAY)+size*2
        
****************** inner loop                
inner:        move.w        (A2),D1                        *take a word starting at array to D1
        lsr.w        D6,D1                                *shift counter
        andi.w        #1,D1                                *ands given bit with 1
        beq        to_zero                        *jumps to zero if the bit is a zero
        move.w        (A2)+,(A1)+                        *puts something into 1 bucket
        addq.w        #1,D5                                *adds #1 to one counter
        bra        done
to_zero:
        move.w        (A2)+,(A0)+                        *takes a word from Array and sends it to zero
*bucket
        addq.w        #1,D4                                *adds #1 to zero bucket
done:        dbra        D3,inner                        *does the loop array_size amount of times
                
        lea        array,A2                        *reinitialize Address registers to the start of array and 
        move.l        A2,A0                                *buckets
        adda.l        D0,A0
        movea.l        A0,A1
        adda.l        D0,A1
        
        tst.w        D4                        *flag for whether Zero counter is empty
        beq        cp_one                        *if so jump to test for one counter
        subq.w        #1,D4                        *subtract counter by #1 to run counter times
        
rps0:        move.w        (A0)+,(A2)+        *adds one word from zero bucket to Array
        dbra        D4,rps0                *do this zero counter times
cp_one:        tst.w        D5                *test for whether One bucket is empty
        beq        bottom                        *if so end the loop
        subq.w        #1,D5                        *subtract counter by #1 to run counter times
rps1:        move.w        (A1)+,(A2)+        *adds one word from One bucket to Array
        dbra        D5,rps1                *do this One counter times


***************bottom of outer loop
bottom:                
        addq.l        #1,D6                        *Add #1 to D6 to check a different bit each time
        dbra        D7,outer                *Do the loop 16 times, once for each bit in the Word long
*****************************                * integer


        lea ARRAY,A2                        *load address of ARRAY at A2
        lea output,A3                        *load address of output at A3
        move.w ARRAY_SIZE,D7                *take ARRAY_SIZE to D7
        subq.w #1,D7                        *subtracts 1 to Array size to run it Array_size times only
        lineout srtdar                *Prints sorted Array
print2:        move.w (A2)+,D0        *takes a word from array direction to print it
        andi.l #$0000FFFF,D0        
        cvt2a (A3),#6                 *converts from ascii to 2 compliments
        stripp (A3),#6                *get rid of leading zeros
        adda.l D0,A3                
        move.b #',',(A3)+                *Dynamically terminate
        move.b #' ',(A3)+
        dbra D7,print2
        clr.b -2(A3)
        lineout        output                *Prints sorted array numbers


        break                           *Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
title:        dc.b        'Program #3, masc0741, Eric Deanda',0
unsrtd:        dc.b        'The unsorted array:',0
srtdar:        dc.b        'The sorted array:',0
output:        ds.b        700
        dc.b        ' ',0
                                
        end