;################################################################################################
;#                                                                                              #
;#   Programa que genera sobre el PORTB acciones de acuerdo al estado de los pines RA0 y RA1.   #
;#                                                                                              #
;#   00-> apagar todos los bits                                                                 #
;#   01-> desplazamiento de bits a la derecha                                                   #
;#   10-> desplazamiento de bits a la izquierda                                                 #
;#   11-> invertir los bits                                                                     #
;#                                                                                              #
;################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0
	ORG 5
	CLRF PORTA
	CLRF PORTB
	BSF STATUS,RP0  		;Pasamos al banco1 donde se encuentran los TRIS	
	CLRF TRISB			;Todas son salidas en el puerto B
	BSF STATUS,RP1  		;Pasamos al banco 3
	CLRF 0x08
	CLRF 0x09
	BCF STATUS,RP1
	MOVLW 0x03
	MOVWF TRISA			;Configurar RA0 y RA1 como entradas
	BCF STATUS,RP0
	
COMPARA:
	MOVF PORTA,0
	ANDLW 0xFF			;Enmascaramiento
	SUBLW 0x00			
	BTFSS STATUS,C
	GOTO COMPARA_1
	GOTO APAGADO			;Con 00 vamos a apagado

COMPARA_1:
	MOVF PORTA,0
	ANDLW 0xFF			;Enmascaramiento
	SUBLW 0x01			
	BTFSS STATUS,C
	GOTO COMPARA_2
	GOTO DESPLAZAMIENTO_D		;Con 01 vamos a desplazar bits a la derecha

COMPARA_2:
	MOVF PORTA,0
	ANDLW 0xFF			;Enmascaramiento
	SUBLW 0x02
	BTFSS STATUS,C
	GOTO COMPARA_3
	GOTO DESPLAZAMIENTO_I		;Con 10 vamos a desplazar bits a la izquierda

COMPARA_3:
	MOVF PORTA,0
	ANDLW 0xFF			;Enmascaramiento
	SUBLW 0x03
	BTFSS STATUS,C
	GOTO SALIR
	GOTO INVERTIR			;Con 11 vamos a invertir

APAGADO:
	MOVF PORTB,0
	ANDLW 0
	GOTO SALIR

DESPLAZAMIENTO_D:
	MOVLW 0x80			;Para comenzar en 128
	MOVWF PORTB

RECORRE_D:
	BCF STATUS,C	
	RRF PORTB, F			;Realiza el corrimiento a la derecha
	
	MOVF PORTB, 0
	SUBLW 0X01			;Verifica si ya llego al mínimo valor
	BTFSS STATUS,Z
	GOTO RECORRE_D
	GOTO SALIR

DESPLAZAMIENTO_I:
	MOVLW 0x01			;Para comenzar en 1
	MOVWF PORTB

RECORRE_I:
	BCF STATUS,C	
	RLF PORTB, F			;Realiza el corrimiento a la izquierda

	MOVF PORTB, 0
	SUBLW 0X80			;Verifica si ya llego al máximo valor
	BTFSS STATUS,Z

	GOTO RECORRE_I
	GOTO SALIR

INVERTIR:
	COMF PORTB, F	

SALIR:
	END
	

	
	

