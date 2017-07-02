MAIN_INT:
; Verifica se a chave 3 foi ativada
	BTFSS	PORTB,CHAVE3
	GOTO		MINOR_INT
; Desabilita todos os bits da PORTB
	MOVLW	B'00000000'
	MOVWF	PORTB
	GOTO		END_INT
MINOR_INT:
	MOVLW	FREQ
	MOVWF	TMR0
	MOVLW	B'00100000'
	XORWF	INTCON,F
	GOTO		MAIN_INT

  #include P16F628A.INC
;RB7=AUTO-FALANTE
;RB5 E RB6=LED
;RB4=RELÉ
;RB3=Lâmpada
;RB2= interruptor 2
;RB1=INTERRUPTOR 1
;RB0=INTERRUPTOR 3
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

; Aula: 03/06/2017 - SENSOR ESTACIONAMENTO
; Leds 1 e 2 piscam alternadamente a 1 Hz
; Sensor do carro lido pela interrupcao externa
;		- Nivel alto -> sem carro
;		- Nivel baixo -> carro passando
; Qdo o sensor eh ativado, os leds devem piscar a 6Hz e o alto-falante
; deve gerar um sinal sonoro de 1KHz durante 10 segundos.
; Se o sensor for acionado novamente durante esse periodo, o ciclo
; de 10 segundos deve ser "reativado".
; Cristal do kit: 4MHz -> CM = 4/Fcristal = 1 useg
; Freq 1Hz -> T = 1/f = 1 segundo, entao T/2 = 0,5 segundos (500 msegundos)
; Freq 6Hz -> T = 166,667 msegundos, entao T/2 = 83,33 msegundos
; Freq 1KHz -> T = 1 msegundo, entao T/2 = 500 usegundos (Int. TMR0)
; Valor TMR0 = 256 - TEMPO/CM -> TMR0 = 256 - 500/1 = -244
; Como o valor deu negativo, eh necessario utilizar o prescaler:
; 	- Na taxa de 1:2 (TMR0 eh incrementado a cada 2CM), temos:
;			TMR0 = 256 - TEMPO/2CM -> TMR0 = 256 - 500/2 = 6
; No "ciclo de 10 segundos", os leds irao piscar a 6Hz, entao, eh
; necessario repetir essas piscadas 60 vezes para dar os 10 segundos
; O programa principal cuida da piscada dos leds e a interrupcao do Timer 0
; cuida da geração do sinal sonoro de 1 KHz.

#INCLUDE P16F628A.INC

#DEFINE	SENSOR	PORTB,0
#DEFINE	LED1	PORTA,1
#DEFINE	LED2	PORTA,2
#DEFINE	AF		PORTB,3

SALVA_W		EQU	20H
SALVA_S		EQU	21H
FLAGS		EQU	22H
CONTA1		EQU	23H
CONTA2		EQU	24H
CONTA3		EQU	25H
TEMPO10		EQU	26H

			ORG		000H
			GOTO	INICIO
			
			ORG		004H
			MOVWF	SALVA_W			; Salva valor de W
			SWAPF	STATUS,W
			MOVWF	SALVA_S			; Salva valor do STATUS

			BTFSS	INTCON,INTF		; Int. externa?
			GOTO	INT_TMR

			BCF		INTCON,INTF		; Zera flag da int. externa
			BSF		FLAGS,0			; Indica que o carro passou pelo sensor	
			GOTO	FIMINT
			
INT_TMR:	MOVLW	.6
			MOVWF	TMR0			; Recarrega TMR0 p/ int. a cada 500 useg
			BCF		INTCON,T0IF		; Zera flag int. TMR0

			BTFSS	FLAGS,1			; Gerar sinal sonoro?
			GOTO	SEMSOM

			MOVLW	B'00001000'
			XORWF	PORTB,F			; Inverte AF
			GOTO	FIMINT

SEMSOM:		BCF		AF				; Desliga alto-falante

FIMINT:		SWAPF	SALVA_S,W
			MOVWF	STATUS
			SWAPF	SALVA_W,F
			SWAPF	SALVA_W,W
			RETFIE

; -> Programa principal

INICIO:		BSF		STATUS,RP0		; Banco 1 da RAM
			MOVLW	B'11111001'
			MOVWF	TRISA
			MOVLW	B'11110111'
			MOVWF	TRISB
			MOVLW	B'10000000'		; Int. externa por borda de descida
									; Prescaler -> TMR0 na taxa de 1:2
			MOVWF	OPTION_REG
			MOVLW	B'10110000'		; Habilita int. externa e do TMR0
			MOVWF	INTCON
			BCF		STATUS,RP0		; Volta p/ banco 0 da RAM

			CLRF	FLAGS

VOLTA:		BCF		AF				; Desliga AF
			BCF		LED1			; Acende Led1
			BSF		LED2			; Apaga Led2

PISCA:		BTFSC	FLAGS,0			; Sensor foi acionado?
			GOTO	ATIVAR

			CALL	LP500MS			; Aguarda 500 mseg (T/2 de 1 Hz)
			MOVLW	B'00000110'
			XORWF	PORTA,F			; Inverte leds
			GOTO	PISCA

