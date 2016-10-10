;;;;;;; ASEN 4-5519 Lab 4 Example code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   ____ THIS IS NOT A TEMPLATE TO USE FOR LAB 4 _____
;
;   .... THIS CODE PROVIDES EXAMPLE FUNCTIONALITY ....
;
;   .... THE TIMING IN THIS CODE IS DIFFERENT THAN REQUIRED FOR LAB 4 ....
;
;   .... USE YOUR LAB 3 SOURCE FILE AS A STARTING POINT FOR LAB 4 ...
; 
;   .... YOU MAY REUSE PARTS OF THIS CODE IF THEY SUIT YOUR PURPOSE, BUT
;   .... GIVE CREDIT IN YOUR COMMENTS FOR ANY CODE YOU USE FROM HERE
;        FOR EXAMPLE (;   This subroutine is copied (or a modified version) of 
;                     ;   the subroutine XXX in the lab4_example.asm file)
;
; DESCRIPTION
; On power up exceute the following sequence:
;   D2,D4,D4 and D6 should be off
; 	D2 ON for ~1 second then OFF
; 	D3 ON for ~1 second then OFF
; 	D4 ON for ~1 second then OFF
;   'ASEN5519' is output on the first line of the LCD 
; LOOP on the following forever:
; 	Blink "Alive" LED (D6) ON for ~250 ms then OFF for ~250 ms
;   Generate PWM signal on RC2, period of T = 20ms, 5% duty cycle. Accurate to
;   +/- 100us
;   Switch checking:
;     ASEN 4519: SW1 press and release switches between 5% to 10% duty cycle
;                (i.e. 2ms on / 18ms off). The second line of the LCD displays
;                the current pulse width (i.e. 'PW=1.0ms') ;
;     ASEN 5519: SW1 press and release increments the ontime (and decrements the
;                offtime) of the PWM signal by 0.2ms each switch press, until
;                2ms on / 18ms off is reached, then reset to 1ms on / 19ms off.
;                The second line of the LCD displays the current pulse width 
;                (i.e. 'PW=1.2ms')
;
; NOTES:
;   ~1 second means +/- 10msec, ~250 ms means +/- 10msec
;   Use Timer0 for ten millisecond looptime.
;
;;;;;;; Program hierarchy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Mainline
;   Initial
;      BlinkAlive
;      LoopTime
;
;;;;;;; Assembler directives ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        LIST  P=PIC18F87K22, F=INHX32, C=160, N=0, ST=OFF, MM=OFF, R=DEC, X=ON
        #include P18F87K22.inc

;		MPLAB 7.20 and later configuration directives
;		Select "Configuration Bits set in code" to use the following configuration
		CONFIG	FOSC = HS1, XINST = OFF
		CONFIG	PWRTEN = ON, BOREN = ON, BORV = 1
		CONFIG 	WDTEN = OFF
		CONFIG	CCP2MX = PORTC

;;;;;;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        cblock  0x000                  ;Beginning of Access RAM
        INTCONCOPY                     ;Copy of INTCON for LoopTime subroutine
        COUNT                          ;Counter available as local to subroutines
        ALIVECNT                       ;Counter for blinking "Alive" LED
        BYTE                           ;Eight-bit byte to be displayed
        BYTESTR:10                     ;Display string for binary version of BYTE
        temp
        endc

;;;;;;; Macro definitions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MOVLF   macro  literal,dest
        movlw  literal
        movwf  dest
        endm

POINT   macro  stringname
        MOVLF  high stringname, TBLPTRH
        MOVLF  low stringname, TBLPTRL
        endm

DISPLAY macro  register         ;Displays a given register in binary on LCD
        movff  register,BYTE
        call  ByteDisplay
        endm
        
;;;;;;; Vectors ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        org  0x0000                    ;Reset vector
        nop 
        goto  Mainline

        org  0x0008                    ;High priority interrupt vector
        goto  $                        ;Trap

        org  0x0018                    ;Low priority interrupt vector
        goto  $                        ;Trap

;;;;;;; Mainline program ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Mainline
        rcall   Initial                 ; Initialize everything
