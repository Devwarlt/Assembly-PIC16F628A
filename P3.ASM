#include P16F628A.INC

SALVAW EQU 20H
SALVAS EQU 21H

   ORG 000H
   GOTO INICIO
     ORG 004H 
     
    MOVWF SALVAW
    SWAPF STATUS,W
    MOVWF SALVAS


    BTFSS INTCON,INTF
    GOTO INTTMR
    GOTO INTEXT
     
    
    
     


INTTMR:MOVFW FREQ
       MOVWF TMR0
       MOVLW '10000000'
       XORWF PORTB
       GOTO TO

TO :   MOVF SALVAW,W
       SWAPF SALVAS,W
       MOVWF STATUS
        RETFIE









INICIO:BSF STATUS,RP0

       MOVLW '00000111'
       MOVWF TRISB
       MOVLW '10010000'
       MOVWF INTCON
       MOVLW '10000001'
       MOVWF OPTION_REG 
       BCF STATUS,RP0
       BCF PORTB,3
       BCF PORTB,4       
       BSF PORTB,5
       BSF PORTB,6




 N:    BTFSC PORTB,2
       GOTO N
       BSF PORTB,3
       BSF PORTB,4
       
  T:   BTFSC PORTB,1
       GOTO T
       
       BSF INTCON,T0IE
LOOP:  BCF PORTB,5
       BSF PORTB,6
       MOVLW .3 
       MOVWF FREQ
       CALL DELAY
       BSF PORTB,5
       BCF PORTB,6
       MOVLW .43
       MOVWF FREQ
       CALL DELAY
       GOTO LOOP
       
       















INTEXT:BCF PORTB,3
       BCF PORTB,4
       BSF PORTB,5
       BSF PORTB,6
       BCF PORTB,7
       BCF INTCON,INTF
       GOTO REC



REC:  SWAPF SALVAS,W
      MOVWF STATUS
      MOVF SALVAW,W
      GOTO P

P:  BSF INTCON,GIE
    GOTO N



       
         
