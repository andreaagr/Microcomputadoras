/*

Control de un motor de corriente directa a partir del PWM, que se incrementa o disminuye según lo que lea el sensor de
temperatura: 20° -> 0 % PWM, 30° -> 100 % PWM. La relación para los demás valores es lineal

*/

#include <16F877A.h>
#device adc = 10
#fuses XT,NOWDT
#use delay(clock= 20M) //Reloj de 20MHz
#include <lcd.c>
#define ctePWM 260                                        //Valor máximo del PWM

void main(){
   int16 voltoTemp,duty_cycle;
   float temp,porcentaje;
   setup_adc_ports(RA0_ANALOG);                           //Se indica que RA0 se utilizará como CAD
   setup_adc(ADC_CLOCK_INTERNAL);                         //Indica que se utilizará el reloj interno
   lcd_init();                                            //Inicializa la pantalla LCD
   set_adc_channel(0);                                    //Indica que el pin RA0 será entrada
   setup_ccp1(CCP_PWM);                                   //Indica que se trabajará en modo PWM
   setup_timer_2(T2_DIV_BY_16, 64 , 1);                   //Fija la frecuencia de pwm

   while(1){
      voltoTemp= read_adc();                              //Lee el voltaje
      temp=(voltoTemp*500.0)/1024.0;                      //Se debe hacer la conversión
      if(temp >= 20 && temp <= 30){                       //Sí la temperatura se encuentra en el rango especificado
            porcentaje = (temp-20)*10;                    //Calcula el porcentaje al que debe estar el ciclo de trabajo
            duty_cycle = (porcentaje/100) * ctePWM;
            lcd_gotoxy(1,1);
            printf(lcd_putc,"|TEMP= %.1f[C] |",temp);     //Se envia el texto a mostrar en la LCD.
            lcd_gotoxy(1,2);
            printf(lcd_putc,"|PWM = %.1f    |", porcentaje);
            set_pwm1_duty(duty_cycle);                    //Fija el valor del ciclo de trabajo al que calculamos
      }else{                                              //Si la temperatura no esta entre 20 y 30
            lcd_gotoxy(1,1);
            printf(lcd_putc,"|TEMP= %.1f[C] |",temp);     //Únicamente se envia el texto que mide la temperatura
            lcd_gotoxy(1,2);
            printf(lcd_putc,"|              |");
      }
   }
}
