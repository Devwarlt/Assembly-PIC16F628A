
;=====================================================================================================

;	PROJETO    MUSICA COM PIC

;   INICIO : 22/08/13 TERM.:30/08/13
;	AUTOR:  CLÁUDIO LÁRIOS
;	PROCESSADOR:  PIC   16F628A		
;	OBJETIVO: GERAR NOTAS MUSICAIS E SEQUENCIAS MUSICAIS EM UMA SAIDA DO PIC
;   USO PRÁTICO: SONORIZAR PEQUENOS BRINQUEDOS, CAMPAINHAS MUSICAIS, SINALIZADORES DE INTRUSÃO, PEQUENOS ORGÃOS 
;==============================================================================================================
;ARQUIVOS PARA COMPILAÇÃO
	LIST P=16f628a , R=DEC
    INCLUDE "P16F628a.INC" ;ARQUIVO PADRAO	
  	ERRORLEVEL      -302   ;ELIMINA MENSAGEM DE ERRO
;==============================================================================================================  
;PALAVRA DE CONFIGURAÇÃO
  __CONFIG		_CP_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _BODEN_ON  & _MCLRE_ON & _LVP_OFF 
;===============================================================================================================	    
;TROCA DE BANCOS
#DEFINE		BANK0	BCF	STATUS,RP0 	;SETA BANK0 DE MEMORIA
#DEFINE		BANK1	BSF	STATUS,RP0	;SETA BANK1
;================================================================================================================
;RAM
	     CBLOCK		0X20		;ENDERECO INICIAL DE MEMORIA
		       TEMP, TEMP1, TEMP2,TEMPO, TMRH_AUX,TMRL_AUX
                ENDC
         CBLOCK     0X70
         W_TEMP,STATUS_TEMP
                ENDC
;EQUATES COM CARGA DO TIMER 1 PARA AS RESPECTIVAS NOTAS MUSICAIS
          
C_H     EQU  HIGH (0X10000 -(.500000/.262)) ;C=262 Hz / DO
C_L     EQU  LOW (0X10000 -(.500000/.262))

DB_H     EQU  HIGH(0X10000 -(.500000/.277)) ;Db=277 Hz / RE bemol
DB_L     EQU  LOW (0X10000 -(.500000/.277))

D_H     EQU  HIGH(0X10000  -(.500000/.294)) ;D=294 Hz/ RE
D_L     EQU  LOW (0X10000  -(.500000/.294)) 

EB_H     EQU  HIGH(0X10000  -(.500000/.311))  ;Eb=311 Hz / MI bemol
EB_L     EQU  LOW (0X10000  -(.500000/.311)) 

E_H     EQU  HIGH(0X10000  -(.500000/.330))  ;E=330 / MI
E_L     EQU  LOW (0X10000  -(.500000/.330)) 

F_H     EQU  HIGH(0X10000  -(.500000/.349))  ;F=349 / FA
F_L     EQU  LOW (0X10000  -(.500000/.349)) 

GB_H     EQU  HIGH(0X10000  -(.500000/.370))  ;Gb=370 / SOL bemol
GB_L     EQU  LOW (0X10000  -(.500000/.370)) 

G_H     EQU  HIGH(0X10000  -(.500000/.392))   ;G=392 / SOL
G_L     EQU  LOW (0X10000  -(.500000/.392)) 

AB_H     EQU  HIGH(0X10000  -(.500000/.415))  ;Ab=415 / LA bemol
AB_L     EQU  LOW (0X10000  -(.500000/.415)) 

A_H     EQU  HIGH(0X10000  -(.500000/.440))  ;A=440 / LA
A_L     EQU  LOW (0X10000  -(.500000/.440)) 

BB_H     EQU  HIGH(0X10000 -(.500000/.466))  ;Bb=466 / SI bemol
BB_L     EQU  LOW (0X10000 -(.500000/.466)) 

B_H     EQU  HIGH(0X10000  -(.500000/.494))  ;B=494 / SI
B_L     EQU  LOW (0X10000 -(.500000/.494)) 

