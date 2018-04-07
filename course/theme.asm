; Advanced Applications of Microcontrollers
; IESB - Engineer Department

#INCLUDE  P16F628A.INC

#DEFINE BANCO0  BCF     STATUS,RP0
#DEFINE BANCO1  BSF     STATUS,RP0
#DEFINE LED1    PORTA,1
#DEFINE LED2    PORTA,2
#DEFINE AF      PORTA,3
#DEFINE LAMP    PORTB,6

FLAGS EQU 20H

ORG 000H

BANCO1
MOVLW B'11111001'
MOVWF TRISA
MOVLW B'10110111'
MOVWF TRISB

BANCO0
BCF AF
BCF LAMP
BSF LED1
BSF LED2

CLRF  FLAGS

END