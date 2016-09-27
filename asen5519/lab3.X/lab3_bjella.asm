;;;;;;; ASEN 4-5519 Lab3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author: Russell Bjella
; Date  : 15-SEP-2016
;
; DESCRIPTION
; On power up execute the following sequence:
; 	D2 ON for ~1 second then OFF
; 	D3 ON for ~1 second then OFF
; 	D4 ON for ~1 second then OFF
; LOOP on the following forever:
; 	Blink "Alive" LED (D6) ON for ~1sec then OFF for ~1sec
; 	Read input from RPG (at least once per millesecond) and output the values on D2 and D3
; 	ASEN5519 ONLY: Read input from SW3 and toggle the value of D4 such that the switch being pressed and
;  		 released causes D4 to change state from ON to OFF or OFF to ON
;	NOTE: ~1 second means +/- 100msec
;
;;;;;;; Program hierarchy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Mainline
;	Loop
; Initial - Initalize ports and countdown D2, D3 and D4
; WaitXXXms - Subroutine to wait XXXms
; Wait1sec - Subroutine to wait 1 sec based on calling WaitXXXms YYY times
; Check_SW3 - Subroutne to check the status of SW3 and change D4 (ASEN5519 ONLY)
; Check_RPG - Read the values of the RPG and display on D2 and D3
;
;;;;;;; Assembler directives ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        LIST  P=PIC18F87K22, F=INHX32, C=160, N=0, ST=OFF, MM=OFF, R=DEC, X=ON
        #include P18F87K22.inc

;		MPLAB 7.20 and later configuration directives
;		Select "Configuration Bits set in code" to use the following configuration
		CONFIG	FOSC = HS1, XINST = OFF
		CONFIG	PWRTEN = ON, BOREN = ON, BORV = 1
		CONFIG 	WDTEN = OFF
		CONFIG	CCP2MX = PORTBE
		


;;;;;;; Hardware notes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   LED D2 port/pin is B5
;   LED D3 port/pin is B6		Students add values/remove question marks
;   LED D4 port/pin is B7
;   PIC board LED D6 port/pin is ?
;   PIC board LED D6 - pull pin ? to turn LED on
;	RPG-A port/pin is ?
;	RPG-B port/pin is ?
;	SW1 port/pin is ?

;;;;;;;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        cblock  0x000   ;Beginning of Access RAM, define your variables here
			CNT	    ;EXAMPLE: variable CNT is at memory address 0x000 in RAM
			VAL1        ;EXAMPLE: variable VAL1 is at memory address 0x001 in RAM
        endc

;;;;;;; Macro definitions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MOVLF is a macro that puts a literal value into a GPR or SFR
MOVLF   macro  literal,dest
        movlw  literal
        movwf  dest
		endm

;;;;;;; Vectors ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        org  0x0000             ;Reset vector
        nop
        goto  Mainline

        org  0x0008             ;High priority interrupt vector
        goto  $                 ;Trap

        org  0x0018             ;Low priority interrupt vector
        goto  $                 ;Trap

;;;;;;; Mainline program ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Mainline
        rcall  Initial          ;Jump to initalization routine
Loop
; PUT YOUR CODE HERE
	MOVF	PORTD,0	    ; Read switch value into WREG
	
        bra  Loop				; Main loop should run forever after entry

;;;;;;; Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine performs all initializations of variables and registers.

Initial
	MOVLF	B'00000000',TRISA	; Set TRISA
	MOVLF	B'00000000',TRISB	; Set TRISB
	MOVLF	B'00000000',TRISD	; Set TRISD
	MOVLF	B'00000000',LATB	; Turn off all LEDS
	RCALL	Wait1sec	; call subroutine to wait 1 second
	BSF	LATB,5	; Turn ON D2
	RCALL	Wait1sec	; call subroutine to wait 1 second
	BCF	LATB,5	; Turn OFF D2
	BSF	LATB,6	; Turn ON D3
	RCALL	Wait1sec	; call subroutine to wait 1 second
	BCF	LATB,6	; Turn OFF D3
	BSF	LATB,7	; Turn ON D4
	RCALL	Wait1sec	; call subroutine to wait 1 second
	BCF	LATB,7	; Turn OFF D4
	BRA	Loop	; Go to infinite loop
        return

;;;;;;; WaitXXXms subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine to wait XXX ms

	; NOTE - STUDENTS replace XXX with some value of your choosing
	; Choose a suitable value based on a single (non-nested) loop structure and 
	; not using an excessive amount of program memory - i.e. don't use 100 nop's
		
WaitXXXms
		; Add code here
	return

;;;;;;; Wait1sec subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine to wait 1 sec based on calling WaitXXXms YYY times
				
Wait1sec
BIGNUM	EQU	65536-39062
	MOVLW	B'00000101'
	MOVWF	T0CON,0
	MOVLW	high BIGNUM
	MOVWF	TMR0H,0
	MOVLW	low BIGNUM
	MOVWF	TMR0L
	BSF	T0CON,7,0
Loop1	
	BTFSS	INTCON,TMR0IF,0	;loop until interrupt flag
	BRA	Loop1
	BCF	T0CON,7,0   ; turn off timer
	BCF	INTCON,TMR0IF,0	;clear the IF
;;;;;;; Check_SW3 subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutne to check the status of SW3 and change D4 (ASEN5519 ONLY)
				
Check_SW3
		; Add code here
		return

;;;;;;; Check_RPG subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutne to read the values of the RPG and display on D2 and D3 
				
Check_RPG
		; Add code here
		return      
        

        end