;=============================================================
;       OITAVA SUPERIOR  (OITAVADO)
C1_H     EQU  HIGH (0X10000 -(.500000/.523)) ;C=523 Hz / DO
C1_L     EQU  LOW (0X10000 -(.500000/.523))

DB1_H    EQU  HIGH(0X10000 -(.500000/.554)) ;Db=554 Hz / RE bemol
DB1_L     EQU  LOW (0X10000 -(.500000/.554))

D1_H     EQU  HIGH(0X10000  -(.500000/.587)) ;D=587 Hz/ RE
D1_L     EQU  LOW (0X10000  -(.500000/.587)) 

EB1_H     EQU  HIGH(0X10000  -(.500000/.622))  ;Eb=622 / MI bemol
EB1_L     EQU  LOW (0X10000  -(.500000/.622)) 

E1_H     EQU  HIGH(0X10000  -(.500000/.659))  ;E=659 / MI
E1_L     EQU  LOW (0X10000  -(.500000/.659)) 

F1_H     EQU  HIGH(0X10000  -(.500000/.698))  ;F=698 / FA
F1_L     EQU  LOW (0X10000 -(.500000/.698)) 

GB1_H     EQU  HIGH(0X10000  -(.500000/.740))  ;Gb=740 / SOL bemol
GB1_L     EQU  LOW (0X10000  -(.500000/.740)) 

G1_H     EQU  HIGH(0X10000  -(.500000/.784))   ;G=784 / SOL
G1_L     EQU  LOW (0X10000  -(.500000/.784)) 

AB1_H     EQU  HIGH(0X10000  -(.500000/.831))  ;Ab=831 / LA bemol
AB1_L     EQU  LOW (0X10000  -(.500000/.831)) 

A1_H     EQU  HIGH(0X10000  -(.500000/.880))  ;A=880 / LA
A1_L     EQU  LOW (0X10000  -(.500000/.880)) 

BB1_H     EQU  HIGH(0X10000 -(.500000/.933))  ;Bb=932 / SI bemol
BB1_L     EQU  LOW (0X10000 -(.500000/.933)) 

B1_H     EQU  HIGH(0X10000  -(.500000/.988))  ;B=988 / SI
B1_L     EQU  LOW (0X10000 -(.500000/.988)) 


#DEFINE   SOM   PORTA,2	;SAIDA DO SOM MUSICAL  PINO 1
;==================================================================================================
;							VETOR DE  RESET
		ORG 0X00	
 			GOTO INICIO
;===================================================================================================
;						VETOR DE INTERRUPCAO
;===================================================================================================
		ORG	0X04
INT_TMR1
 	MOVWF    W_TEMP       ;SALVA 'W'     (MODO COMPILER)
  	MOVF     STATUS,W    ;SALVA 'STATUS'
  	MOVWF    STATUS_TEMP
    
	BANK0
    BTFSS    PIR1,0
    GOTO     INT_TMR0
    BCF      PIR1,0       ;APAGA FLAG DO TMR1
    MOVFW    TMRH_AUX
    MOVWF    TMR1H
    MOVFW    TMRL_AUX
    MOVWF    TMR1L
    BTFSS    SOM
    GOTO     L_SOM
    BCF      SOM
    GOTO     SAI_INT
L_SOM
    BSF      SOM
    GOTO     SAI_INT
INT_TMR0
	BTFSS    INTCON,T0IF
    GOTO     SAI_INT
    DECF     TEMPO,F
    BCF      INTCON,T0IF

   
SAI_INT
   	MOVF   STATUS_TEMP,W   ;RECUPERA 'STATUS' (MODO COMPILER)
    MOVWF  STATUS
   	SWAPF  W_TEMP,F        ;RECUPERA 'W'
    SWAPF  W_TEMP,W        
    RETFIE

		