ATIVAR:		MOVLW	.120
			MOVWF	TEMPO10			; Repetir a piscada dos leds 120x a 6Hz -> 10 segundos
			BSF		FLAGS,1			; Ativar sinal sonoro
			BCF		FLAGS,0			; Indica que ja reconheceu a passagem do carro
			
PISCA_6HZ:	BTFSC	FLAGS,0			; Sensor acionado novamente
			GOTO	ATIVAR

			CALL	LP83MS			; Tempo para piscada a 6Hz (T/2)
			MOVLW	B'00000110'
			XORWF	PORTA,F			; Inverte leds
			DECFSZ	TEMPO10,F
			GOTO	PISCA_6HZ
			BCF		FLAGS,1			; Desliga sinal sonoro
			GOTO	VOLTA

; Lacos de tempo:

LP500MS:	MOVLW	.5				; 5 x 100 mseg = 500 mseg
			MOVWF	CONTA3
LP100MS:	MOVLW	.100			; 100 x 1 mseg = 100 mseg
			MOVWF	CONTA2
LOOP1:		CALL	LP_1MS
			DECFSZ	CONTA2,F
			GOTO	LOOP1
			DECFSZ	CONTA3,F
			GOTO	LP100MS
			RETURN

LP83MS:		MOVLW	.83				; 83 x 1 mseg = 83 mseg
			MOVWF	CONTA2
LOOP2:		CALL	LP_1MS
			DECFSZ	CONTA2,F
			GOTO	LOOP2
			RETURN

; Lembrando que a estrutura abaixo de laco de tempo resulta em 
; um tempo dado por: TEMPO = 4 x K x CM

LP_1MS:		MOVLW	.250			; 4 x 250 x CM = 1 mseg 
			MOVWF	CONTA1
LOOP:		NOP
			DECFSZ	CONTA1,F
			GOTO	LOOP
			RETURN

			END

#INCLUDE P16F628A.INC

CONTA1	EQU	20H
CONTA2	EQU	21H
M		EQU	60H
X1		EQU	0ADH
X2		EQU	7CH
X3		EQU	84H

		ORG		000H

; Cifra dados contidos em 30H a 4FH

		MOVLW	30H
		MOVWF	FSR		; Aponta posicao de memoria inicial

CIFRA:	MOVFW	INDF
		XORLW	X1		; A xor X1
		MOVWF	INDF	; M = A xor X1
		SWAPF	INDF,W	; W = SWAP(A xor X1)
		ADDLW	X2		; W = X2 + SWAP(A xor X1)
		MOVWF	INDF	; M = X2 + SWAP(A xor X1)

		MOVWF	TXREG	; Simula a transmissao
		CALL	TEMPO	; Aguarda 8,33 mseg (Taxa de 1200 bps)

		INCF	FSR,F	; Aponta proxima posicao da memoria
		MOVLW	50H
		XORWF	FSR,W	; Ponteiro ja atingiu a ultima posicao desejada?
		BTFSS	STATUS,Z
		GOTO	CIFRA	; Nao, cifra proxima posicao

; Decifra os valores contidos em 30H ate 4FH

		MOVLW	30H
		MOVWF	FSR		; Aponta posicao de memoria inicial

DECIFRA:MOVFW	INDF
		ADDLW	X3		; M + X3
		MOVWF	INDF	; A = M + X3
		SWAPF	INDF,W	; W = SWAP(M + X3)
		XORLW	X1		; W = X1 xor SWAP(M + X3)
		MOVWF	INDF	; A = X2 + SWAP(M + X3)

		INCF	FSR,F	; Aponta proxima posicao da memoria
		MOVLW	50H
		XORWF	FSR,W	; Ponteiro ja atingiu a ultima posicao desejada?
		BTFSS	STATUS,Z
		GOTO	DECIFRA	; Nao, decifra proxima posicao

FIM:	GOTO	FIM	

; Taxa de 1200 bps -> Tempo de cada bit = 833,33 useg
; Como sao transmitidos 10 bits (1 Start, 8 bits do dado e 1 Stop),
; o tempo total a ser esperado e de: 833,33 useg x 10 = 8,33 mseg
; Cristal de 6MHz -> CM = 4/Fcristal = 0,66667useg
; TEMPO = 5 x CM x K -> K = 250

TEMPO:	MOVLW	.10
		MOVWF	CONTA2	; 10 x 833,33 useg = 8,33 mseg

LP833US:MOVLW	.250
		MOVWF	CONTA1
LOOP:	NOP
		NOP
		DECFSZ	CONTA1,F
		GOTO	LOOP

		DECFSZ	CONTA2,F
		GOTO	LP833US

		RETURN

		END

#INCLUDE <P16F628A.INC>

F1      EQU     .99
F2      EQU     .199

    ORG     000H
    BCF     INTCON,T0IE
    GOTO INICIO
    
    ORG     004H

;--INTERRUPÇÃO 
;SOM:
;    MOVLW   FREQ
;    MOVWF   TMR0
;    XOR     ???
;    RETFIE
;--

    BSF     INTCON,T0IE
SIRENE:
    ;LED1 ATIVADO / LED2 DESATIVADO
    MOVLW   F1
    MOVWF   FREQ
    CALL    DELAY
    ;LED1 DESATIVADO / LED2 ATIVADO
    MOVLW   F2
    MOVWF   FREQ
    CALL    DELAY
    GOTO    SIRENE
    END

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