Loop
        btg     LATC,RC2                ; Toggle pin, to support measuring loop time
        rcall   BlinkAlive              ; Blink "Alive" LED
        movlw  B'10101111'              ;
        DISPLAY WREG
        rcall   LoopTime                ; Make looptime be ten milliseconds
        bra     Loop

;;;;;;; Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine performs all initializations of variables and registers.
;
; NOTE: When setting up Ports, always initialize the respective Lat register
;       to a known value!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Initial
        MOVLF   B'00001110',TRISB       ; Set I/O for PORTB
        MOVLF   B'00000000',LATB        ; Initialize PORTB
        MOVLF   B'10010000',TRISC       ; Set I/0 for PORTC
        MOVLF   B'10000000',LATC        ; Initialize PORTC
        MOVLF   B'00001111',TRISJ       ; Set I/O for PORTJ
        bcf     TRISH,1                 ; Set I/O for RH1
        bcf     TRISH,2                 ; Set I/O for RH2

        MOVLF   B'00000000',INTCON
        MOVLF   B'00001000',T0CON       ; Set up Timer0 for a looptime of 10 ms
        MOVLF   high Bignum,TMR0H       ; Writing binary 40536 to TMR0H / TMR0L
        MOVLF   low Bignum,TMR0L

        MOVLF   D'250',ALIVECNT         ; Initializing Alive counter
        bsf     T0CON,7                 ; Turning on Timer0

        rcall   InitLCD                 ; Initialize LCD
        rcall   LoopTime

        POINT   LCDs                    ;Hello
        rcall   DisplayC
        POINT   LCDs2                   ;World!
        rcall   DisplayC

        return

;;;;;;; InitLCD subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize the Optrex 8x2 character LCD.
; First wait for 0.1 second, to get past display's power-on reset time.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
InitLCD
        MOVLF  10,COUNT                ;Wait 0.1 second
L2
          rcall  LoopTime              ;Call LoopTime 10 times
          decf  COUNT,F
        bnz	L2

        bcf     LATH,1                 ;RS=0 for command
        POINT   LCDstr                 ;Set up table pointer to initialization string
        tblrd*                         ;Get first byte from string into TABLAT
L3
          bsf   LATH,2                 ;Drive E high
          movff TABLAT,LATJ            ;Send upper nibble
          bcf   LATH,2                 ;Drive E low so LCD will process input
          rcall LoopTime               ;Wait ten milliseconds
          bsf   LATH,2                 ;Drive E high
          swapf TABLAT,W               ;Swap nibbles
          movwf LATJ                   ;Send lower nibble
          bcf   LATH,2                 ;Drive E low so LCD will process input
          rcall LoopTime               ;Wait ten milliseconds
          tblrd+*                      ;Increment pointer and get next byte
          movf  TABLAT,F               ;Is it zero?
        bnz	L3
        return

;;;;;;; T40 subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Pause for 40 microseconds  or 40/0.4 = 100 clock cycles.
; Assumes 10/4 = 2.5 MHz internal clock rate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
T40
        movlw  100/3                 ;Each REPEAT loop takes 3 cycles
        movwf  COUNT
L4
          decf  COUNT,F
        bnz	L4
        return

;;;;;;;;DisplayC subroutine;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine is called with TBLPTR containing the address of a constant
; display string.  It sends the bytes of the string to the LCD.  The first
; byte sets the cursor position.  The remaining bytes are displayed, beginning
; at that position.
; This subroutine expects a normal one-byte cursor-positioning code, 0xhh, or
; an occasionally used two-byte cursor-positioning code of the form 0x00hh.

DisplayC
          bcf   LATH,1                  ;Drive RS pin low for cursor-positioning code
          tblrd*                        ;Get byte from string into TABLAT
          movf  TABLAT,F                ;Check for leading zero byte
        bnz	L5
        tblrd+*                       ;If zero, get next byte