;=================================================================================================
; INICIALIZAÇÃO DE REGISTRADORES E PORTAS
;=================================================================================================
INICIO
			BANK1	       			;BANCO  1
			MOVLW		b'11111011'			;DEFINE ENTRADAS (1) E SAIDAS (0) NA PIO
			MOVWF		TRISA		;
			MOVLW		b'11111111'
			MOVWF		TRISB

			MOVLW       B'10000100' ; TMR0/16
            MOVWF      	OPTION_REG	;
		    BSF         PIE1,0      ;LIGA INTERRUPÇÃO DO TIMER1
			BANK0
			MOVLW		.7          ;CONFIGURA PARA UM COMPARADOR APENAS
			MOVWF		CMCON
		    MOVLW       0X01        ;PRESCALLER /1 NO TMR1
            MOVWF       T1CON       ;LIGA TIMER 1
   	        MOVLW		B'01100000' ;LIGA INTERRUPÇÃO PERIFÉRICOS E TMR0
	        MOVWF		INTCON		;DESLIGA TODAS INTERRUPCOES
			CLRF		PORTA		;LIMPA PORTA
            CLRF        PORTB		;LIMPA PORTB
	
;==============================================================================================
;         LOOP   PRINCIPAL
;==============================================================================================

MAIN	

    CALL      TOUREADA
	MOVLW     .4
    CALL     DELAY_G

	CALL      SUPER_MARIO_BROS_THEME    ;SUPER MARIO BROS (BREVE INTRODUÇÃO)

  	MOVLW     .4
    CALL     DELAY_G

 	CALL      SWEET_CHILD_O_MINE	    ;EXECUTA (INICIO DA MÚSICA APENAS)

    MOVLW     .4
   CALL     DELAY_G



    GOTO      MAIN








;==============================================================================================
;     ROTINA COM  MUSICA  N.1
;==============================================================================================
SUPER_MARIO_BROS_THEME
   	MOVLW     .40          ;PRIMEIRA ESTROFE
    CALL      N_E1

	MOVLW     .10         ;PAUSA
    CALL      DELAY_W

   	MOVLW     .30          
    CALL      N_E1
   	MOVLW     .30          
    CALL      N_E1

	MOVLW     .30		  ;PAUSA
    CALL      DELAY_W

   	MOVLW     .30          
    CALL      N_C1
   	MOVLW     .30          
    CALL      N_E1

   	MOVLW     .60          
    CALL      N_G1 

	MOVLW     .30		  ;PAUSA
    CALL      DELAY_W

;======================================


   	MOVLW     .30          
    CALL      N_C  

   	MOVLW     .30          
    CALL      N_C  

 
   	MOVLW     .30          
    CALL      N_G 
 

   	MOVLW     .30          
    CALL      N_E  

 	MOVLW     .30          
    CALL      N_E  

    MOVLW     .60
    CALL      DELAY_W

   	MOVLW     .30          
    CALL      N_A1  

   	MOVLW     .30          
    CALL      N_A1  

   	MOVLW     .30          
    CALL      N_B1 

   	MOVLW     .30          
    CALL      N_A1 

 
   	MOVLW     .30          
    CALL      N_G1 
    RETURN
;=================================================================================================
;                       ROTINA DE  MUSICA N.2
;=================================================================================================
SWEET_CHILD_O_MINE

	MOVLW     .30          ;PRIMEIRA ESTROFE
    CALL      N_D
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_G1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_GB1
   	MOVLW     .30
    CALL      N_A
 
	MOVLW     .30
    CALL      N_D
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_G1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_GB1
	MOVLW     .30
    CALL      N_A

    MOVLW     .30		    ;PAUSA
    CALL      DELAY_W
                       
 	MOVLW     .30			;SEGUNDA ESTROFE
    CALL      N_E
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_G1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_GB1
   	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_G1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_GB1
	MOVLW     .30
    CALL      N_A

    MOVLW     .30		;PAUSA
    CALL      DELAY_W
 
	MOVLW     .30		;TERCEIRA ESTROFE
    CALL      N_G
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_G1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_GB1
   	MOVLW     .30
    CALL      N_A

    MOVLW     .30		;PAUSA
    CALL      DELAY_W

	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_G
	MOVLW     .30
    CALL      N_G1
	MOVLW     .30
    CALL      N_A
	MOVLW     .30
    CALL      N_GB1
	MOVLW     .30
    CALL      N_A

    MOVLW     .30		;PAUSA
    CALL      DELAY_W

   	MOVLW     .30		;ESTROFE FINAL DA INTRODUÇÃO
    CALL      N_E1 
	MOVLW     .30
    CALL      N_A1
	MOVLW     .30
    CALL      N_D1
	MOVLW     .30
    CALL      N_A1
	MOVLW     .30
    CALL      N_E1 
	MOVLW     .30
    CALL      N_A1
	MOVLW     .30
    CALL      N_GB1 
	MOVLW     .30
    CALL      N_A1
	MOVLW    .30
    CALL      N_G1 
	MOVLW     .30
    CALL      N_A1
	MOVLW     .30
    CALL      N_GB1 
	MOVLW     .30
    CALL      N_A1
	MOVLW     .30
    CALL      N_E1
	MOVLW     .30
    CALL      N_A1
	MOVLW     .30
    CALL      N_D1
    RETURN
