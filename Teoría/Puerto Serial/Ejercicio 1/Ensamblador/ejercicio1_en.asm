;##############################################################################################################
;#                                                                                                            #
;#  Programa que implementa un "eco" desde una terminal serial, es decir, lo que se envíe desde la PC será    #
;#	retornado por el microcontrolador                                                                         #
;#                                                                                                            #
;##############################################################################################################

			INCLUDE <P16F877A.INC>

			CBLOCK  0x20
			char0
			ENDC

			ORG 0x00
			GOTO start
start
			;---------------------------------------------------------Configuración para la recepción y transmisión
      BSF STATUS, RP0 			;Nos movemos al banco 1
      MOVLW .129						;Velocidad de 9600 baudios para un oscilador de 20M
      MOVWF SPBRG						;Configura la velocidad de transmisión
      MOVLW 0x24						;0010 0100 Permite la transmisión en velocidad alta, 8 bits y modo asíncrono
      MOVWF TXSTA						;Configura lo anterior en el registro TXSTA
      CLRF TRISB						;Indica que el puerto B será una salida
      BCF STATUS, RP0				;Regresa al banco 0
      MOVLW 0x90						;1001 0000 Activa la transmisión por puerto serial
      MOVWF RCSTA						;Configura lo anterior en el registro RCSTA
	    CLRF PORTB						;Limpia el puerto B
			;------------------------------------------------------------------------------------------------------
main
      BTFSS PIR1, RCIF			;Espera a que se envie algo por el puerto serial
      GOTO main
      MOVF RCREG, W					;Mueve lo que se ha recibido a W
      MOVWF PORTB						;Mueve el dato al puerto B
      MOVWF char0       		;Mueve el dato a la variable char0 para que pueda ser transmitido
      GOTO transmitir				;Lo transmite

transmitir
      MOVF char0, W
      MOVWF TXREG   				;Coloca el caracter en el registro TXREG para que sea transmitido
      GOTO wthere
wthere
	    BTFSS TXSTA, TRMT 		;Revisa si TRMT esta vacío
      GOTO wthere   				;Si no, revisa de nuevo
      GOTO main
END
