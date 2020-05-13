;####################################################################################################
;#                                                                                                  #
;#  Programa que lee una señal analógica en el canal cero del convertidor analógico digital(AN0).   #
;#  Cuando el voltaje de entrada supera los 3.5[V] se enciende un el pin RB0 y se envía por la      #
;#  terminal serial el mensaje "arriba", cuando el voltaje es menor o igual a 3.5[V] se apaga el    #
;#  pin RB0 y se envía el mensaje "abajo".                                                          #
;#                                                                                                  #
;####################################################################################################

      processor PIC16F886
      #INCLUDE <P16F886.INC>
      ORG 0
      ORG 5

      VALOR EQU 0x20
      apuntador EQU 0x21
      tam EQU 0x23

      DCounter1 EQU 0x24
      DCounter2 EQU 0x25
      DCounter3 EQU 0x26
      DCounter4 EQU 0x27


	    CBLOCK 0x28
	       d1
	       d2
	       d3
         d4
	    ENDC

      CALL CONFIG_USART
      ;--------------------------------------------------------------------Configuración del puerto B
      BSF STATUS,RP0 			;Pasamos al banco 1 donde se encuentran los TRIS
      CLRF TRISB          ;El pin RB0 será salida
      BSF TRISA,0 				;Configura como entrada el pin RA0
      ;----------------------------------------------------------------------------------------------
      ;-------------------------------------------------------------------------Configuración del CAD
      CLRF ADCON1         ;Los voltajes de referencia serán internos y la justificación izquierda
      BSF STATUS,RP1 			;Banco 3
      BSF ANSEL,ANS0			;Configura el pin RA0 como entrada analógica
      ;CLRF ANSELH

      BCF STATUS,RP0			;
      BCF STATUS,RP1      ;Banco 0
      MOVLW 0x41				 	;0100 0001 -> Selecciona el canal AN0, reloj de conversión Fosc/8
      MOVWF ADCON0 				;y enciende el convertidor
      ;----------------------------------------------------------------------------------------------
      ;-----------------------------------------------------------------------------Sección principal
MAIN:
      CLRF apuntador
      CALL DELAY_20_us          ;Espera tiempo de adquisición
      BSF ADCON0,GO_NOT_DONE	  ;Con GO/DONE = 1 se toma la muestra e inicia la conversión
ESP:
      BTFSC ADCON0,GO_NOT_DONE  ;Espera a que termine la conversión (GO/DONE = 0);
      GOTO ESP
   	  ;------------------------------------------Comparaciones para saber si el valor es > 3.5 V o <=
      MOVF ADRESH,W             ;Mueve W <- ADRESH
      MOVWF VALOR
      MOVLW 0xB3                ;716 para 3.5 V
      SUBWF VALOR,W
      BTFSS STATUS,C            ;¿A >= B? ¿C = 1?
      GOTO MENOR_IGUAL

MAYOR_IGUAL:
      BTFSC STATUS,Z            ;Ahora prueba ¿A > B? ¿Z = 0?
      GOTO MENOR_IGUAL
      GOTO MAYOR
	  ;---------------------------------------------------------------------------------------------
	  ;-----------------------------------------------------------------Si es menor o igual a 3.5...
MENOR_IGUAL:
      BCF PORTB,0               ;Apagar el bit B0

      MOVLW 6                   ;Enviar la palabra "abajo"
      MOVWF tam

PRUEBA_MI:
      DECFSZ tam,f
      GOTO INCREMENTA
      MOVLW 0x0D
      CALL TRANSMITE
      MOVLW 0x0A
      CALL TRANSMITE
      CALL DELAY_500_ms
      GOTO MAIN

INCREMENTA:
      CALL PALABRA_MENOR
      CALL TRANSMITE
      INCF apuntador,F
      GOTO PRUEBA_MI
	  ;---------------------------------------------------------------------------------------------
	  ;-------------------------------------------------------------------------Si es mayor a 3.5...
MAYOR:
      BSF PORTB,0               ;Encender el bit B0

      MOVLW 7                   ;Enviar la palabra "arriba"
      MOVWF tam

