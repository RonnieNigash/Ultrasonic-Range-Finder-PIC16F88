list       F=inhx8m, P=16F88, R=hex, N=0 ; File format, chip, and default radix

#include p16f88.inc ;   PIC 16f88 specific register definitions

__config _CONFIG1, _MCLR_ON & _FOSC_INTOSCCLK & _WDT_OFF & _LVP_OFF & _PWRTE_OFF & _BODEN_ON & _LVP_OFF & _CPD_OFF & _WRT_PROTECT_OFF & _CCP1_RB0 & _CP_OFF
__config _CONFIG2 , _IESO_OFF & _FCMEN_OFF

Errorlevel -302 ; switches off msg [302]: Register in operand not in bank 0.

; Definitions -------------------------------------------------------------

; RAM preserved -----------------------------------------------------------

; Constants --------------------------------------------------------------

     ; Program Memory ----------------------------------------------------------

         ORG     0x0000
         GOTO    Init

; Interrupt Service Routine -----------------------------------------------

; Microcontroller initialization
Init    ORG     0x0020





Finish
         END                 ; end of program
