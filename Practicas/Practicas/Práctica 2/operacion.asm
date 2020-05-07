;#####################################################################################################
;#                                                                                                   # 
;#  Programa que realiza la operación:(0x02*[0x20]+[0x21]-0x24) & 0x0F                               #
;#                                                                                                   #
;#  Si el resultado es cero escribe 0xFF en la localidad 0x24, si es diferente de cero escribe 0x00  # 
;#  en la localidad 0x24.                                                                            #
;#                                                                                                   #
;#  Los valores entre [ ] representan el contenido de una localidad de memoria dato.Los valores que  #
;#  no se encuentren entre [ ] representan literales                                                 #
;#                                                                                                   #
;#####################################################################################################  


  #INCLUDE <P16F886.INC>
	ORG 0X00
	ORG 0X05
	BCF STATUS, C 	  	; Garantiza que carry vale cero
	RLF 0x20	  	; Multiplica por 2 lo que hay en la localidad 0x20
	MOVF 0x20, 0
	ADDWF 0x21, 0 		; Suma lo que hay en la localidad W + [0x21]
	MOVWF 0x20    		; Guarda temporalmente el resultado
	MOVLW 0x24		; Coloca 0x24 = 36 en W
	SUBWF 0x20, 0 		; Resta lo que hay en f - W
	ANDLW 0x0F		; Realiza la operación AND entre W y 0x0F
	SUBLW 0			; Revisa si el resultado fue 0
	BTFSS STATUS, 2
	GOTO NO_CERO
	MOVLW 0xFF
	GOTO GUARDA
NO_CERO:
	MOVLW 0x00
GUARDA:	
	MOVWF 0x24
	END
	
		
