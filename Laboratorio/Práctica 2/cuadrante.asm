;###################################################################################################
;#                                                                                                 # 
;#  Programa que indica el cuadrante del plano cartesiano en el cual se encuentra el punto (x, y)  #
;#  dado por el contenido de las localidades 0x20 y 0x21 respectivamente. El cuadrante se indica   #
;#  en la localidad 0x23. Los datos se encuentran representados en complemento a 2.                #
;#                                                                                                 #
;###################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0
	ORG 5
	BTFSS 0x20, 7		;Revisa si el bit 7 de la localidad 0x20 esta encendido
	GOTO X_POSITIVO
	GOTO X_NEGATIVO

X_POSITIVO:
	MOVLW 1			;Guarda un 1 en la localidad 0x22
	MOVWF 0x22
	MOVF 0x21, 0
	GOTO VERIFICA_Y
X_NEGATIVO:
	MOVLW 0			;Guarda un 0 en la localidad 0x22
	MOVWF 0x22
	GOTO VERIFICA_Y

VERIFICA_Y:
	BTFSS 0x21, 7		;Revisa si el bit 7 de la localidad 0x21 esta encendido
	GOTO Y_POSITIVO
	GOTO Y_NEGATIVO

Y_POSITIVO:
	MOVF 0X22, 0
	SUBLW 0 
	BTFSS STATUS, 2   	;Revisa si hay 0 o 1 en 0x20, indica si x es positiva o negativa
	GOTO PRIMER_CUAD
	GOTO SEGUNDO_CUAD

Y_NEGATIVO:
	MOVF 0X22, 0
	SUBLW 0
	BTFSS STATUS, 2		;Revisa si hay 0 o 1 en 0x20, indica si x es positiva o negativa
	GOTO CUARTO_CUAD
	GOTO TERCER_CUAD

PRIMER_CUAD:
	MOVLW 1
	GOTO FIN
SEGUNDO_CUAD:
	MOVLW 2
	GOTO FIN
TERCER_CUAD:
	MOVLW 3
	GOTO FIN
CUARTO_CUAD:
	MOVLW 4
	GOTO FIN
FIN
	MOVWF 0X22
	END



	