;=================================================================================================
;                       ROTINA DE  MUSICA N.3
;=================================================================================================
TOUREADA

	MOVLW     .35          
    CALL      N_E1
   	MOVLW     .35          
    CALL      N_E1 
	MOVLW     .35          
    CALL      N_E1
   	MOVLW     .35          
    CALL      N_E1 
	MOVLW     .35         
    CALL      N_E1
   	MOVLW     .35         
    CALL      N_E1 




	MOVLW     .35          
    CALL      N_F1
   	MOVLW     .35          
    CALL      N_F1 
	MOVLW     .35          
    CALL      N_F1
   	MOVLW     .35          
    CALL      N_F1 
	MOVLW     .35          
    CALL      N_F1
   	MOVLW     .35         
    CALL      N_F1


	MOVLW     .35         
    CALL      N_E1
   	MOVLW     .35          
    CALL      N_E1 
	MOVLW     .35         
    CALL      N_E1
   	MOVLW     .35          
    CALL      N_E1 
	MOVLW     .35          
    CALL      N_E1
   	MOVLW     .35         
    CALL      N_E1 

   	MOVLW     .35          
    CALL      N_F1

	MOVLW     .255
    CALL      DELAY_W
	MOVLW     .255
    CALL      DELAY_W

   	MOVLW     .30          
    CALL      N_G1  

   	MOVLW     .30          
    CALL      N_F1


   	MOVLW     .30          
    CALL      N_E1


		RETURN







;=================================================================================================
;                    ROTINAS PARA GERAÇÃO DE NOTAS MUSICAIS
;=================================================================================================

N_C  ;DÓ

	MOVWF   TEMPO
    MOVLW   C_H
    MOVWF   TMRH_AUX
    MOVLW   C_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_C1 ;DÓ OITAVADO

	MOVWF   TEMPO
    MOVLW   C1_H
    MOVWF   TMRH_AUX
    MOVLW   C1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS



N_DB ;RÉ BEMOL
	MOVWF   TEMPO
    MOVLW   DB_H
    MOVWF   TMRH_AUX
    MOVLW   DB_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_DB1  ;RÉ BEMOL OITAVADO
	MOVWF   TEMPO
    MOVLW   DB1_H
    MOVWF   TMRH_AUX
    MOVLW   DB1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

 
