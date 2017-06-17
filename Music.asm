#INCLUDE P16F628A.INC

#DEFINE LED_1	PORTA, 1
#DEFINE LED_2	PORTB, 2
#DEFINE SOM		PORTB, 1	; Define headphones

;	DO		-	262Hz
;	DO#		-	277Hz
;	RE		-	294Hz
;	RE#		-	311Hz
;	MI		-	330Hz
;	FA		-	349Hz
;	FA#		-	370Hz
;	SOL		-	392Hz
;	SOL#		-	415Hz
;	LA		-	440Hz
;	LA#		-	466Hz
;	SI		-	494Hz

			ORG	000H
		
N_DO		EQU	
N_DO_		EQU	
N_RE		EQU	
N_RE_		EQU	
N_MI		EQU	
N_FA		EQU	
N_FA_		EQU	
N_SOL		EQU	
N_SOL_		EQU	
N_LA		EQU	
N_LA_		EQU	
N_SI		EQU	
		
			END
