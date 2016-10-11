;;;;;;; ASEN 4-5519 Lab3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author: Russell Bjella
; Date  : 11-OCT-2016
;
; DESCRIPTION
; On power up execute the following sequence:
; 	D2 ON for ~1 second then OFF
; 	D3 ON for ~1 second then OFF
; 	D4 ON for ~1 second then OFF
; LOOP on the following forever:
; 	Blink "Alive" LED (D6) ON for ~250ms then OFF for ~250ms
; 	A periodic pulse is output on RC2 with a period of 20ms and a 5% duty cycle.
;	The second line of the LCD reads 'PW=1.0ms'	
; 	When S1 is pressed and released, the pulse width is increased by 0.2 ms.
;	If the pulse width is 2.0ms, pressing and releasing SW1 resets it to 1.0ms.
;
;;;;;;; Program hierarchy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Mainline
;	Loop
; Initial - Initalize ports and countdown D2, D3 and D4
; Wait2ms - Subroutine to wait XXXms
; Wait1sec - Subroutine to wait 1 sec
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
;   PIC board LED D6 port/pin is B4
;   PIC board LED D6 - pull pin ? to turn LED on
;	RPG-A port/pin is D0
;	RPG-B port/pin is D1
;	SW1 port/pin is D3

;;;;;;;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        cblock  0x000   ;Beginning of Access RAM, define your variables here
			CNT	    ;counter for 2ms wait loop in infinite loop
			COUNT	    ;generic counter for subroutines
			VAL1        ;bit0 is set to 1 if the switch is currently pressed
        endc

;;;;;;; Macro definitions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MOVLF is a macro that puts a literal value into a GPR or SFR
MOVLF   macro  literal,dest
        movlw  literal
        movwf  dest
	endm
	
POINT   macro  stringname
        MOVLF  high stringname, TBLPTRH
        MOVLF  low stringname, TBLPTRL
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
	BTG	LATB,4	; Toggle D6 on/off
	MOVLF	0xFA,CNT    ; Store 250 in CNT for 250ms
; Go through second loop 250 times, waiting 1ms each time
Loop1
	    RCALL   Check_SW1
	    RCALL   Wait0d2ms	;0.2ms
	    RCALL   Check_SW1
	    RCALL   Wait0d2ms	;0.4ms
	    RCALL   Check_SW1
	    RCALL   Wait0d2ms	;0.6ms
	    RCALL   Check_SW1
	    RCALL   Wait0d2ms	;0.8ms
	    RCALL   Check_SW1
	    RCALL   Wait0d2ms	;1.0ms
	    DECF    CNT,1,0	; Decrement counter, started at 250
	    BNZ	    Loop1
	; Loop infinitely through main loop
	bra	Loop				; Main loop should run forever after entry

;;;;;;; Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine performs all initializations of variables and registers.

Initial
	MOVLF	B'00000000',TRISB	; Set TRISB as outputs
	MOVLF	B'00000000',LATB	; Turn off all LEDS
	MOVLF   B'00001111',TRISJ       ; Set I/O for PORTJ
        bcf     TRISH,1                 ; Set I/O for RH1
        bcf     TRISH,2                 ; Set I/O for RH2
	RCALL	Wait1sec
	BSF	LATB,5	; Turn ON D2
	RCALL	Wait1sec
	BCF	LATB,5	; Turn OFF D2
	BSF	LATB,6	; Turn ON D3
	RCALL	Wait1sec
	BCF	LATB,6	; Turn OFF D3
	BSF	LATB,7	; Turn ON D4
	RCALL	Wait1sec
	BCF	LATB,7	; Turn OFF D4
	rcall   InitLCD ; Initialize LCD
	; Display name
	POINT NAME
	rcall	DisplayC
	; Display PW= and ms
	POINT	PWEQ
	rcall	DisplayC
	POINT	MSUNIT
	rcall	DisplayC
	BRA	Loop	; Go to infinite loop
        return
	
;;;;;;; InitLCD subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize the Optrex 8x2 character LCD.
; First wait for 0.1 second, to get past display's power-on reset time.
        
InitLCD
        MOVLF	100,COUNT                ;Wait 0.1 second
L5
        rcall	Wait1ms              ;Call Wait1ms 100 times (100ms)
        decf	COUNT,F
        bnz	L5

        bcf     LATH,1                 ;RS=0 for command
        POINT   LCDstr                 ;Set up table pointer to initialization string
        tblrd*                         ;Get first byte from string into TABLAT