PRUEBA_M:
      DECFSZ tam,f
      GOTO INCREMENTA_M
      MOVLW 0x0D
      CALL TRANSMITE
      MOVLW 0x0A
      CALL TRANSMITE
      CALL DELAY_500_ms
      GOTO MAIN

INCREMENTA_M:
      CALL PALABRA_MAYOR
      CALL TRANSMITE
      INCF apuntador,F
      GOTO PRUEBA_M
	  ;----------------------------------------------------------------------------------------------
      ;---------------------------Subrutina que inicializa el puerto serial y habilita la transmisión
CONFIG_USART
      ;-Para 9600 Bauds con Fosc = 4 Mhz -> BRGH = 1, BRG16 = 0, SYNC = 0, SPRGH = 0x00 , SPRG = 0x19
      BSF STATUS,RP0 			;Pasamos al banco 1
      BSF TXSTA,BRGH 			;Pone el bit BRGH = 1
      MOVLW 0x19			    ;Carga un 0x19 = 0001 1001 en SPRG
      MOVWF SPBRG 			  ;
      CLRF SPBRGH		    	;Limpia SPRGH, que es equivalente a SPRGH <- 0x00
      BCF TXSTA,SYNC 			;Limpia el bit SYNC (Indica modo asíncrono)
      BSF STATUS,RP1			;Pasamos al banco 3
      BCF BAUDCTL,BRG16		;El bit BRG16 se pone a 0
      ;----------------------------------------------------------------------------------------------
      ;-----------------------------------------------------Habilita el puerto serie y la transmisión
      BCF STATUS,RP1			;Volvemos al banco 1
      BSF TXSTA,TXEN 			;Pone bit TXEN = 1 (Habilita transmisión)}
      BCF STATUS,RP0 			;Regresa al banco 0
      BSF RCSTA,SPEN 			;Pone bit SPEN=1 (Habilita puerto serie)
      ;----------------------------------------------------------------------------------------------
      RETURN
      ;--------Subrutina para transmitir un caracter (El caracter a transmitir debe encontrarse en W)
TRANSMITE:
      BSF STATUS,RP0 	     ;Se mueve al banco 1
ESPERA:
      BTFSS TXSTA,TRMT 	   ;Checa el buffer de transmisión
      GOTO ESPERA 			   ;Si esta ocupado, espera
      BCF STATUS,RP0 			 ;Regresa al banco 0
      MOVWF TXREG 			   ;Lo envía
      RETURN				       ;Regresa a recepción
      ;----------------------------------------------------------------------------------------------
      ;---------------------------------------------------------------Subrutina que envía una palabra
PALABRA_MAYOR:
      MOVF apuntador,W		 ;Carga apuntador en W
      ADDWF PCL,1 			   ;Salta W instrucciones adelante
      DT "arriba"
      RETURN

PALABRA_MENOR:
      MOVF apuntador,W		 ;Carga apuntador en W
      ADDWF PCL,1 			   ;Salta W instrucciones adelante
      DT "abajo"
      RETURN
      ;----------------------------------------------------------------------------------------------
      ;------------------------Subrutina que genera un retardo de 20 us para el tiempo de adquisición
DELAY_20_us
      MOVLW 0X05
      MOVWF DCounter4
LOOP_0
      DECFSZ DCounter4, 1
      GOTO LOOP_0
      RETURN
      ;----------------------------------------------------------------------------------------------
      ;------------Subrutina que genera un retardo de 500 ms para el tiempo entre la toma de muestras
DELAY_500_ms
      MOVLW 0X54
      MOVWF DCounter1
      MOVLW 0X8a
      MOVWF DCounter2
      MOVLW 0X03
      MOVWF DCounter3
LOOP
      DECFSZ DCounter1, 1
      GOTO LOOP
      DECFSZ DCounter2, 1
      GOTO LOOP
      DECFSZ DCounter3, 1
      GOTO LOOP
      NOP
      RETURN
      ;----------------------------------------------------------------------------------------------
	  END
