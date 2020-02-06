;JONATHAN VARGAS 200389468
;12/02/2019
;Lab6
;tests the onboard LEDs

;;; Directives
            PRESERVE8
            THUMB       
        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value


;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_ODR   EQU 	0x4001100C  ; output data register
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8
;GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register

RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register


; Times for delay routines
        
DELAYTIME	EQU		1600000		; (200 ms/24MHz PLL)


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
			
            AREA    MYCODE, CODE, READONLY
			EXPORT	Reset_Handler
			ENTRY

Reset_Handler		PROC

	BL GPIO_ClockInit
	BL GPIO_init
	

; mainLoop for students to write in.	
mainLoop
		
		;BL turnOnLED
		;BL phase2
		BL phase3
		
		B	mainLoop
		ENDP

turnOnLED
    PUSH {R0, R3, R8, LR}
	LDR R8, = GPIOC_ODR ;loads the output address of the C port
	LDR R0,[R8] ;loads R0 from the address in r8
	MOV R0, R3 ;
	STR R0, [R8];
	
	POP {R0, R3, R8, LR}
    BX LR
	ENDP
	
	
phase2
	PUSH{R0, R7, R8, R9, LR}
	LDR R8, = GPIOC_ODR
	LDR R7, = DELAYTIME
blueLED
	MOV R9, #0 ;R9 is the counter
	MOV R0, R2
	STR R0,[R8]
loop
	ADD R9, #1
	CMP R9, R7
	BNE loop
	
otherLED
	MOV R9, #0
	MOV R0, R3
	STR R0,[R8]

delay
	ADD R9, #1
	CMP R9, R7
	BNE delay
	B blueLED
	
	POP{R0, R7, R8, R9, LR}
	ENDP
	


	ALIGN
phase3 PROC
	PUSH{R0, R8, LR}
userInput
	LDR R8, = GPIOA_IDR ;initiates the input pins
	LDR R0,[R8]
	AND R0, #1 ;0000000000000000000000000000001 gets the least significant bit because the board only has one input
	CMP R0, #0
	BEQ turnOff
	CMP R0, #1
	BEQ turnOn
	BNE userInput ;completely loops the user Input 	
turnOff
	LDR	R8,=GPIOC_ODR
	LDR R0,=0x000	
	STR R0,[R8]	
	B userInput
turnOn
	LDR R8,=GPIOC_ODR
	LDR R0,=0x300		;1100000000 Bits to turn on both PC8, PC9
	STR R0,[R8]			;turn on led
	B userInput
	
	POP{R0, R8, LR}
	BX LR
	ENDP
;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;This routine will enable the clock for the Ports that you need	
	ALIGN
GPIO_ClockInit PROC
	PUSH{R0, R6, LR}
	LDR R6, = RCC_APB2ENR ;APB2 Peripheral Clock Enable Register
	MOV R0, #0x14 ;10100 sets these 2 bits to enable the clock for port A anc C
	STR R0, [R6]
	POP{R0, R6, LR}
	BX LR
	ENDP
			
			
	ALIGN

;This routine enables the GPIO for the LED;s
GPIO_init  PROC
	PUSH{R0, R6, R7, LR}
	
	LDR	R7, = GPIOA_CRL    ;ram address
	LDR	R0, = 0x44444444	; CNF: 01, Mode: 00
	STR	R0, [R7]
	
	LDR R6, = GPIOC_CRH
	LDR R0, = 0x00000033    ;output mode: max speed 50 MHz
	STR R0, [R6]

	MOV R2, #0x0100 ;100000000
	MOV R3, #0x0200	;1000000000 PC 9

	POP{R0, R6, R7, LR}
	BX LR
	ENDP

	ALIGN
	END