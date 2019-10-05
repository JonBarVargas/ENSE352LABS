;ARM1.s Source code for my first program on the ARM Cortex M3
;Function Modify some registers so we can observe the results in the debugger
;Author - Dave Duguid
;Modified August 2012 Trevor Douglas
; Directives
	PRESERVE8
	THUMB
		
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported
	AREA RESET, DATA, READONLY
	EXPORT 	__Vectors


__Vectors DCD 0x20002000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector
	
	ALIGN


;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
	ALIGN
Reset_Handler  PROC ;We only have one line of actual application code   MAIN


	
	
	
	MOV R0, #0x00
	
	
	
Awesome

	ADD	R0, #1
	CMP	R0, #4
	BNE	Awesome

	MOV R0, #9	;; Just an extra line

    BL function1

	BL factorial
	
	BL vowelCount


	B Reset_Handler
	
	ENDP

string1
	DCB		"ENSE 352 is fun and I am learning ARM assembly!",0


ALIGN
function1  PROC ;OPEN CURLY BRACES
anotherSub
		;;This is the guts of the subroutine
		MOV R2, #0x2
		
		
		
		;B anotherSub
		
		BX LR

		ENDP


;Input is R1 (number to calculate factorial)
;Return value is R2
	ALIGN
factorial PROC
	
	
	BX LR
	ENDP





; comments input/output
	ALIGN
vowelCount	PROC
	
	BX LR
	


	ALIGN
string2
	DCB		"ENSE 352 is fun and I am learning ARM assembly!",0
	ENDP	
	END