; CIS-11 Bubble Sort Version 2
; Author: Junhwan Lee
; Date: 5/27/2021


; R0 contain values
; R1 contain values
; R2 Computational Purpose / Loop Counter
; R3 Temporary storage holder for value
; R4 Stackbase pointer
; R5 Loop counter
; R6 Arraybase pointer 



		.ORIG X3000
	
; Begin intializing the pointers
	
		AND R5, R5, #0		; Clear R5
		AND R6, R6, #0		; Clear R6
		AND R0, R0, #0		; Clear R0
		LD R5, COUNTER		; Load COUNTER to R5, R5 keeps track of number of elements	
		LD R6, ARRAYBASE	; Load ARRAYBASE to R6, R6 becomes the array pointer
		LD R4, STACKBASE	; Load STACKBASE to R4, R4 becomes the stack pointer
	
; Begin user interface and taking elements from user inputs

INPUT		LEA R0, ENTMSG		; Display prompt to ask user for element
		PUTS			
		AND R0, R0, #0		; Clear R0
		GETC			; Get a first character from console, store in R0
		OUT			; Echo the character
		JSR ASCII		; Jump to Ascii conversion function
		ADD R0, R0, #0		; Conditional Statement
		BRnz ONES		; If R0 is negative or zero, branch to ONES
		BRp TENS		; If R0 is positive, branch to TENS


; Evaluate the input values

ONES		GETC			; Get a second character from console, store in R0
		OUT			; Echo the character
		JSR ASCII		; Jump to Ascii conversion function 
		JSR STORE		; Store in an array
		ADD R5, R5, #-1		; Decrement the element counter
		BRp INPUT		; If positive, take more input
		BRnz UNSORTED		; If zero or negative, proceed to sort 

TENS		AND R1, R1, #0		; Clear R1
		ADD R1, R1, #10		; Add #10 to R1
		ADD R0, R0, #-1		; Subtract #1 to R0
		BRp #-3			; If R0 is positive, move back to 2 lines above
		AND R0, R0, #0		; Clear R0
		GETC			; Get a second character from console, store in R0
		OUT			; Echo the character
		JSR ASCII		; Jump to Ascii conversion function
		ADD R0, R1, R0		; Add R0 and R1, store in R0
		JSR STORE		; Store in an array
		ADD R5, R5, #-1		; Decrement the element counter
		BRp INPUT		; If positive, take more input
		BRnz UNSORTED		; If zero or negative, proceed to sort
	
	
; Display sorted array

UNSORTED	AND R5, R5, #0
		AND R6, R6, #0
		LD R5, COUNTER		; Load COUNTER to R5, R5 keeps track of number of elements
		LD R6, ARRAYBASE	; Point to the 0th element in the array
		LEA R0, SHOWUNSORTED	; Load string SHOWUNSORTED
		PUTS			; Display SHOWUNSORTED
		AND R0, R0, #0		; Clear R0
		AND R1, R1, #0		; Conditional statement for output, zero if it is unsorted
		BR OUTPUT
		
; Display with Ascii conversion back to decimal

OUTPUT		AND R2, R2, #0		; Clear R2
		AND R0, R0, #0		; Clear R0
		JSR AT			; Get an element from the array
		JSR DIV			; Perform modulo 10
		ADD R0, R0, #10		; R0 + 10
		AND R3, R3, #0		; Clear R3
		ADD R3, R0, #0		; Copy R0 into R3 
		AND R0, R0, #0		; Clear R0
		ADD R0, R2, #-1		; R0 = R2 - 1
		JSR PASCII		; Ascii conversion back to decimal
		OUT			; Display R0
		AND R0, R0, #0		; Clear R0
		ADD R0, R3, #0		; Copy R3 into R0
		JSR PASCII		; Ascii conversion back to decimal
		OUT			; Display R0
		LEA R0, SPACE		; Load string SPACE
		PUTS			; Display SPACE
		ADD R5, R5, #-1		; Decrement a loop counter
		BRp OUTPUT		; If positive, branch to OUTPUT	
		ADD R1, R1, #0		; Conditional statement, zero continues to sorting, one exits
		BRz COUNT		; Continue to sorting
		BRp END			; End

