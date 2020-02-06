
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
	MOV32 R0, #0x800

		BL eleventhTF
		BL bit3n7
		BL onesCount
	MOV32 R0, #0x12345678
	MOV R2, #0xE8
		BL rot_left_right

	MOV32 R12, #2560
	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN
eleventhTF PROC
	PUSH{R0-R5}
	MOV R2, #1
	LSL R2, R2, #11	;the last 2 lines can be subsituted with an AND 
	AND R3, R0, R2
	LSR R1, R3, #11
	POP{R0-R5}
		BX LR

		ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ALIGN
bit3n7 PROC
	PUSH{R0-R5}
	
	MOV32 R4, #0xFFFFFF7F
	MOV R2, R0
	ORR R3, R2, #0x8
	AND R1, R3, R4
	
	POP{R0-R5}
	BX LR
	ENDP
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	ALIGN
onesCount PROC
	PUSH{R0-R5}
	
	MOV R2, #0
	MOV R3, #1
	AND R4, R0, R3
	CMP R4, #1
	BEQ addbit
	
bitLoop
	ADD R2, #1
	LSL R3, R3, #1
	AND R4, R0, R3
	LSR R5, R4, R2
	
	CMP R5, #1
	BNE noBit
addbit
	ADD R1, #1
	
noBit
	
	CMP R2, #32
	BNE bitLoop
	
	POP{R0-R5}
	BX LR
	ENDP
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ALIGN
rot_left_right PROC
	MOVT R3, #0xffff
	MOVW R4, #0xFFFF
	
	AND R5, R0, R3	;TOP 16 BITS
	AND R6, R0, R4	;BOTTOM 16 BITS
	
	AND R7,r2,  #0x20
	LSR R7, R7, #5
	AND R8, R2, #0x8 ; determines the amount of bits to be rotated from bits 0-3
	LSR R8, R8, #3
	CMP R7, #1 ;r7 determines the rotation direction
	BEQ rotLeft
	
rotRight

	AND R9, R6, #0x1 
	LSL R9, R9, #15
	LSR R6, R6, #1
	
	CMP R9, #1
	BEQ setBit
	
	MOV32 R9, #0xFFFFFFFe
	CMP R9, #0
	BEQ clearBit
rotLeft
	AND R9, R6, #0x8000 ;r9 collects the 16th bit of the number
	LSR R9, R9, #15
	LSL R6, #1
	
	CMP R9, #1
	BEQ setBit
	
	
	CMP R9, #0
	BEQ clearBit
	
setBit
	ORR R6, R6, R9
	B done
	
clearBit

	B done
	
	
done

	ORR R1, R3, R6	;
	
	BX LR
	ENDP
		
align
	end