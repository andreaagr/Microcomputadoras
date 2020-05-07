;###################################################################################################
;#                                                                                                 # 
;# Programa que encuentra el valor mínimo de un arreglo.El tamaño se guarda en la localidad 0x20.  #
;# El mínimo se guarda en la localidad 0x21.                                                       #
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
	SUBWF 0x21,W     	;Se compara el actual mínimo con la nueva localidad
	BTFSC STATUS,C   	;Si FSR es nuevo mín -> C y Z = 0
	GOTO NUEVO_MIN
	GOTO EVALUA
	
NUEVO_MIN:
	MOVF INDF,W
	MOVWF 0x21		;Localidad temporal para guardar el mínimo
	GOTO EVALUA
FIN:
	END
	
	
	 