L5
          bsf   LATH,2               ;Drive E pin high
          movff TABLAT,LATJ         ;Send upper nibble
          bcf   LATH,2               ;Drive E pin low so LCD will accept nibble
          bsf   LATH,2               ;Drive E pin high again
          swapf TABLAT,W             ;Swap nibbles
          movwf LATJ                 ;Write lower nibble
          bcf   LATH,2               ;Drive E pin low so LCD will process byte
          rcall T40                  ;Wait 40 usec
          bsf   LATH,1               ;Drive RS pin high for displayable characters
          tblrd+*                    ;Increment pointer, then get next byte
          movf  TABLAT,F             ;Is it zero?
        bnz	L5
        return

;;;;;;; DisplayV subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine is called with FSR0 containing the address of a variable
; display string.  It sends the bytes of the string to the LCD.  The first
; byte sets the cursor position.  The remaining bytes are displayed, beginning
; at that position.

DisplayV
        bcf     LATH,1                 ;Drive RS pin low for cursor positioning code
L7
          bsf   LATH,2                 ;Drive E pin high
          movff INDF0,LATJ             ;Send upper nibble
          bcf   LATH,2                 ;Drive E pin low so LCD will accept nibble
          bsf   LATH,2                 ;Drive E pin high again
          swapf INDF0,W                ;Swap nibbles
          movwf LATJ                   ;Write lower nibble
          bcf   LATH,2                 ;Drive E pin low so LCD will process byte
          rcall T40                    ;Wait 40 usec
          bsf   LATH,1                 ;Drive RS pin high for displayable characters
          movf  PREINC0,W              ;Increment pointer, then get next byte
        bnz	L7
        return
        
;;;;;;; BlinkAlive subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine briefly blinks the LED next to the PIC every two-and-a-half
; seconds.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BlinkAlive
        bsf     LATB,RB4       ; Turn off LED
        decf    ALIVECNT,F      ; Decrement loop counter and ...
        bnz     END1            ; return if not zero
        MOVLF   250,ALIVECNT    ; Reinitialize BLNKCNT
        bcf     LATB,RB4       ; Turn on LED for ten milliseconds every 2.5 sec
END1
        return

;;;;;;; LoopTime subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine waits for Timer0 to complete its ten millisecond count
; sequence. It does so by waiting for sixteen-bit Timer0 to roll over. To obtain
; a period of 10000/0.4 = 25000 clock periods, it needs to remove
; 65536-25000 or 40536 counts from the sixteen-bit count sequence.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bignum  equ     65536-25000

LoopTime
        btfss 	INTCON,TMR0IF           ; Read Timer0 rollover flag and ...
        bra     LoopTime                ; Loop if timer has not rolled over
        MOVLF  	high Bignum,TMR0H       ; Then write the timer values into
        MOVLF  	low Bignum,TMR0L        ; the timer high and low registers
        bcf  	INTCON,TMR0IF           ; Clear Timer0 rollover flag
        return

;;;;;;; ByteDisplay subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Display whatever is in BYTE as a binary number.

ByteDisplay
        POINT   BYTE_1                 ;Display "BYTE="
        rcall   DisplayC
        lfsr    0,BYTESTR+8
L10
          clrf  WREG
          rrcf  BYTE,F                 ;Move bit into carry
          rlcf  WREG,F                 ;and from there into WREG
          iorlw 0x30                   ;Convert to ASCII
          movwf POSTDEC0               ; and move to string
          movf  FSR0L,W                ;Done?
          sublw low BYTESTR
        bnz	L10

        lfsr    0,BYTESTR              ;Set pointer to display string
        MOVLF   0xc0,BYTESTR           ;Add cursor-positioning code
        clrf    BYTESTR+9              ;and end-of-string terminator
        rcall   DisplayV
        return

;;;;;;; Constant strings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LCDstr  db  0x33,0x32,0x28,0x01,0x0c,0x06,0x00  ;Initialization string for LCD
BYTE_1  db  "\x80BYTE=   \x00"         ;Write "BYTE=" to first line of LCD
LCDcl   db  "\x80        \x00"
LCDs    db  "\x80Hello\x00"
LCDs2   db  "\xC0World!\x00"
;;;;;;; End of Program ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        end
