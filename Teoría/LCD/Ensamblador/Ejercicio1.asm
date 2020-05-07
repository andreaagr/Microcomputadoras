;########################################################################################################
;#                                                                                                      #
;#  Programa que despliega 3 mensajes en un LCD con un retardo de 2s entre ellos, las bibliotecas para  #
;#  el uso del LCD se obtuvieron del libro "MICROCONTROLADOR PIC16F84. DESARROLLO DE PROYECTOS"         #
;#                                                                                                      #
;########################################################################################################

	__CONFIG   _CP_OFF &  _WDT_OFF & _PWRTE_ON & _XT_OSC
	LIST	   P=16F877A
	INCLUDE  <P16F877A.INC>

	CBLOCK  0x20
	ENDC

; ZONA DE CÓDIGOS ********************************************************************

	ORG	0

Inicio
	call	LCD_Inicializa

Principal
	movlw	Mensaje0		; Apunta al mensaje 0.
	call	Visualiza
	movlw	Mensaje1		; Apunta al mensaje 1.
	call	Visualiza
	movlw	Mensaje2		; Apunta al mensaje 2.
	call	Visualiza
	call	Retardo_5s		; Permanece apagada durante este tiempo.
	goto	Principal		; Repite la visualización de todos los mensajes.

;
; Subrutina "Visualiza" -----------------------------------------------------------------
;

Visualiza
	call	LCD_Mensaje
	call	Retardo_2s		; Visualiza el mensaje durante este tiempo.
	call	LCD_Borra		; Borra la pantalla y se mantiene así durante
	call	Retardo_200ms	; este tiempo.
	return
;
; "Mensajes" ----------------------------------------------------------------------------
;

Mensajes
	addwf	PCL,F
Mensaje0					; Posici�n inicial del mensaje 0.
	DT "Hola :D", 0x00
Mensaje1					; Posici�n inicial del mensaje 1.
	DT "y", 0x00
Mensaje2					; Posici�n inicial del mensaje 2.
	DT "Adios :(", 0x00

	INCLUDE  <LCD_4BIT.INC>
	INCLUDE  <LCD_MENS.INC>
	INCLUDE  <RETARDOS.INC>
	END
