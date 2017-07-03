; ------------------------------------------
; IESB - Sistemas Computacionais: Hardware
; (Prova Substitutiva) Projeto Sirene
; ------------------------------------------
; Orientador / Avaliador:
; 	Luis Carvalho
; Alunos:
;	Leonardo Contri	/	Matricula: 1712082029
;	Nadio Dib		/	Matricula: 1322081004
;
;	Brasilia, 2 de julho de 2017
; ------------------------------------------

#INCLUDE P16F628A.INC

; ------------------------------------------
; Parametros de configuracao do PIC16F628A
; ------------------------------------------
	__CONFIG _BOREN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC
; ------------------------------------------

; ------------------------------------------
; Definicao de constantes, parametros e
; instrucoes utilizadas no algoritmo
; ------------------------------------------
#DEFINE		BANK0	BCF	STATUS,RP0
#DEFINE		BANK1	BSF	STATUS,RP0
#DEFINE		CHAVE1	PORTA,0
#DEFINE		CHAVE2	PORTA,1
#DEFINE		CHAVE3	PORTB,0
#DEFINE		L1_OFF	BSF	PORTB,1
#DEFINE		L1_ON	BCF	PORTB,1
#DEFINE		L2_OFF	BSF	PORTB,2
#DEFINE		L2_ON	BCF	PORTB,2
#DEFINE		SIRENE	PORTB,3
#DEFINE		RELE	PORTB,4
#DEFINE		LAMP	PORTB,5
#DEFINE		TA_CFG	B'11111111'
#DEFINE		TB_CFG	B'11000001'
#DEFINE		OR_CFG	B'10000001'
#DEFINE		IC_CFG	B'10010000'

FREQ	EQU		20H
DL0		EQU		21H
DL1		EQU		22H
DL2		EQU		23H
SAVE_W	EQU		24H
SAVE_S	EQU		25H
FLAGS	EQU		26H

; ------------------------------------------

	ORG		000H
	GOTO	INICIO

; ------------------------------------------
; Tratamento de interrupcoes
; ------------------------------------------
	ORG		004H
	MOVWF	SAVE_W
	SWAPF	STATUS,W
	MOVWF	SAVE_S

	BTFSS	INTCON,INTF		; Testa se foi interrupção externa
	GOTO	INT_TMR
	BCF		INTCON,INTF		; Zera flag da interrupção externa
	L1_OFF					; Apaga leds
	L2_OFF
	BCF		INTCON,T0IE		; Desabilita a interrupção do Timer 0
	BCF		LAMP			; Apaga lâmpada
	BCF		RELE			; Desliga relé
	BSF		FLAGS,0			; Indica ao programa principal que aconteceu uma interrupção externa

INT_TMR:
	MOVFW	FREQ
	MOVWF	TMR0			; Recarrega TMR0 com o valor apropriado pra F1 ou F2
	BCF		INTCON,T0IF

	MOVLW	B'00001000'
	XORWF	PORTB,F			; inverte bit do alto-falante

END_INT:
	SWAPF	SAVE_S,W
	MOVWF	STATUS
	SWAPF	SAVE_W,F
	SWAPF	SAVE_W,W
	RETFIE
; ------------------------------------------

; ------------------------------------------
; Delay de 500ms ou 0,5s
; ------------------------------------------
DELAY:
	MOVLW	.2
	MOVWF	DL2
LOOP_250MS:
	MOVLW	.250
	MOVWF	DL1
LOOP_1MS:
	MOVLW	.250
	MOVWF	DL0
LOOP:
	NOP
	DECFSZ	DL0,F
	GOTO	LOOP
	DECFSZ	DL1,F
	GOTO	LOOP_1MS
	DECFSZ	DL2,F
	GOTO	LOOP_250MS
	RETURN
; ------------------------------------------

; ------------------------------------------
; Inicio do algoritmo
; ------------------------------------------
INICIO:
; Mudanca para o banco 1 da RAM para
; configuracao de TRISA, TRISB, OPTION_REG,
; INTCON e CMCON
	BANK1
	MOVLW	TA_CFG
	MOVWF	TRISA
	MOVLW	TB_CFG
	MOVWF	TRISB
	MOVLW	OR_CFG
	MOVWF	OPTION_REG
	MOVLW	IC_CFG
	MOVWF	INTCON
	BANK0
; Desabilitacao dos comparadores
	MOVLW	7
	MOVWF	CMCON
; Limpa os valores possivelmente setados de
; PORTA e PORTB para uma inicializacao correta
VOLTA:
	CLRF	FLAGS
	CLRF	PORTB
	L1_OFF
	L2_OFF
; Se CHAVE2 for acionado o procedimento de
; variacao dos leds ficara ativado, possibilitando
; assim sua inversao
LE_CH1:
	BTFSC	CHAVE1
	GOTO	LE_CH2

	BCF		FLAGS,0
	BTFSS	RELE		; Testa se carro ligado
	GOTO	LE_CH2

	BSF		INTCON,T0IE

; Procedimento de inversao dos leds L1 e L2
PISCA:
	L1_ON
	L2_OFF
; 3 representa o valor repassado ao TMR0 vindo
; de FREQ da frequencia de 494Hz de T/2=1012ms
; Se CHAVE3 for acionado o algoritmo redireciona
; para a label SHTDWN
	MOVLW	.3
	MOVWF	FREQ
	CALL	DELAY		; Espera 0,5 seg
	BTFSC	FLAGS,0
	GOTO	VOLTA

	L1_OFF
	L2_ON
; 43 representa o valor repassado ao TMR0 vindo
; de FREQ da frequencia de 587Hz de T/2=852ms
	MOVLW	.43
	MOVWF	FREQ
	CALL	DELAY		; Espera 0,5 seg
	BTFSC	FLAGS,0
	GOTO	VOLTA
	GOTO	PISCA

LE_CH2:
	BTFSC	CHAVE2
	GOTO	LE_CH1

	BCF		FLAGS,0
	BSF		LAMP
	BSF		RELE

	GOTO	LE_CH1

	END
; ------------------------------------------

; Referencias Bibliograficas:
;	http://www.boscojr.com/arquitetura/arquivos/lab4.pdf
;	http://larios.tecnologia.ws/iBlog/wp-content/photos/2013/08/musica_asm.txt
;	https://iesb.blackboard.com/bbcswebdav/pid-434928-dt-content-rid-1830453_1/courses/ENG030-200988/ConjInst_PIC16F628A.pdf
;	Desbravando o PIC, Ampliado e Atualizado para PIC16F628A. David Jose de Souza. Editora Etica, 8a edicao
;	PIC Programming for Beginners. Mark Spencer, WA8SME. 2010
