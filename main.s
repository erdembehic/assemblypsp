;Author:Behiç Erdem
;Student ID: 040170213
		AREA	demo, CODE, READONLY
		EXPORT	__main
		IMPORT  image
		ENTRY
__main	PROC
		movs    r5,	#0
		movs    r6,	#0
		movs 	r7,	#0
		push 	{r5,r6,r7}	;I push 3 variables to stack for using later
							;first poped will be direction state second poped will be normal or reversed direction
							;third popped is used to count pixels in down movement
							;At first project designed with reverse moves. When picture reaches bottom 
							;left corner it reversed it movement (without interrupt properties) 
							;this normal or reversed movement data stored in stack at first. But then 
							;I check after finishing the homework it did not needed, picture must teleported to begining
							;then I change the code but pop-push mechanism gave some errors therefore I pop and push 2nd stack 
							;element for preventing errors. 
imageDraw
		movs 	r1,#0
		movs 	r2,#0
		movs 	r3,#0
		movs 	r4,#0
		ldr		r1, =0x40010000
		ldr     r2, =image

		
		movs    r3, r5        	;row counter
row		
		str     r3, [r1]       	;storing row to row register
		movs    r4, r6       	;col counter
column
		str     r4, [r1, #0x4] 	;storing column to column register
		ldr     r0, [r2]       	;loading the next pixel from image file
		adds    r2, r2, #4     	;point to the next pixel in the image [R G B] values and 1 space
		str     r0, [r1, #0x8]	;storing the pixel to pixel register
		adds    r4, r4, #1    	;incrementig the column counter to next one
		movs    r7,r6
		adds    r7,r7,#80
		cmp     r4,r7       	;checking ending of the row
		bne     column			;if it is not continuing column operation
		movs    r7,#0			;if it is
		adds    r3, r3, #1     	;incrementing the row counter to next one
		movs	r7,r5
		adds	r7,r7,#60
		cmp     r3, r7   		;checking if we reached end of image
		bne     row
		movs    r2, #1
		str     r2, [r1, #0xc] 	;refreshing screen
		movs    r2, #2
		str     r2, [r1, #0xc]	;clearing screen
;----------------------------------------
decision 					;This part used to decide which way we are going to use left right down etc.
		pop		{r7}		;taking direction state from stack
		cmp 	r7,	#1 		;left move
		beq 	goLeft
		cmp 	r7,	#2 		;down movement after coming from right
		beq 	goDownFromRight
		cmp 	r7, #3 		;up movement after coming from left
		beq 	goDownFromLeft
		cmp		r7, #4 		;right move
		beq 	goRight
		bne 	goRight		;initial movement is right therefore bne is right
;----------------------------------------
goRight 
		cmp 	r6,	#240	;checking top right side is touched
		beq 	rightEnd	;if it is ending right movement
		adds 	r6,r6,#10	;sliding picture 10 pixels each time
		movs	r7,#4		;continuing to right move 
		push 	{r7}		;pushing direction state to stack
		b 		imageDraw

rightEnd
		pop 	{r4}		;preventing errors
		pop 	{r3}		;we have to do down movement and we need to count whether we slide 60 pixels or not
		movs 	r3,#0		;after ending right movement I started down slider counter 
		push	{r3}		;and pushed back to stack 
		push 	{r4}
		movs	r7,	#2 ;
		push 	{r7}
		b 		imageDraw	

;rightReverse
;----------------------------------------
goLeft
		cmp 	r6,	#0		;checking top left is touched
		beq 	leftEnd		;if it is ending left movement
		subs 	r6,r6,#10	;sliding 10 pixels each
		movs	r7,#1		;continuing to left movement
		push 	{r7}		;pushing direction state to stack
		b 		imageDraw

leftEnd
		pop 	{r4}		;preventing stack errors
		pop 	{r3}		;taking down counter from stack
		movs 	r3,#0		;setting it to 0 to start down counter
		push	{r3}		;pushing down counter to stack
		push 	{r4}
		movs	r7,	#3
		push 	{r7}		;pushing down movement type (from left)
		b 		endPointCheck	;reaching end of the lcd is always after the left movement because of that I only check if pixels are matched after left movement
;----------------------------------------
goDownFromRight 			;reason for the different down movements:
		pop 	{r4}		;when we touch end of the row we need to go down 
		pop		{r3}		;after go down our horizontal movements should reversed
		cmp 	r3,#60		;thats why I write 2 different down movement
		beq 	downEndRight	;each one of them running exactly same but only different is they set after movement done different r7 values.

		adds 	r5,r5,#10		;sliding 10 pixels each turn
		adds	r3,r3,#10		;counting sliding
		movs	r7,#2			;continueing sliding down
		push	{r3}
		push	{r4}
		push 	{r7}			;pushing back to all values
		b 		imageDraw
downEndRight
		push	{r3}
		push	{r4}
		movs 	r7, #1			;when going down from right is completed state of direction is setted for going left to next moves
		push 	{r7}
		b 		imageDraw
;----------------------------------------
goDownFromLeft					;exactly same algorith from previous one 
		pop 	{r4}
		pop		{r3}
		cmp 	r3,#60	
		beq 	downEndLeft

		adds 	r5,r5,#10
		adds	r3,r3,#10
		movs	r7,#3
		push	{r3}
		push	{r4}
		push 	{r7}
		b 		imageDraw
downEndLeft
		push	{r3}
		push	{r4}
		movs	r7,	#4		;when going down from left is completed state of direction is setted for going right to next moves
		push 	{r7}
		b 		imageDraw
;---------------------------------------- movement labels are done
;---------------------------------------- now we are going to check that are we on the endpoint ? if it is all registers are resetted (like Keil's CPU reset button)
										; and starting from beginning
endPointCheck
		cmp 	r5,#180					;checking row number it looks top left corner of the image if it is 180
		bne		imageDraw				;bottem left corner is in the edge of the lcd 240
		beq 	endPointCheck2			;going to check column is 0
endPointCheck2	
		cmp		r6,#0					;if it is zero picture lies on the bottom left corner of the lcd
		bne		imageDraw
		beq		resetPosition
resetPosition	
		pop 	{r3,r4,r7}				;emptying stack and going back to all the things have started.
		b 		__main
;----------------------------------------
stop    b       stop		
		ENDP
		END
