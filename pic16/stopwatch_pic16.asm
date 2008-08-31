	#include <P16f84.INC>
	__CONFIG	_PWRTE_ON & _WDT_OFF & _XT_OSC

; declare variables

w_copy	Equ	0x20
s_copy	Equ	0x21
LcdDaten  Equ	0x22
LcdStatus Equ	0x23
loops	EQU	0x24
loops2	EQU	0x25

; Constants

PORTC	equ	PORTB		; LCD-Control-Port
PORTD	equ	PORTB		; LCD-Daten-Port
LcdE	equ	0		; enable Lcd
LcdRw	equ	3		; read Lcd
LcdRs	equ	2		; data Lcd
Ini_con Equ	B'00000000'	; TMR0 -> Intetupt disable
Ini_opt	Equ	B'00000010'	; pull-up

;**************************************************************
; Program starts here

Init	bsf     STATUS, RP0	; Bank 1
	movlw   Ini_opt     	; pull-up on
	movwf   OPTION_REG
	movlw	B'11111000'	; RA0 .. RA2 outputs, RA3, RA4 input
	movwf	TRISA		;
	movlw	B'00000000'	; PortB alle outputs
	movwf	TRISB
	bcf     STATUS, RP0	; Bank 0
	clrf	PORTA
	clrf	PORTB

	movlw   Ini_con     	; Interupt disable
	movwf   INTCON

	call	InitLCD		; Display initialisieren

;*******************************************************************************
;*******************************************************************************

; 10 Hz-Timer-Interupt einstellen
	bsf     STATUS, RP0
	movlw	B'10000111'
	movwf	OPTION_REG
	movlw	D'56'
	bcf     STATUS, R
	movwf	TMR0

	movlw   2
	movwf	Timer2

	bsf	INTCON, T0IE
	bsf	INTCON, GIE


loop	goto	loop