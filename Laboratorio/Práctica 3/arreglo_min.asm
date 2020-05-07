;###################################################################################################
;#                                                                                                 # 
;# Programa que encuentra el valor m�nimo de un arreglo.El tama�o se guarda en la localidad 0x20.  #
;# El m�nimo se guarda en la localidad 0x21.                                                       #
;#                                                                                                 #
;###################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0X00
	ORG 0X05

	MOVLW 0x22      	;Localidad de inicio
	MOVWF FSR		;Localidad para el direccionamiento indirecto
	MOVF INDF,W
	MOVWF 0x21      	;El minimo lo guardamos en 0x21
EVALUA:
	DECFSZ 0X20,F		;Evalua si ya se termino de evaluar el arreglo
	GOTO NEXT
	GOTO FIN

NEXT:	
	INCF FSR,F 
	MOVF INDF,W
	SUBWF 0x21,W     	;Se compara el actual m�nimo con la nueva localidad
	BTFSC STATUS,C   	;Si FSR es nuevo m�n -> C y Z = 0
	GOTO NUEVO_MIN
	GOTO EVALUA
	
NUEVO_MIN:
	MOVF INDF,W
	MOVWF 0x21		;Localidad temporal para guardar el m�nimo
	GOTO EVALUA
FIN:
	END
	
	
	 
