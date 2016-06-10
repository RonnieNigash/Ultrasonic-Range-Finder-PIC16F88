        list       F=inhx8m, P=16F88, R=hex, N=0 ; File format, chip, and default radix

        #include p16f88.inc ;   PIC 16f88 specific register definitions

__config _CONFIG1, _MCLR_ON & _FOSC_INTOSCCLK & _WDT_OFF & _LVP_OFF & _PWRTE_OFF & _BODEN_ON & _LVP_OFF & _CPD_OFF & _WRT_PROTECT_OFF & _CCP1_RB0 & _CP_OFF
__config _CONFIG2 , _IESO_OFF & _FCMEN_OFF

Errorlevel -302 ; switches off msg [302]: Register in operand not in bank 0.

; Definitions -------------------------------------------------------------

CM_counter  EQU	    H'28'   ; Location to increment on TMR2 interrupt
W_TEMP	    EQU	    H'75'   ; Temporary storage for W and STATUS
STATUS_TEMP EQU	    H'76'   ;    during interrupt

; RAM preserved -----------------------------------------------------------

; Constants --------------------------------------------------------------
CM_period   EQU	    .59	    ; Timer2 interrupts every 0.059 ms

     ; Program Memory ----------------------------------------------------------

            ORG     0x0000
            GOTO    Init

; Interrupt Service Routine -----------------------------------------------
            ORG     0x0004	    ; ISR beginning
            MOVWF   W_TEMP	    ; Copy W to temp location (save W)
        SWAPF   STATUS, W	    ; Use SWAP to Save STATUS without affecting STATUS bits
        MOVWF   STATUS_TEMP

        CLRF    STATUS	         ; Clear STATUS -> bank 0
        INCF    CM_counter, F    ; Increment counter
        CLRF    PIR1	         ; Clear interrupt flags

        SWAPF   STATUS_TEMP, W
        MOVWF   STATUS	         ; Restore STATUS from saved
        SWAPF   W_TEMP, F
        SWAPF   W_TEMP, W	     ; Restore W without affecting STATUS
        RETFIE		             ; END ISR

; Microcontroller initialization
Init    ORG     0x0020

; Turn OFF interrupts
        BANKSEL INTCON
        CLRF    INTCON
        CLRF    PIE1
; Set Internal Oscillator register to 4 MHz clock
SetOSC
        BANKSEL OSCCON
        CLRF    OSCCON
        BSF     OSCCON, .5      ; Set bits 5, 6 in OSCCON register for 4MHz clock
        BSF     OSCCON, .6

        MOVLW   .23             ; Increase clock frequency to make up 8.8%
        MOVWF   OSCTUNE

; Setup I/O
    ; PORTA<0> -> Output
    ; PORTA<1> -> Input
    ; PORTB<7:0> -> Output
SetIO
        BANKSEL PORTA
        CLRF    PORTA
        CLRF    PORTB

        BANKSEL TRISA
        CLRF    ANSEL           ; Digital Inputs only ( set Analog LO )
        CLRF    TRISB           ; PORTB are all outputs
        CLRF    TRISA
        BSF     TRISA,  H'01'   ; PORTA<1> is input

; Set Timer2
SetTimer
        BANKSEL T2CON
        CLRF    T2CON
        BSF     T2CON,  H'02'   ; Timer2 on

        BANKSEL PR2
        MOVLW   CM_period
        MOVWF   PR2

; Turn ON interrupts
        BANKSEL PIR1
        CLRF    PIR1            ; Clear current interrupt flags
        BANKSEL PIE1
        BSF     PIE1,   TMR2IE  ; Enable Timer2 interrupt (using p16f88.inc EQUs)
        BANKSEL INTCON
        BSF     INTCON, PEIE    ; Enable interrupts from peripherals
        BSF     INTCON, GIE     ;       and global interrupts

; MainLoop
        BCF     STATUS, RP0
        BCF     STATUS, RP1     ; Switch to Bank 0, remain here for execution
MainLoop

; Pulse on PORTA<0> for 10 microseconds
Pulse10
        BCF     INTCON, GIE     ; Turn off interrupts for pulse duration
        BSF     PORTA,  RA0     ; Set PORTA, RA0 HI
        NOP                     ; Ten instruction cycles
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        BCF     PORTA,  RA0     ; Set PORTA, RA0 LO
        BSF     INCON,  BIE     ; Turn interrupts back on

; @TODO: Wait for PORTA<1> to go HI, then clear TMR
EchoWaitClear

; @TODO: Wait for PORTA<1> to go LO, then read TMR into W
EndEchoRead

; @TODO: Copy TMR, convert to BCD for display

; @TODO: Delay Routine
Delay

; @TODO: Display Output for 99 digits
DisplayOutput


Finish
         END                 ; end of program
