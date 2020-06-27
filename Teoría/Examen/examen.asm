#INCLUDE <P16F877A.INC>

VALOR1 EQU H'21'
VALOR2 EQU H'22'
VALOR3 EQU H'23'

CTE2 EQU .40
CTE3 EQU .41

        ORG 0
        GOTO INICIO
        ORG 5

INICIO:
        ;-----------------------------------------------Configuración de puertos
        CLRF PORTC
        CLRF PORTD
        BSF STATUS, RP0               ;Cambio al banco 1
        CLRF TRISD                    ;Puerto D -> Salida
        MOVLW 0xFF
        MOVWF TRISC                   ;Puerto C -> Entrada

        ;---------------- Para realizar pruebas -------------------
		; Configura PORTA y PORTB como salidas y les asigna un valor

      	MOVLW 0X06		      		  ;W<-6
      	MOVWF ADCON1	      		  ;ADCON1<-6, DESHABILITO EL CAD, TODOS LOS PINES DE PUERTO A SERAN I/O DIGITALES
      	;MOVLW 3FH		      		  ;LOS PINES DE PUERTO A SERAN ENTRADAS
      	;MOVWF TRISA
        CLRF TRISA
		CLRF TRISB
		BCF STATUS, RP0
		MOVLW 8			      		  ;ASIGNA EL VALOR DE 8 AL PUERTO B 	      
		MOVWF PORTB
        MOVLW 5
		MOVWF PORTA		      		  ;ASIGNA EL VALOR DE 5 AL PUERTO A
		;-----------------------------------------------------------

		BCF STATUS, RP0
		;-----------------------------------------------------------------------
LOOP:
        ;---------------------------------------Verifica que PORTC sea menor a 4
        MOVF PORTC, W
        SUBLW 0x04                    ; W <- 4 - PORTC
        BTFSS STATUS, C               ; ¿C = 0?
        GOTO LOOP                     ; NO
        BTFSC STATUS, Z               ; ¿Z = 0?
        GOTO LOOP                     ; NO
        ;-----------------------------------------------------------------------

		;---------------Simula un switch case mediante direccionamiento indexado

        MOVF PORTC, W
        ANDLW 0x03
        ADDWF PCL, F
        GOTO SUMA                     ; Suma los puertos A y B
        GOTO RESTA                    ; Resta los puertos A y B
        GOTO COMPARA
        GOTO LED

		;------------------------------------------------------------------------
SUMA:
        MOVF PORTA, W
        ADDWF PORTB, W
        MOVWF PORTD
        GOTO LOOP
RESTA:
        MOVF PORTB, W
        SUBWF PORTA, W
        MOVWF PORTD
        GOTO LOOP
COMPARA:
        ;---------------------------------------------------------PORTA >= PORTB
        MOVF PORTA, W
        SUBWF PORTB, W                ; W <- PORTA - PORTB
        BTFSS STATUS, C               ; ¿ C = 1 ?
        GOTO APAGADOS
		;-----------------------------------------------------------------------
ENCENDIDOS:
        MOVLW 0xFF
        MOVWF PORTD
        GOTO LOOP
APAGADOS:
        CLRF PORTD
        GOTO LOOP
LED:
		CLRF PORTD
		BSF PORTD, 0
		MOVF PORTA,W
		MOVWF 0X20
		CALL RETARDO
		BCF PORTD, 0
		MOVF PORTB,W
		MOVWF 0X20
		;----------------------------------------------�Ha cambiado la entrada?
		CALL RETARDO
		MOVLW 0x03
		SUBWF PORTC
		BTFSC STATUS,Z
		GOTO LED
		GOTO LOOP


        ;------------------------------------------------------------------------------------;
        ;  Retardo de 1 ms ---> Se modificaron las constantes CTE2 y CTE3 del retardo en     ;
        ;  el código blinkLed.asm para que de 10 ms * CTE1 pasará a 1 ms * CTE1, la CTE1   ;
        ;  estará definida por lo que se encuentre en la localidad 0x20 donde se guardará  ;
        ;  el valor de PORTA (valor en ms que el led estará activo) o el valor de PORTB     ;
        ;  (valor en ms que el led estará apagado) según la parte del código en la que se ;
        ;  mande a llamar (:                                                                 ;
        ;------------------------------------------------------------------------------------;


RETARDO: 							    ; 2		CICLOS DE M�QUINA APORTADOS
		    ;MOVLW CTE1				; 1   CTE1
			MOVF 0x20, W      ; SE CAMBIA ESTA CONSTANTE POR LO QUE ESTA EN EL PORTA O PORTB SEGÚN SEA EL CASO
		    MOVWF VALOR1			; 1

TRES: 								;	 ------

		    MOVLW CTE2				; 1
		    MOVWF VALOR2			; 1

DOS:
		    MOVLW CTE3				; 1
		    MOVWF VALOR3			; 1

UNO:
		    DECFSZ VALOR3			;
		    GOTO UNO					; 3*CTE3 - 1 = I

		    DECFSZ VALOR2			;
		    GOTO DOS       		; ((3*CTE3 - 1) + 5) * CTE2 - 1  -->  3*CTE2*CTE3 + 4*CTE2 - 1 = M

		    DECFSZ VALOR1			;
		    GOTO  TRES				; ((3*CTE2*CTE3 + 4*CTE2 - 1) + 5) * CTE1 - 1  -->   3*CTE1*CTE2*CTE3 + 4*CTE1*CTE2 + 4*CTE1 -1 = J
											    ; ((3*cte2*cte3 + 4*cte2 - 1) + 5) * cte1 - 1  -->   3*cte1*cte2*cte3 + 4*cte1*cte2 + 4*cte1 -1 = J
		    RETURN						;	+ 2						ciclos de m�quina que aporta la subrutina (c.m.s.)

        		;	c.m.s. = 3*cte1*cte2*cte3 + 4*cte1*cte2 + 4*cte1 + 5
        		;
        		;	La cte1 tiene mayor efecto en el tiempo del retardo.
        		;
        		;	Para un microcontrolador PIC con un cristal de f = 20 MHz, el ciclo de reloj es c.r. = 1 / f, es
        		; 	decir c.r. = 50 ns, el ciclo de m�quina es c.m. = 4 * c.r. = 200 ns, por los tanto el tiempo que
        		; 	le toma procesar cada instrucci�n es t = 200 ns (400 ns para instrucciones de salto, cuando saltan)

        		;	Por lo tanto el tiempo de retardo de la subrutina es:

        		;				tsr. = ( 3*cte1*cte2*cte3 + 4*cte1*cte2 + 4*cte1 + 5 ) * t

        		;	Para ajustar el tiempo mediante la cte1, se se fijan los valores cte2 y cte3 a fin de que se genere
        		;	un retardo de 1 ms aproximadamente por cada unidad de cte1:

        		;				cte1 = determina el tiempo de retados x 10 ms (decimal)
        		;				cte2 = 40	(decimal)
        		;				cte3 = 41	(decimal)
        	END
