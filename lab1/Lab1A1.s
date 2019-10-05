;First Program 
;Jonathan Vargas
;200389468
;Sep. 23, 2019
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


Reset_Handler ;


	MOV R0, #0x00000001 ; RY
	MOV R1, #0x00000002 ; RZ
	ADD R2,R0,R1 ;RX = R2
	
	MOV R1, #0xFFFFFFFF ;
	ADDS R2,R0,R1 ;

	PUSH {R2,R0,R1} ;
	
	MOV R0, #0x2 ; RY
	ADDS R2,R0,R1 ;
	
	MOV R0, #0x7FFFFFFF ;
	MOV R1, #0x7FFFFFFF ;
	ADDS R2,R0,R1 ;
	
	B Reset_Handler;



	ALIGN

	END
