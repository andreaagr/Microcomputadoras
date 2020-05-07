/*----------------------------------------------------------------------------------------------------------------------------

 Código que recibe datos del puerto serial (puede ser un caracter o cadena) y los muestra tanto en una pantalla LCD como en el
 puerto serial

----------------------------------------------------------------------------------------------------------------------------*/

#include <16F877a.h>
#device adc=10                                                                  //Convertidor analogico
#fuses XT,NOWDT
#use delay (clock=20M)
#include <lcd.c>
#use rs232(baud=9600,parity=N,xmit=PIN_C6,rcv=PIN_C7,bits=8,stream=PORT1)       //Opciones para el puerto serial
int i = 1;
void main(){
      char r;                                                                   //Variable donde se almacena el dato recibido
      lcd_init();                                                               // Inicialzacón del LCD
      lcd_gotoxy(1,1);
      lcd_putc("Dato Recibido: ");
      while(TRUE){
          if(kbhit(PORT1)== TRUE){                                               // Si se recibe un dato...
              r = getc();                                                        // Almacena el dato en la variable r
              if(i < 16){                                                        // Si aún hay espacio en el LCD...
                  lcd_gotoxy(i,2);                                               // Escribe en la posición siguiente
                  printf(lcd_putc,"%c",r);                                       // Coloca el dato en la LCD
                  printf("%c",r);                                                // Coloca el dato en el puerto serial
                  i++;                                                           // Aumenta la posición
              }else{                                                             // Si se alcanzo el máximo de caracteres...
                  lcd_gotoxy(1,2);
                  printf(lcd_putc,"%c              ",r);                         // Colocamos el caracter recibido y limpiamos el LCD
                  i=2;                                                           // Volvemos a iniciar desde la posición 2
              }
          }
      }
}