DIV		ADD R2, R2, #1		; Count number of tenth
		ADD R0, R0, #-10	; Subtract #10 to R0
		BRzp DIV		; If zero or positive, branch to DIV
		RET

END		HALT


; Begin Bubble Sort
; Compare n-1 times of outer loop
; Compare n-1-i times of inner loop, n = 8

COUNT		LD R2, COUNTER		; Initialize outer loop counter	
OUTERLOOP	ADD R2, R2, #-1		; Decrement at the start of the loop
		BRnz SORTED		; If negative or zero, finished sorting
		JSR PUSH
		ADD R5, R2, #0		; Copy R2 into R5, the loop decrements each time since the number of arrays to eval decrement
		LD R6, ARRAYBASE	; Array pointing to the first element
INNERLOOP	AND R3, R3, #0		; Clear R3
		LDR R0, R6, #0		; Load R6 element into R0
		LDR R1, R6, #1		; Load R6 + 1 element into R1
		JSR PUSH		; Push the element
		NOT R3, R1		; 1's complement of R3
		ADD R3, R3, #1		; 2's complement of R3, R3 is now negative
		ADD R3, R0, R3		; R3 = R0 - R3
		BRnz SWAPPED		; If negative or zero, it is in order
		STR R1, R6, #0		; Store R1 into R6 pointed location		
		STR R0, R6, #1		; Store R0 into R6 + 1 pointed location
SWAPPED		JSR POP			; Pop the element
		ADD R6, R6, #1		; Increment the array pointer
		ADD R5, R5, #-1		; Decrement the inner loop counter	
		BRp INNERLOOP		; If loop counter is still positive, repeat inner loop
		BR OUTERLOOP		; If inner loop is finished repeat outerloop
SORTED 		AND R5, R5, #0
		AND R6, R6, #0
		LD R5, COUNTER		; Load COUNTER to R5, R5 keeps track of number of elements
		LD R6, ARRAYBASE	; Point to the 0th element in the array
		LEA R0, SHOWSORTED	; Load string SHOWUNSORTED
		PUTS			; Display SHOWUNSORTED
		AND R0, R0, #0		; Clear R0
		ADD R1, R1, #1		; Conditional statement for output, 1 if it is sorted
		BR OUTPUT


; Converting the character to the acutal value with the Ascii conversion

ASCII		ADD R0, R0, #-16	; Subtract total of #48
		ADD R0, R0, #-16	
		ADD R0, R0, #-16
		RET

PASCII		ADD R0, R0, #10		; Add total of #48
		ADD R0, R0, #10
		ADD R0, R0, #10
		ADD R0, R0, #10
		ADD R0, R0, #8
		RET
; Array

STORE		STR R0, R6, #0		; Store R0 at the array base memory location
		ADD R6, R6, #1		; Extend the size of the array
		RET

AT		LDR R0, R6, #0		; Get the element at R6
		ADD R6, R6, #1		; Increment R6 and point to the next element
		RET	

; Stack 

PUSH		ADD R4, R4, #-1		; Move top of stack up
		STR R0, R4, #0		; Store R0 there
		RET 		

POP		LDR R0, R4, #0		; Load R0 with the top of the stack
		ADD R4, R4, #1		; Move top of stack down
		RET

; Base pointer to the stack and counter
	
		ARRAYBASE	.FILL X3500	; The array starts at x5000
		STACKBASE	.FILL X4000	; The bottom of the stack is at x4000
		COUNTER		.FILL X0008	; 8 elements expected from users

; Strings to display

		ENTMSG		.STRINGZ	"\nEnter the value for element: "
		EXITMSG		.STRINGZ	"\nFinished and exiting."	
		SHOWUNSORTED	.STRINGZ	"\nUnsorted Array: "
		SHOWSORTED	.STRINGZ	"\nSorted Array: "	
		SPACE		.STRINGZ	" "

		.END