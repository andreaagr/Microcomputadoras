;	#########################################################################################################################################
;	#                                                                                                                                       #
;	#  Programa recibe una cadena a partir del puerto serial y la compara con la cadena "PUMAS", cuando la cadena coincide se enciende un   #
;	#  led conectado al pin RB0 y se envï¿½a la palabra "OK" por el puerto serial. De lo contrario se apaga el led y se envía la cadena     #
;	#  "ERROR"                                                                                                                              #
;	#                                                                                                                                       #
;	#########################################################################################################################################

		 __CONFIG    _CONFIG1, (_INTOSCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF)
		processor PIC16F886
		#INCLUDE <P16F886.INC>

		TAM EQU 0x20
		DATO EQU 0x21
		apuntador EQU 0x40
		CBLOCK 0x40
		ENDC

		ORG 0
		GOTO 5
		ORG 5

		;------------------------------------------------------------------------------------------------------Configuración del puerto B
		BSF STATUS,RP0 			;Pasamos al banco 1 donde se encuentran los TRIS
		CLRF TRISB              	;El pin RB0 será salida
		;-------------------------------------------------------------------------------------------------Configuración del puerto serial
		;-----------------------------------Para 9600 Bauds con Fosc = 4 Mhz -> BRGH = 1, BRG16 = 0, SYNC = 0, SPRGH = 0x00 , SPRG = 0x19
		BSF TXSTA,BRGH 			;Pone el bit BRGH = 1
		MOVLW 0x19			;Carga un 0x19 en SPRG
		MOVWF SPBRG 			;
		CLRF SPBRGH		    	;Limpia SPRGH, que es equivalente a SPRGH <- 0x00
		BCF TXSTA,SYNC 			;Limpia el bit SYNC (Indica modo asíncrono)
		BSF STATUS,RP1			;Pasamos al banco 3
		BCF BAUDCTL,BRG16		;El bit BRG16 se pone a 0
		;--------------------------------------------------------------------------------------------------------------------------------
		;-------------------------------------------------------------------------Habilita el puerto serie, la recepción y la transmisión
		BCF STATUS,RP1			;Volvemos al banco 1
		BSF TXSTA,TXEN 			;Pone bit TXEN = 1 (Habilita transmisión)}
		BCF STATUS,RP0 			;Regresa al banco 0
		BSF RCSTA,SPEN 			;Pone bit SPEN=1 (Habilita puerto serie)
		BSF RCSTA,CREN 			;Habilita recepción
		;--------------------------------------------------------------------------------------------------------------------------------
		;--------------------------------------------------------------------Indica que se recibirán caracteres hasta encontrar <ESPACIO>
MAIN:
		CLRF 0x22
		MOVLW 0x22			;Inicializa FSR en la localidad 0x22
		MOVWF FSR

RECEPCION:
		CALL RECIBE			;Recibe dato
		MOVLW .32			;Carga código ASCII de <ESPACIO>
		SUBWF INDF,W			;¿Es igual?
		BTFSC STATUS,Z			;
		GOTO COMPARA 			;Si es igual salta a COMPARA
		GOTO CONTINUA			;En caso contrario...

		;--------------------------------------------------------------------------------------------------------------------------------
		;----------------------------------------------------------------------------------------------Subrutina para recibir un caracter
RECIBE:
		BTFSS PIR1,RCIF 		;Checa el buffer de recepción
		GOTO RECIBE 			;Si no hay dato listo espera
		MOVF RCREG,W 			;Si hay dato, lo lee
		MOVWF INDF 		        ;y lo almacena en la localidad actual que apunte FSR
		MOVWF DATO
		RETURN
		;--------------------------------------------------------------------------------------------------------------------------------
		;-------------------------------------------Subrutina para transmitir un caracter (El caracter a transmitir debe encontrarse en W)

TRANSMITE:
		BSF STATUS,RP0 	        	;Se mueve al banco 1
ESPERA:
		BTFSS TXSTA,TRMT 	    	;Checa el buffer de transmisión
		GOTO ESPERA 			;Si esta ocupado, espera
		BCF STATUS,RP0 			;Regresa al banco 0
		MOVWF TXREG 			;Lo envía
		RETURN				;Regresa a recepción
		;--------------------------------------------------------------------------------------------------------------------------------
		;----------------------------------------------------Aumenta el tamaño del arreglo y coloca el apuntador en la siguiente posición
CONTINUA:
		MOVF DATO,W
		;CALL TRANSMITE
		INCF TAM,F			;Aumenta el tamaño del arreglo
		INCF FSR,F			;Apunta a la siguiente localidad
		GOTO RECEPCION			;Sigue recibiendo caracteres
		;--------------------------------------------------------------------------------------------------------------------------------
		;----------------------------------------------------------Evalua si la cadena recibida es igual a la cadena contenida en PALABRA
COMPARA:
		MOVLW 0x22
		MOVWF FSR 			;Se inicia el apuntador para recorrer la cadena recibida
		INCF TAM,F			;Aumenta la posición en uno, por el decremento
		
EVALUA:
		DECFSZ TAM,F			;Mientras que no se llegue a 0,se va decrementando la variable tamaño
		GOTO SIGUIENTE			;Si aún no se llega a cero, sigue evaluando
		GOTO IGUAL			;Si ya llegamos a cero, podemos decir que las cadenas son iguales

SIGUIENTE:
		
		CALL PALABRA			;Obtiene el siguiente caracter de la cadena "PUMAS" y lo guarda en W
		SUBWF INDF,W			;Lo compara con el caracter a donde apunta FSR
		BTFSS STATUS,Z 			;¿Son iguales?
		GOTO DIFERENTE			;Si no son iguales, ve a DIFERENTE
		GOTO AUMENTA			;Si son iguales sigue comparando

AUMENTA
		INCF apuntador,F
		INCF FSR,F
		GOTO EVALUA

PALABRA:
		MOVF apuntador,W		;Carga apuntador en W
		ADDWF PCL,1 			;Salta W instrucciones adelante
		DT "PUMAS"
		RETURN

DIFERENTE:
		CLRF PORTB
		MOVLW 'E'
		CALL TRANSMITE
		MOVLW 'R'
		CALL TRANSMITE
		MOVLW 'R'
		CALL TRANSMITE
		MOVLW 'O'
		CALL TRANSMITE
		MOVLW 'R'
		CALL TRANSMITE
		GOTO FIN
IGUAL:
		MOVLW 0x01
		MOVWF PORTB
		MOVLW 'O'
		CALL TRANSMITE
		MOVLW 'K'
		CALL TRANSMITE
		GOTO FIN
		;--------------------------------------------------------------------------------------------------------------------------------
FIN:
		END
