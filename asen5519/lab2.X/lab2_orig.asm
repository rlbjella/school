;;;;;;; Lab 2 template for ASEN 4519/5519 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	Created:	Scott Palo (scott.palo@colorado.edu)
;   Modified:   your info here
;	orignal:	10-SEP-06
;   Modified:   
;
;	This file provides a basic assembly programming template
;
;;;;;;; Program hierarchy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Mainline
;   Initial
;
;;;;;;; Assembler directives ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        list  P=PIC18F87K22, F=INHX32, C=160, N=0, ST=OFF, MM=OFF, R=DEC, X=ON
        #include p18f87k22.inc
;		MPLAB 7.20 and later configuration directives
;		Select "Configuration Bits set in code" to use the following configuration
		CONFIG	FOSC = HS1
		CONFIG	PWRTEN = ON, BOREN = ON, BORV = 1, WDTEN = OFF
		CONFIG	CCP2MX = PORTC, XINST = OFF

;;;;;;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        cblock  0x000          ;Beginning of Access RAM
        endc

;;;;;;; Macro definitions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
        rcall  	Initial          ;Initialize everything
Loop
		SWAPF	PORTB,0
		CONF 	WREG,0,0
        MOVWF 	LATB
		bra  	Loop

;;;;;;; Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine performs all initializations of variables and registers.

Initial
        movlw  	B'00001111'		; Set first four bits to input, last 4 to out
		movwf  	TRISB			; Set I/O (TRISB)for PORTB
        return

        end
