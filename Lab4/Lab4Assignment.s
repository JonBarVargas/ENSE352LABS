;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Project: Lab 4 - Sorting arrays of characters in ascending 
;;;          order using Merge sort algorithm
;;; File: 
;;; Class: lab4_sort.s
;;; Date: 
;;; Programmer: 
;;; Description:

;;; Directives
	thumb

;;; Equates
end_of_stack	equ 0x20001000			;Allocating 4kB of memory for the stack
RAM_START		equ	0x20000000


;;; Includes
	;; empty

;;; Vector definitions

	area vector_table, data, readonly
__Vectors
	DCD	0x20002000		; initial stack pointer value
	DCD	Reset_Handler	; program entry point
	export __Vectors

	align

;;; Our mainline code begins here
	area	mainline, code
	entry
	export	Reset_Handler

;;; Procedure definitions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Description:
;;;
Reset_Handler proc
	;; Copy the string of characters from flash to RAM buffer so it 
	;; can be sorted


stringA
	DCB	"EBFZACGLDA",0
	
LDR R0,=stringA

push{R0}
	bl normalSub
	
	
  
	
	mov R7, #7  
	mov R6, R7
	bl recursive
	
	
	;Try it another way
	mov R7, #3  
	mov R6, R7
	bl recursive2
	
	
	;; we are finished
doneMain	b	doneMain		; finished mainline code.
	endp
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ALIGN
testSub
		
		ENDP
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
string1
	dcb	"EBFZACGLDA"
string1size	equ . - string1

	align
size1
	dcd	string1size
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author:
;;; We will use R1, R2, R3

;;; 

	ALIGN
normalSub	PROC
	push {R1,R2,R3}
	
	mov R1, #0
	mov R2, #1
	mov R3, #2
	
	push {LR}  ;  uncomment to show how we need to save the LR when we are nesting 
							;  subroutine calls
	bl nestedSub
	pop {LR}   ;  uncomment for above
	pop {R1,R2,R3}
	BX LR
	ENDP

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author:
;;; We will use R1, R2, R3

;;; 

	ALIGN
nestedSub	PROC
	push {R1,R2,R3}
	
	mov R1, #0
	mov R2, #1
	mov R3, #2
	
	
	pop {R1,R2,R3}
	BX LR
	ENDP	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; R7 is the register that holds the factorial value
;;; R6 contains the integer counting down
	ALIGN
recursive	PROC
	
	push {LR}  ;;Important for recursive
	
	CMP R6, #0
	BEQ inputZero
	
		
	SUB R6,R6,#1
	CMP R6, #0
	BEQ done
	
	MUL R7, R7, R6
	
	
	BL recursive
	
done
	pop {LR}
	
inputZero
	BX LR
	ENDP
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; R7 is the register that holds the factorial value
;;; R6 contains the integer counting down.  In this case push 
;;; all these to the stack and when done start popping and computing
;;; the factorial
	ALIGN
recursive2	PROC
	
	push {LR}  ;;Important for recursive
	MOV R7, #1
	CMP R6, #0
	BEQ inputZero
	
	push {R6}	
	SUB R6,R6,#1
	CMP R6, #0
	BEQ done2
	
	
	
	
	
	BL recursive2
	
done2
	pop {R6}  ;  Try mixing these up and show what happens.
	
	pop {LR}
	MUL R7, R7, R6
	
	
	
	
	
	
inputZero2
	BX LR
	ENDP
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End of assembly file
	align
	end