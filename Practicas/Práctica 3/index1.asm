;###################################################################################################
;#                                                                                                 # 
;# Programa que escribe 0x00 de la localidad 0x20 a la localidad 0x30 del banco 1, utilizando      #
;# direccionamiento indirecto                                                                      #
;#                                                                                                 #
;###################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0X00
	ORG 0X05 
	MOVLW 0XA0      	;Inicializando en la localidad 0x20 del banco 1
	MOVWF FSR		;Localidad para el direccionamiento indirecto
NEXT:	
	CLRF INDF		;Limpiando el registro INDF
	INCF FSR,F      	;Aumentando el valor de FSR
	MOVLW 0xB0
	XORWF FSR,W		;Resta 0x30 al apuntador FSR
	BTFSS STATUS,Z 		;¿Es la localidad 30?
	GOTO NEXT		;Si, sigue limpiando
	;CLRF INDF		;Si se quiere borrar la localidad 0x30 también
	END			;Termina