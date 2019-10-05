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
Reset_Handler  PROC ;We only have one line of actual application code
	
	
Awesome

	;ADD	R0, #1
	;CMP	R0, #4
	;BNE	Awesome

	;MOV R0, #9	;; Just an extra line

	BL factorial
	
	BL vowelCount


	;B Reset_Handler
	
	ENDP




ALIGN
factorial PROC
		MOV R0, #0x09
		SUB R1, R0, #1
		MUL R2, R0, R1
calculatefactorial
		SUB R1, #1
		MUL R3, R2, R1 ; ACTUAL CALCULATIUON
		MOV R2, R3 ; R3 IS THE OUTPUT. MOVING R3 TO R2 CREATES A MEADIATING OPERAND
		CMP R1, #1
		BNE calculatefactorial
		
		
		BX LR

		ENDP



; comments input/output
	ALIGN
vowelCount	PROC

string1
	DCB		"ENSE 352 is fun and I am learning ARM assembly!",0
	
string2
	DCB		"Yes I really love it!",0
	
	LDR R5,=string1
	LDRB R6,[R5]
	ADD R5, #1
	LDRB R6,[R5]
	
	BX LR
	ENDP