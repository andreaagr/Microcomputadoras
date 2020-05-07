/*-------------------------------------------------------------------------------------------------------------------------------------------
    Implementa un sistema que funciona como un interprete de comandos, con dos comandos, uno para apagar leds y otro para encenderlos,
    por ejemplo:

	                             leds on			-->		todos los leds conectados al puerto B encendidos
	                             leds off		  -->		todos los leds conectados al puerto B apagados

    Si el microcontrolador reconoce el comando, realizará la tarea correspondiente (prender/apagar los leds) y responderá hacia la terminal
    serial que realizó la tarea:

	                             todos los leds encendidos ó todos los leds apagados

    Si no reconoce el comando responderá con: "Comando no reconocido"

    Se puede probar el código con cualquier terminal serial configurando el puerto y la velocidad a 9600 bauds

-------------------------------------------------------------------------------------------------------------------------------------------*/

#include <16F877a.h>
#device adc=10
#fuses XT,NOWDT
#use delay (clock=20M)
#include <lcd.c>
#include <string.h>                                                                       // Libreria para trabajar con cadenas
#use rs232(baud=9600,parity=N,xmit=PIN_C6,rcv=PIN_C7,bits=8,stream=PORT1)                 // Configuración del puerto serial
#byte PORTB = 6                                                                           // Se indica la dirección del puerto B
int i = 0,res;
char buffer[8];
char comando1[]= "leds on", comando2[]= "leds off", msj_1[]= "Todos los leds encendidos :D", msj_2[]= "LEDS ON :D";
char msj_3[]= "Todos los leds apagados x.x", msj_4[]= "LEDS OFF x.x",msj_5[]= "Comando no reconocido :(", msj_6[]= "ERROR :(";

//Muestra los mensajes correspondientes tanto en el puerto serial como en el LCD
void mostrar_mensaje(char mensaje_puerto[], char mensaje_LCD[]){
      lcd_gotoxy(1,1);
      printf(lcd_putc, "                ");                                               // Limpia el LCD
      lcd_gotoxy(1,1);
      printf(lcd_putc,mensaje_LCD);                                                       // Coloca el mensaje en el LCD
      printf(mensaje_puerto);                                                             // Coloca el mensaje en el puerto serial
}

void main(){
      char r;                                                                             // Variable donde se almacena el dato recibido
      lcd_init();                                                                         // Inicialzacón de la LCD
      set_tris_b(0);                                                                      // Se indica que el puerto B será salida
      PORTB = 0;                                                                          // Se ponen todos los pines del puerto B en 0
      while(TRUE)
      {
          if(kbhit(PORT1)== TRUE){                                                        // Verifica recepción de dato serial
              r = getc();                                                                 // Almacena el dato del puerto serial en la variable
              buffer[i] = r;                                                              // Se van guardando los caracteres en un buffer
              i++;
              if(i == 7){                                                                 // Cuando la cadena del buffer es igual a 7
                    if(strncmp(buffer,comando1,7) == 0){                                  // Se compara la cadena obtenida con el comando 1
                           mostrar_mensaje(msj_1,msj_2);
                           i=0;                                                           // Reinicia el buffer
                           PORTB = 0B11111111;                                            // Pone todos los pines del puerto B en 1
                    }
              }else if(i == 8){                                                           // Cuando la cadena del buffer es igual a 8
                    if(strncmp(buffer,comando2,7) == 0){                                  // Se compara la cadena obtenida con el comando 2
                           mostrar_mensaje(msj_3,msj_4);
                           PORTB = 0;                                                     // Pone todos los pines del puerto B en 0
                    }else{
                           mostrar_mensaje(msj_5,msj_6);
                    }
                    i = 0;                                                                // Reinicia el buffer
              }
          }
      }
}
