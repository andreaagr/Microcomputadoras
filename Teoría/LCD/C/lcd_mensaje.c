#include <16F877A.h>
#fuses XT,NOWDT
#use delay(clock= 20000000) //Reloj de 20MHz
#include <lcd.c>

 void main() {

   lcd_init();                              //Inicializa el LCD
   lcd_gotoxy(1,1);                         //Se coloca el cursor al inicio de la primera línea
   printf(lcd_putc, "Saludos profesor");    //Muestra el mensaje
   lcd_gotoxy(1,2);                         //Se coloca el cursor al inicio de la segunda línea
   printf(lcd_putc, "desde C :D");          //Muestra el mensaje

}
