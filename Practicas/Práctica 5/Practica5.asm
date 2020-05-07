;	########################################################################################################################
;	#                                                                                                                      #
;	#  Programa que realiza un desplazamiento de un bit sobre el puerto B con un tiempo entre cada desplazamiento de 0.5 s #
;	#  ,dependiendo de la entrada en el PIN RA0 se determina la dirección: 1 -> derecha, 0 -> izquierda                    #
;	#                                                                                                                      #
;	########################################################################################################################
		 __CONFIG    _CONFIG1, (_INTOSCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF)
		#INCLUDE <P16F886.INC>
		
		CBLOCK 0x20
		d1
		d2
		d3
		ENDC
		
		ORG 0
		ORG 5
		
		;-------------------------------------------------------------------------------------Configuración de puertos
		CLRF PORTA
		CLRF PORTB
		BSF STATUS,RP0		;Pasamos al banco 1 donde se encuentran los TRIS
		CLRF TRISB	   	;Todas son salidas en el PORTB
		BSF STATUS,RP1     	;Pasamos al banco 3 para deshabilitar PORTA como CAD
		CLRF ANSEL	   	;
		CLRF ANSELH	   	;
		BCF STATUS,RP1 		;Volvemos a banco 1
		MOVLW 0x01	   	;Configuramos RA0 como entrada
		MOVWF TRISA    		;Configuramos PORTA
		BCF STATUS,RP0 		;Regresamos al banco 0
		;-------------------------------------------------------------------------------------------------------------
LOOP:
	    	MOVF PORTA, W  
		ANDLW 0x01     		;Enmascaramiento
		BCF STATUS,C
		BTFSS PORTA,0 
		GOTO IZQUIERDA
		GOTO DERECHA

IZQUIERDA:
		MOVLW 0x01     
		MOVWF PORTB    		;Carga un uno al PORTB
		CALL DELAY
RECORRE
		BCF STATUS,C
		RLF PORTB,F
		CALL DELAY
		MOVF PORTB, W
		SUBLW 0x80	   	;Verifica si ya llego al máximo valor
		BTFSS STATUS,Z
		GOTO RECORRE
		CALL DELAY
		GOTO LOOP			

DERECHA:
		BCF STATUS,C
		MOVLW 0x80     
		MOVWF PORTB    		;Carga un 10000000b = 128 al PORTB
		CALL DELAY

RECORRE_D
		RRF PORTB
		CALL DELAY
		MOVF PORTB, 0
		SUBLW 0x01	   	;Verifica si ya llego al máximo valor
		BTFSS STATUS,Z
		GOTO RECORRE_D
		CALL DELAY
		GOTO LOOP		

		;----------------------------------------------------------------------------------------------Para el retardo
		; Delay = 0.5 seconds, Clock frequency = 4 MHz
		; Actual delay = 0.5 seconds = 500000 cycles, 
		; 499994 cycles
DELAY
	    	MOVLW 0x03
		MOVWF d1
		MOVLW 0x18
		MOVWF d2
		MOVLW 0x02
		MOVWF d3
DELAY_0
		DECFSZ	d1, f
		GOTO	$+2
		DECFSZ	d2, f
		GOTO	$+2
		DECFSZ	d3, f
		GOTO	DELAY_0
		;6 cycles
		GOTO	$+1
		GOTO	$+1
		GOTO	$+1
		RETURN
		;-------------------------------------------------------------------------------------------------------------
		END 