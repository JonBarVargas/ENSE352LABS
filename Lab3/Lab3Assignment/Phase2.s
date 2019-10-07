
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
	
	
Main

	BL factorial
	
	LDR R5,= string1
	BL vowelCount
	LDR R5,= string2
	BL vowelCount
	ENDP


ALIGN
factorial PROC
		MOV R0, #5
		
		
		SUB R1, R0, #1
		MUL R2, R0, R1
		
;this will loop until the counting operand (R1)
calculatefactorial
		SUB R1, #1
		
		;this will cumulately multiply the mediating operand into r3 until 
		;R1 our counter reaches 1
		MUL R3, R2, R1 ; ACTUAL CALCULATIUON.
		
		MOV R2, R3 ; R3 IS THE OUTPUT. MOVING R3 TO R2 CREATES A MEADIATING OPERAND
		CMP R1, #1
		BNE calculatefactorial

		

		BX LR

		ENDP



	ALIGN
		
		
		
vowelCount	PROC
	MOV R7, #0



	LDRB R6,[R5]
	;PUSH {R6} 
	
stringProcess ;the vowells to be looking for are [a, e, i, o, u]
	
	LDRB R6,[R5]
	
	CMP R6, #'a'
	BEQ detectVowel
	
	CMP R6, #'A'
	BEQ detectVowel
	
	
	CMP R6, #'e'
	BEQ detectVowel
	
	CMP R6, #'E'
	BEQ detectVowel
	
	
	CMP R6, #'i'
	BEQ detectVowel
	
	CMP R6, #'I'
	BEQ detectVowel
	
	
	CMP R6, #'o'
	BEQ detectVowel
	
	CMP R6, #'O'
	BEQ detectVowel
	
	
	CMP R6, #'u'
	BEQ detectVowel
	
	CMP R6, #'U'
	BEQ detectVowel
	BNE noVowel
	
detectVowel
	ADD R7, #1 ;r7 is the output register that houses the number of vowels
	
noVowel
	ADD R5, #1
	CMP R6, #0
	BNE stringProcess
	
		
	BX LR
	ENDP
		
string1
	DCB		"ENSE 352 is fun and I am learning ARM assembly!",0 
	
string2
	DCB		"Yes I really love it!",0