LIST P=16f628a , R=DEC
INCLUDE "P16F628a.INC"
ERRORLEVEL	-302

__CONFIG	_CP_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _BODEN_ON  & _MCLRE_ON & _LVP_OFF

#DEFINE	BANK0	BCF	STATUS,RP0	; Define Bank 0
#DEFINE BANK1	BSF	STATUS,RPG0	; Define Bank 1
#DEFINE	HEADPHONE	PORTA,2		; Define headphone output on pin '1'

CBLOCK	20H	TEMP, TEMP1, TEMP2, TEMPO, TMRH_AUX, TMRL_AUX
ENDC
CBLOCK	70X	W_TEMPO, STATUS_TEMP
ENDC
		
H_DO	EQU	HIGH	(10000H - (.500000/.262))
L_DO	EQU	LOW	(10000H - (.500000/.262))
H_DO_	EQU	HIGH	(10000H - (.500000/.277))
L_DO_	EQU	LOW	(10000H - (.500000/.277))
H_RE	EQU	HIGH	(10000H - (.500000/.294))
L_RE	EQU	LOW	(10000H - (.500000/.294))
H_RE_	EQU	HIGH	(10000H - (.500000/.311))
L_RE_	EQU	LOW	(10000H - (.500000/.311))
H_MI	EQU	HIGH	(10000H - (.500000/.330))
L_MI	EQU	LOW	(10000H - (.500000/.330))
H_FA	EQU	HIGH	(10000H - (.500000/.349))
L_FA	EQU	LOW	(10000H - (.500000/.349))
H_FA_	EQU	HIGH	(10000H - (.500000/.370))
L_FA_	EQU	LOW	(10000H - (.500000/.370))
H_SOL	EQU	HIGH	(10000H - (.500000/.392))
L_SOL	EQU	LOW	(10000H - (.500000/.392))
H_SOL_	EQU	HIGH	(10000H - (.500000/.415))
L_SOL_	EQU	LOW	(10000H - (.500000/.415))
H_LA	EQU	HIGH	(10000H - (.500000/.440))
L_LA	EQU	LOW	(10000H - (.500000/.440))
H_LA_	EQU	HIGH	(10000H - (.500000/.466))
L_LA_	EQU	LOW	(10000H - (.500000/.466))
H_SI	EQU	HIGH	(10000H - (.500000/.494))
L_SI	EQU	LOW	(10000H - (.500000/.494))

	ORG	00H
	
	BANK1
	MOVLW	b'11111011'	; Define input as '1' and output as '0'
	MOVWF	TRISA
	MOVLW	b'11111111'
	MOVWF	TRISB
	MOVLW	b'10000100'	; TMR0(16)
	MOVWF	OPTION_REG
	BSF	PIE1,0		; Set interruption on TMR1
	
	BANK0
	MOVLW	.7
	MOVWF	CMCON
	MOVLW	01H		; PRESCALLER(1) on TMR1
	MOVWF	T1CON		; Turn on TMR1
	MOVLW	b'01100000'	; Set interruption on TMR0
	MOVWF	INTCON		; Turn off all interruptions
	CLRF	PORTA
	CLRF	PORTB
	
MUSIC
	CALL 	JINGLEBELLS
	MOVLW	.4
	CALL	DELAY
	CALL	YESTERDAY
	MOVLW	.4
	CALL	DELAY
	GOTO	MUSIC
	
JINGLEBELLS
; TODO: music
	RETURN
YESTERDAY
; TODO: music
	RETURN

N_DO
	MOVWF	TEMPO
	MOVLW	H_DO
	MOVWF	TMRH_AUX
	MOVLW	L_DO
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_DO_
	MOVWF	TEMPO
	MOVLW	H_DO_
	MOVWF	TMRH_AUX
	MOVLW	L_DO_
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_RE
	MOVWF	TEMPO
	MOVLW	H_RE
	MOVWF	TMRH_AUX
	MOVLW	L_RE
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_RE_
	MOVWF	TEMPO
	MOVLW	H_RE_
	MOVWF	TMRH_AUX
	MOVLW	L_RE_
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_MI
	MOVWF	TEMPO
	MOVLW	H_MI
	MOVWF	TMRH_AUX
	MOVLW	L_MI
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_FA
	MOVWF	TEMPO
	MOVLW	H_FA
	MOVWF	TMRH_AUX
	MOVLW	L_FA
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_FA_
	MOVWF	TEMPO
	MOVLW	H_FA_
	MOVWF	TMRH_AUX
	MOVLW	L_FA_
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_SOL
	MOVWF	TEMPO
	MOVLW	H_SOL
	MOVWF	TMRH_AUX
	MOVLW	L_SOL
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_SOL_
	MOVWF	TEMPO
	MOVLW	H_SOL_
	MOVWF	TMRH_AUX
	MOVLW	L_SOL_
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_LA
	MOVWF	TEMPO
	MOVLW	H_LA
	MOVWF	TMRH_AUX
	MOVLW	L_LA
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_LA_
	MOVWF	TEMPO
	MOVLW	H_LA_
	MOVWF	TMRH_AUX
	MOVLW	L_LA_
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

N_SI
	MOVWF	TEMPO
	MOVLW	H_SI
	MOVWF	TMRH_AUX
	MOVLW	L_SI
	MOVWF	TMRH_AUX
	GOTO	PLAY_CHORD

PLAY_CHORD
	BSF	INTCON,GIE
	MOVW	TEMPO,F
	BTFSS	STATUS,Z
	GOTO	$-2
	BCF	HEADPHONE
	BCF	INTCON,GIE
	MOVLW	.0
LIL_DELAY
	ADDLW	.1
    	GOTO	$+1
    	GOTO	$+1
    	GOTO	$+1
    	GOTO	$+1
	GOTO	$+1
	GOTO	$+1
    	GOTO	$+1
    	GOTO	$+1
    	GOTO	$+1
    	GOTO	$+1
	GOTO	$+1
	GOTO	$+1
	BTFSS	STATUS,Z
	GOTO	LIL_DELAY
	RETURN
DELAY
	MOVFW	TEMP
_A0
	MOVLW	.10
	CALL	DELAY_2
	DECFSZ	TEMP,F
	GOTO	_A0
	RETURN
	
DELAY_2
	MOVWF	TEMP2
_B0
	MOVLW	.250
	MOVWF	TEMP1
	DECFSZ	TEMP1,F
	GOTO	$-1
	DECFSZ	TEMP2,F
	GOTO	_B0
	RETURN
	
	END
