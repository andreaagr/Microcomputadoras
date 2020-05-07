#include <16F877A.h>
#device adc = 10
#fuses XT,NOWDT
#use delay(clock= 20M) //Reloj de 20MHz
#include <lcd.c>

void main(){
   int16 voltoTemp;
   float temp;
   setup_adc_ports(RA0_ANALOG);                   //Se indica que RA0 se utilizará como CAD
   setup_adc(ADC_CLOCK_INTERNAL);                 //Indica que se utilizará el reloj interno
   lcd_init();                                    //Inicializa la pantalla LCD
   set_adc_channel(0);                            //Indica que el pin RA0 será entrada

   while(1){
      voltoTemp= read_adc();                      //Lee el voltaje
      temp=(voltoTemp*500.0)/1024.0;              //Se debe hacer la conversión
      lcd_gotoxy(1,1);
      printf(lcd_putc,"|TEMP= %.1f[C] |",temp);   //Se envia el texto a mostrar en la LCD.
      lcd_gotoxy(1,2);
      printf(lcd_putc,"|              |");
   }

}
