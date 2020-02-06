;Jonathan Vargas 200389468
;12/02/2019
;LED buttons
;	programs the switch buttons to turn on an LED

;;; Directives
            PRESERVE8
            THUMB       

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value

;PORT A GPIO - Base Addr: 0x40010800
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOA_CRH	EQU		0x40010804	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register
GPIOA_ODR	EQU		0x4001080C	; (0x0C) Port Output Data Register
GPIOA_BSRR	EQU		0x40010810	; (0x10) Port Bit Set/Reset Register
GPIOA_BRR	EQU		0x40010814	; (0x14) Port Bit Reset Register
GPIOA_LCKR	EQU		0x40010818	; (0x18) Port Configuration Lock Register

;PORT B GPIO - Base Addr: 0x40010C00
GPIOB_CRL	EQU		0x40010C00	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOB_CRH	EQU		0x40010C04	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOB_IDR	EQU		0x40010C08	; (0x08) Port Input Data Register
GPIOB_ODR	EQU		0x40010C0C	; (0x0C) Port Output Data Register
GPIOB_BSRR	EQU		0x40010C10	; (0x10) Port Bit Set/Reset Register
GPIOB_BRR	EQU		0x40010C14	; (0x14) Port Bit Reset Register
GPIOB_LCKR	EQU		0x40010C18	; (0x18) Port Configuration Lock Register

;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register
GPIOC_ODR	EQU		0x4001100C	; (0x0C) Port Output Data Register
GPIOC_BSRR	EQU		0x40011010	; (0x10) Port Bit Set/Reset Register
GPIOC_BRR	EQU		0x40011014	; (0x14) Port Bit Reset Register
GPIOC_LCKR	EQU		0x40011018	; (0x18) Port Configuration Lock Register

;Registers for configuring and enabling the clocks
;RCC Registers - Base Addr: 0x40021000
RCC_CR		EQU		0x40021000	; Clock Control Register
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register
RCC_CIR		EQU		0x40021008	; Clock Interrupt Register
RCC_APB2RSTR	EQU	0x4002100C	; APB2 Peripheral Reset Register
RCC_APB1RSTR	EQU	0x40021010	; APB1 Peripheral Reset Register
RCC_AHBENR	EQU		0x40021014	; AHB Peripheral Clock Enable Register

RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register  -- Used

RCC_APB1ENR	EQU		0x4002101C	; APB1 Peripheral Clock Enable Register
RCC_BDCR	EQU		0x40021020	; Backup Domain Control Register
RCC_CSR		EQU		0x40021024	; Control/Status Register
RCC_CFGR2	EQU		0x4002102C	; Clock Configuration Register 2

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
	
mainLoop



userInput
	LDR R8, = GPIOC_IDR
	LDR R6, = GPIOB_IDR
	LDR R7, = GPIOA_IDR
	LDR	R5, = GPIOA_ODR
	
	;the constant to turn off all of the LEDs
	LDR R0,=0x1E00
	


LEDCommand1_2
	LDR R2,[R6]
	AND R2, #0x300
	CMP R2, #0
	BEQ turnOnLED1_2
	
	CMP R2, #0x200
	BEQ turnOnLED1
	
	CMP R2, #0x100
	BEQ turnOnLED2
	
	CMP R2, #0x300
	BEQ turnOffLED1_2
LEDCommand3
	LDR R4,[R8]
	AND R4, #0x1000
	CMP R4, #0
	BEQ turnOnLED3
	
	CMP R4, #0x1000
	BEQ turnOffLED3
	
LEDCommand4
	LDR R9,[R7]
	AND R9, #0x20
	CMP R9, #0
	BEQ turnOnLED4
	
	CMP R5, #0x20
	BEQ turnOffLED4
	
	BNE userInput 
	
;since ARM is sequiential I broke up each LED into its seperate branch
	
turnOffLED1_2
	STR R0,[R5]	
	b LEDCommand3
	
turnOffLED3
	STR R0,[R5]	
	b LEDCommand4

turnOffLED4
	STR R0,[R5]
	b userInput


;since the LEDs are active low we are sending a 0 to the corresponding bit to turn it on
turnOnLED1
	LDR R0,=0x1C00		
	STR R0,[R5]	
	B userInput
	
turnOnLED2
	LDR R0,=0x1A00
	STR R0,[R5]
	B userInput
	
turnOnLED1_2
	LDR R0,=0x1800
	STR R0,[R5]
	B userInput
	
turnOnLED3
	LDR R0,=0x1600		
	STR R0,[R5]			
	B userInput
	
turnOnLED4
	LDR R0,=0xE00		
	STR R0,[R5]			
	B userInput
		;sw5 = pa5
		;sw3 = pb9
		;sw2 = pb8
		;sw4 = pc12
		;LED1 = PA9
		;LED2 = PA10
		;LED3 = PA11
		;LED4 = PA12
		B	mainLoop
		ENDP
;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This routine will enable the clock for the Ports that you need	
	ALIGN
GPIO_ClockInit PROC

	LDR R6, = RCC_APB2ENR ;APB2 Peripheral Clock Enable Register
	MOV R0, #0x1C ;11100 sets these 2 bits to enable the clock for port A,B,C
	STR R0, [R6]
	BX LR
	ENDP

	; Students to write.  Registers   .. RCC_APB2ENR
	; ENEL 384 Pushbuttons: SW2(Red): PB8, SW3(Black): PB9, SW4(Blue): PC12 *****NEW for 2015**** SW5(Green): PA5
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12

;This routine enables the GPIO for the LED's.  By default the I/O lines are input so we only need to configure for ouptut.
	ALIGN
GPIO_init  PROC
	
	LDR R7, = GPIOA_CRH
	LDR R0, = 0x33330 ;110011001100110000 enables LED 1,2,3,4 output mode: max speed 50 MHz
	STR R0, [R7]

	BX LR
	ENDP
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12\

    BX LR
	ENDP
		
		
		
	ALIGN
	END
}





	ALIGN 
test PROC
	MOV R0, #0
	LDR R5, = GPIOA_IDR
	LDR R6, = GPIOB_IDR
	LDR R7, = GPIOC_IDR
	LDR R1,[R6]
	LDR R2,[R7]
	LDR R3,[R5]
	AND R0, R1, #0x300
	LSR R0, R0, #8
	
	AND R8, R2, #0x1000
	LSR R8, #10
	ORR R0, R8
	
	AND R9, R3, #0x20
	LSR R9, #2
	ORR R0, R9
	MVN R0, R0
	MOV R1, R0
	
	BL lightDisplay

		;sw3 = pb9
		;sw2 = pb8
		;sw4 = pc12
		;sw5 = pa5
		;LED1 = PA9
		;LED2 = PA10
		;LED3 = PA11
		;LED4 = PA12
		
	B test
	BX LR
	ENDP