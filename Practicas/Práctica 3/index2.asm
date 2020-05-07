;###################################################################################################
;#                                                                                                 # 
;# Programa que escribe 0x00 de la localidad 0x20 a la localidad 0x30 del banco 2, utilizando      #
;# direccionamiento indirecto                                                                      #
;#                                                                                                 #
;###################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0X00
	ORG 0X05 

	BSF STATUS, IRP 	;Para el direccionamiento indirecto la memoria se divide en 2 bancos 
				;Si se quiere pasar al banco 2 encendemos IRP

	MOVLW 0x20      	;Inicializando en la localidad 0x20
	MOVWF FSR		;Localidad para el direccionamiento indirecto
NEXT:	
	CLRF INDF		;Limpiando el registro INDF
	INCF FSR,F      	;Aumentando el valor de FSR
	MOVLW 0x30
	XORWF FSR,W
	BTFSS STATUS,Z 		;¿Es la localidad 30?
	GOTO NEXT
	;CLRF INDF		;Si se quiere borrar la 30 también
	END