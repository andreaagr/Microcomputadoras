;###########################################################################################################################
;#                                                                                                                         #
;#  Programa que realiza desplazamientos de un bit hacia la izquierda sobre el puerto B, comenzando con 0x01 y terminando  #
;#  en 0x80.Cuando se llega al máximo valor,vuelve a iniciar                                                               #
;#                                                                                                                         #
;###########################################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0
	GOTO INICIO
	ORG 5

INICIO:
	BSF STATUS,RP0  	;Pasamos al banco1 donde se encuentran los TRIS	
	CLRF TRISB			;Todas son salidas
	BSF STATUS,RP1     	;Pasamos al banco 3 para habilitar PORTB como salida digital
	CLRF ANSEL	   		;
	CLRF ANSELH	   		;
	BCF STATUS,RP0		;Regresamos al banco 0
	BCF STATUS,RP1
	GOTO INICIA
	
RECORRE:
	BCF STATUS,C	
	RLF PORTB, F		;Realiza el corrimiento
	MOVF PORTB, 0
	SUBLW 0x80		;Verifica si ya llego al máximo valor
	BTFSS STATUS,Z
	GOTO RECORRE
	GOTO INICIA

INICIA: 
	MOVLW 0x01		;Para comenzar en 1
	MOVWF PORTB
	GOTO RECORRE
	
	END
			
