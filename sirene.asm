#INCLUDE <P16F628A.INC>

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

; DELAY PELO LIVRO (MAIS COMPLEXA)
; bloco de memória
;CBLOCK 0x20
;    TEMPO_
;    TEMPO0
;    TEMPO1
;    TEMPO2
;ENDC
;
; inicialização do delay
;DELAY
;    MOVLW   .2
;    MOVWF   TEMPO_
;DL0
;    MOVLW   .250
;    MOVWF   TEMPO0
;DL1
;    MOVLW   .200
;    MOVWF   TEMPO1
;DL2
;    GOTO    $+1
;    DECFSZ  TEMPO1,F
;    GOTO    DL2
;    DECFSZ  TEMPO2,F
;    GOTO    DL1
;    DECFSZ  TEMPO_,F
;    GOTO    DL0
;    RETURN
