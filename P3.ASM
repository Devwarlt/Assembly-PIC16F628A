#include P16F628A.INC

SALVAW	EQU	20H
SALVAS	EQU	21H
FREQ	EQU	22H
DL0		EQU	23H
DL1		EQU	24H
DL2		EQU	25H

      	ORG	000H
      	GOTO	INICIO
     		
      	ORG	004H
      	MOVWF	SALVAW
      	SWAPF	STATUS,W
      	MOVWF	SALVAS
      	BTFSS 	INTCON,INTF
      	GOTO 	INTTMR
      	GOTO 	INTEXT
INTTMR:
      	MOVFW 	FREQ
      	MOVWF	TMR0
      	MOVLW	B'10000000'
      	XORWF	PORTB
      
      	MOVF	SALVAW,W
      	SWAPF	SALVAS,W
      	MOVWF	STATUS
      	RETFIE
INICIO:
      	BSF		STATUS,RP0
      	MOVLW 	B'00000111'
      	MOVWF 	TRISB
      	MOVLW 	B'10010000'
      	MOVWF 	INTCON
      	MOVLW 	B'10010001'
      	MOVWF 	OPTION_REG 
      	BCF 	STATUS,RP0
      	BCF 	PORTB,3
      	BCF 	PORTB,4       
      	BSF 	PORTB,5
      	BSF 	PORTB,6
N:
      	BTFSC 	PORTB,2
      	GOTO 	N
      	BSF 	PORTB,3
      	BSF 	PORTB,4
T:   
      	BTFSC 	PORTB,1
      	GOTO 	T
      	BSF 	INTCON,T0IE
LOOP2:
      	BCF 	PORTB,5
      	BSF 	PORTB,6
      	MOVLW 	.3 
      	MOVWF 	FREQ
      	CALL 	DELAY
      	BSF 	PORTB,5
      	BCF 	PORTB,6
      	MOVLW 	.43
      	MOVWF 	FREQ
      	CALL	DELAY
      	GOTO	LOOP2
INTEXT:
      	BCF		PORTB,3
      	BCF 	PORTB,4
      	BSF 	PORTB,5
      	BSF 	PORTB,6
      	BCF 	PORTB,7
      	BCF 	INTCON,INTF
      	GOTO 	REC
REC:
		BCF		INTCON,T0IE
      	SWAPF 	SALVAS,W
      	MOVWF 	STATUS
      	MOVF 	SALVAW,W
      	GOTO 	P
P:
      	BSF 	INTCON,GIE
      	GOTO 	N
DELAY:
      	MOVLW   .2
      	MOVWF   DL2
LOOP_250MS:
      	MOVLW   .250
      	MOVWF   DL1
LOOP_1MS:
      	MOVLW   .200
      	MOVWF   DL0
LOOP:
      	NOP
      	DECFSZ  DL0,F
      	GOTO    LOOP
      	DECFSZ  DL1,F
      	GOTO    LOOP_1MS
      	DECFSZ  DL2,F
      	GOTO    LOOP_250MS
      	RETURN
      	END
