;##########################################################################################################
;#                                                                                                        # 
;#  Programa que verifica si un punto (x,y) pertenece a la recta y = 4x^2 -4. La variable x se encuentra  #
;#  en la localidad 0x20, la variable y en la localidad 0x21. Si el punto pertenece a la recta coloca     #
;#  0xFF en la localidad 0x22, si no pertenece escribe 0x00.                                              #
;#                                                                                                        #
;##########################################################################################################

	#INCLUDE <P16F886.INC>
	ORG 0X00
	ORG 0X05
	MOVF 0X20, 0 		; Carga el valor de f a W
	MOVWF 0X22		; Localidad que guardará la referencia al número del que se sacará cuadrado
PRUEBA:
	DECFSZ 0X20
	GOTO CUADRADO		; Se suma n veces para sacar el cuadrado
	GOTO CONTINUAR	
	     
CUADRADO:
	ADDWF 0X22,0
	GOTO PRUEBA

CONTINUAR:
 	MOVWF 0X20	 	; El resultado del cuadrado se guarda en 0x20
	RLF 0X20	 	; Multiplicación por 4
	RLF 0X20
	MOVLW 5		 	; Para restarle 4
	MOVWF 0X22

PRUEBA2:
	DECFSZ 0X22
	GOTO DECREMENTA	 	;Genera un ciclo para restarle 4
	GOTO CONTINUAR2

DECREMENTA:
	DECF 0X20
	GOTO PRUEBA2

CONTINUAR2:
	MOVF 0X21,0  		; Mueve el valor de y a W
	SUBWF 0X20   		; Resta el punto evaluado que se guardo en 0x20 con y
	BTFSS STATUS,2 		; Checa el bit que pertenece a la bandera Z
	GOTO NO_PERTENECE 	; Si Z es diferente de 0, no pertenece
	GOTO PERTENECE		; Si Z es igual a 0, pertenece

NO_PERTENECE:
	MOVLW 0x00   		; Mueve 0x00 
	GOTO FIN

PERTENECE:	 
	MOVLW 0XFF   		; Mueve 0xFF
	GOTO FIN

FIN:
	MOVWF 0X22   ; El resultado se guarda en la localidad 22
	END