N_D ;RÉ
	MOVWF   TEMPO
    MOVLW   D_H
    MOVWF   TMRH_AUX
    MOVLW   D_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_D1 ;RÉ   OITAVADO
	MOVWF   TEMPO
    MOVLW   D1_H
    MOVWF   TMRH_AUX
    MOVLW   D1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_EB ;MÍ  BEMOL
	MOVWF   TEMPO
    MOVLW   EB_H
    MOVWF   TMRH_AUX
    MOVLW   EB_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_EB1  ;MÍ BEMOL OITAVADO
	MOVWF   TEMPO
    MOVLW   EB1_H
    MOVWF   TMRH_AUX
    MOVLW   EB1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_E   ;MÍ
	MOVWF   TEMPO
    MOVLW   E_H
    MOVWF   TMRH_AUX
    MOVLW   E_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_E1  ;MÍ OITAVADO
	MOVWF   TEMPO
    MOVLW   E1_H
    MOVWF   TMRH_AUX
    MOVLW   E1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_F  ;FÁ
	MOVWF   TEMPO
    MOVLW   F_H
    MOVWF   TMRH_AUX
    MOVLW   F_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_F1  ;FÁ OITAVADO
	MOVWF   TEMPO
    MOVLW   F1_H
    MOVWF   TMRH_AUX
    MOVLW   F1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_GB  ;SOL BEMOL
	MOVWF   TEMPO
    MOVLW   GB_H
    MOVWF   TMRH_AUX
    MOVLW   GB_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_GB1  ; SOL BEMOL OITAVADO
	MOVWF   TEMPO
    MOVLW   GB1_H
    MOVWF   TMRH_AUX
    MOVLW   GB1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_G   ;SOL
	MOVWF   TEMPO
    MOVLW   G_H
    MOVWF   TMRH_AUX
    MOVLW   G_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_G1  ;SOL OITAVADO
	MOVWF   TEMPO
    MOVLW   G1_H
    MOVWF   TMRH_AUX
    MOVLW   G1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_AB  ; LÁ BEMOL
	MOVWF   TEMPO
    MOVLW   AB_H
    MOVWF   TMRH_AUX
    MOVLW   AB_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_AB1  ;LÁ BEMOL OITAVADO
	MOVWF   TEMPO
    MOVLW   AB1_H
    MOVWF   TMRH_AUX
    MOVLW   AB1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_A    ; LÁ
	MOVWF   TEMPO
    MOVLW   A_H
    MOVWF   TMRH_AUX
    MOVLW   A_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_A1   ;LÁ OITAVADO
	MOVWF   TEMPO
    MOVLW   A1_H
    MOVWF   TMRH_AUX
    MOVLW   A1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_BB   ; SÍ BEMOL
	MOVWF   TEMPO
    MOVLW   BB_H
    MOVWF   TMRH_AUX
    MOVLW   BB_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_BB1  ;SÍ BEMOL OITAVADO
	MOVWF   TEMPO
    MOVLW   BB1_H
    MOVWF   TMRH_AUX
    MOVLW   BB1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

  
N_B  ;SÍ
	MOVWF   TEMPO
    MOVLW   B_H
    MOVWF   TMRH_AUX
    MOVLW   B_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

N_B1 ;SÍ OITAVADO
	MOVWF   TEMPO
    MOVLW   B1_H
    MOVWF   TMRH_AUX
    MOVLW   B1_L
    MOVWF   TMRL_AUX
    GOTO    INIT_MUS

; ROTINA COMPLEMENTAR
INIT_MUS
    BSF     INTCON,GIE
    MOVF    TEMPO,F
    BTFSS   STATUS,Z
    GOTO    $-2
    BCF     SOM
    BCF     INTCON,GIE
    MOVLW   .0
   ;PAUSA  NO FINAL DA NOTA
T_ESP1
    ADDLW   .1
    GOTO   $+1
    GOTO   $+1
    GOTO   $+1
    GOTO   $+1
	GOTO   $+1
	GOTO   $+1
    GOTO   $+1
    GOTO   $+1
    GOTO   $+1
    GOTO   $+1
	GOTO   $+1
	GOTO   $+1
    BTFSS  STATUS,Z
    GOTO   T_ESP1
	RETURN



; DELAY DE PAUSAS

DELAY_G
    MOVFW   TEMP
V_TY1
    MOVLW   .10
    CALL    DELAY_W
    DECFSZ  TEMP,F
    GOTO    V_TY1
    RETURN


DELAY_W
    MOVWF   TEMP2
V_DF1
    MOVLW   .250
    MOVWF   TEMP1
    DECFSZ  TEMP1,F
    GOTO    $-1
    DECFSZ  TEMP2,F
    GOTO    V_DF1
    RETURN

			END