L6
        bsf	LATH,2                 ;Drive E high
        movff	TABLAT,LATJ            ;Send upper nibble
        bcf	LATH,2                 ;Drive E low so LCD will process input
        rcall	Wait1ms               ;Wait ten milliseconds
        bsf	LATH,2                 ;Drive E high
        swapf	TABLAT,W               ;Swap nibbles
        movwf	LATJ                   ;Send lower nibble
        bcf	LATH,2                 ;Drive E low so LCD will process input
        rcall	Wait1ms               ;Wait ten milliseconds
        tblrd+*                      ;Increment pointer and get next byte
        movf	TABLAT,F               ;Is it zero?
        bnz	L6
        return
	
;;;;;;; Wait1sec subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine to wait 1 sec
				
Wait1sec
BIGNUM	EQU	65536-39063
	MOVLW	B'00000101'
	MOVWF	T0CON,0
	MOVLW	high BIGNUM
	MOVWF	TMR0H,0
	MOVLW	low BIGNUM
	MOVWF	TMR0L
	BSF	T0CON,7,0
Loop2	
	BTFSS	INTCON,TMR0IF,0	;loop until interrupt flag
	BRA	Loop2
	BCF	T0CON,7,0   ; turn off timer
	BCF	INTCON,TMR0IF,0	;clear the IF

;;;;;;; Wait0d2ms subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine to wait 0.2 ms		
Wait0d2ms
SMLNUM	EQU	65536-250
	MOVLW	B'00000000' ;set prescaler
	MOVWF	T0CON,0
	MOVLW	high SMLNUM
	MOVWF	TMR0H,0
	MOVLW	low SMLNUM
	MOVWF	TMR0L
	BSF	T0CON,7,0
Loop0d2ms	
	BTFSS	INTCON,TMR0IF,0	;loop until interrupt flag
	BRA	Loop0d2ms
	BCF	T0CON,7,0   ; turn off timer
	BCF	INTCON,TMR0IF,0	;clear the IF
	return
	
;;;;;;; Wait10ms subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine to wait 10 ms		
Wait1ms
MIDNUM	EQU	65536-1250
	MOVLW	B'00000000' ;set prescaler
	MOVWF	T0CON,0
	MOVLW	high MIDNUM
	MOVWF	TMR0H,0
	MOVLW	low MIDNUM
	MOVWF	TMR0L
	BSF	T0CON,7,0
Loop1ms	
	BTFSS	INTCON,TMR0IF,0	;loop until interrupt flag
	BRA	Loop1ms
	BCF	T0CON,7,0   ; turn off timer
	BCF	INTCON,TMR0IF,0	;clear the IF
	return

	
;;;;;;; Check_SW1 subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine to check the status of SW1 and change pulse width				
Check_SW1
	; Check if switch is pressed, skip branch if it is 
	BTFSS	PORTD,3
	BRA	CLRVAL1
	BTFSC	VAL1,0	;if VAL1 bit0 is clear, set true, toggle D4 (released)
	return	; return if VAL1 bit0 is set (wait for release)
	BSF	VAL1,0	;set VAL1 bit0
	BTG	LATB,7	;replace this with pulse width change
	return	
CLRVAL1	; subroutine to clear bit 0 of VAL1 then return
	BCF	VAL1,0
	return
	
;;;;;;;;DisplayC subroutine;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is called with TBLPTR containing the address of a constant
; display string.  It sends the bytes of the string to the LCD.  The first
; byte sets the cursor position.  The remaining bytes are displayed, beginning
; at that position.
; This subroutine expects a normal one-byte cursor-positioning code, 0xhh, or
; an occasionally used two-byte cursor-positioning code of the form 0x00hh.

DisplayC
        bcf	LATH,1                  ;Drive RS pin low for cursor-positioning code
        tblrd*                        ;Get byte from string into TABLAT
        movf	TABLAT,F                ;Check for leading zero byte
        bnz	L7
        tblrd+*                       ;If zero, get next byte
L7
        bsf	LATH,2               ;Drive E pin high
        movff	TABLAT,LATJ         ;Send upper nibble
        bcf	LATH,2               ;Drive E pin low so LCD will accept nibble
        bsf	LATH,2               ;Drive E pin high again
        swapf	TABLAT,W             ;Swap nibbles
        movwf	LATJ                 ;Write lower nibble
        bcf	LATH,2               ;Drive E pin low so LCD will process byte
        rcall	Wait0d2ms                 ;Wait 10ms
        bsf	LATH,1               ;Drive RS pin high for displayable characters
        tblrd+*                    ;Increment pointer, then get next byte
        movf	TABLAT,F             ;Is it zero?
        bnz	L7
        return
	
;;;;;;; Constant strings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCDstr  db  0x33,0x32,0x28,0x01,0x0c,0x06,0x00  ;Initialization string for LCD
NAME	db  "\x82BJELLA\x00"
PWEQ	db  "\xC0PW=\x00"
MSUNIT	db  "\xC6ms\x00"
  
end
