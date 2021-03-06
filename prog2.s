*----------------------------------------------------------------------
* Programmer: Eric De Anda
* Class Account: masc0741
* Assignment or Title: Program#2
* Filename: prog2.s datafile.s
* Date completed: march 22, 2016
*----------------------------------------------------------------------
* Problem statement: Solve the Polynomial
* Input: values for a,b,c,d,e,f,x,y,z
* Output: the simplification of the polynomial
* Error conditions tested: variations of negative inputs
* Included files: datafile.s prog2.s
* Method and/or pseudocode:(aX2+2bX2Y3+cY2-dX2Y)/(dX2+eY2+fxb)+4Z2-2ad
* References: Alan Riggins, Assembly Language 68K family, 
* Lecture & Notes Supplementary material.
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
DATA:	EQU	$6000
a:	EQU	DATA		*sets link to datafile.
b:	EQU	a+2
c:	EQU	b+2
d:	EQU	c+2
e:	EQU	d+2
f:	EQU	e+2
x:	EQU	f+2
y:	EQU	x+2
z:	EQU	y+2
start:  initIO                          * Initialize (required for I/O)
	setEVT  	        * Error handling routines
	
	lineout		title		* prints program information
	move.w	x,D1	
	muls		D1,D1	*save x^2 in D1 for later use
*a(x^2)
	move.w	a,D2
	muls		D1,D2	*a(x^2) is in D2
*2b(x^2)y^3
	move.w	b,D3
	asl.w		#1,D3	*b doubled to 2b
	muls		D1,D3	*2b(x^2) is in D3	
	move.w	y,D4	
	muls		D4,D4	*Y^2 in D4
	move.w	D4,D6	*saved copy of Y^2 in D6 for cY^2
	move.w	D4,D5	*saved copy of Y^2 in D5 for e(y^2)
	muls		y,D4	*Y^3 in D4
	muls		D4,D3	*2b(x^2)y^3 in D3
*cY^2
	muls		c,D6	*cY^2 in D6
*d(x^2)y
	move.w	D1,D7	*saved copy of x^2 to D7
	muls		d,D7	*dx^2
	muls		y,D7	*d(x^2)y
*adding all terms in upper parenthesis to a(x^2)+2b(x^2)(y^3)+c(Y^2)-d(x^2)y	
	add.w		D3,D2	*a(x^2) is added 2b(x^2)y^3
	add.w		D6,D2	*a(x^2)+2b(x^2)(y^3) is added cY^2	
	sub.w		D7,D2	*a(x^2)+2b(x^2)(y^3)+c(Y^2)isSubstracted d(x^2)y
*d(x^2)	
	muls		d,D1	*d(x^2)
*e(y^2)	
	muls		e,D5	*e(y^2)
*fxb
	move.w	f,D6	*overwrites D6 with f
	muls		x,D6	*fx
	muls		b,D6	*fxb
*adding all terms in lower parenthesis to d(x^2)+e(y^2)+fxb to D1
	add.w		D5,D1	*d(x^2) is added e(y^2)
	add.w		D6,D1	*d(x^2)+e(y^2) is added fxb
*dividing upper and lower parenthesis
	ext.l		D2	* making it long
	divs		D1,D2	*
*(a(x^2)+2b(x^2)(y^3)+c(Y^2)-d(x^2)y)/(d(x^2)+e(y^2)+fxb)
*4(z^2)
	move.w		z,D5	*z in D5
	muls		D5,D5	*z^2 in D5
	asl.w		#2,D5	*multiply(z^2) by 4 to 4(z^2)
*2ad
	move.w		a,D4	*a
	asl.w		#1,D4	*multiply a by 2 to 2a
	muls		d,D4	*2ad in D4
*adding all the parts together to D2
	add.w		D5,D2	
*(a(x^2)+2b(x^2)(y^3)+c(Y^2)-d(x^2)y)/(d(x^2)+e(y^2)+fxb) is added *4(z^2)
	sub.w		D4,D2	
*(a(x^2)+2b(x^2)(y^3)+c(Y^2)-d(x^2)y)/(d(x^2)+e(y^2)+fxb)+4(z^2) minus *2ad 


	move.w	D2,D0		* moving total to D0 for the macro
	ext.l		D0		* make it long since macros use long
	cvt2a		sum,#6		* convert to string, write @ sum
	stripp		sum,#6		* remove leading zeros.
	lea		sum,A0	* load address sum into register
	adda.l		D0,A0		* add strlen to starting address
	move.b		#'.',(A0)	* insert a period at the end
	adda.l		#1,A0		* move past the period
	clr.b		(A0)		* NULL terminate
	lineout		answer		* print the sum
				


        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations

title:	dc.b	'Program #2, masc0741, Eric Deanda',0
answer:	dc.b	'The answer is: '
sum:	ds.b	8
        end