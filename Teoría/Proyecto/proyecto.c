#include <16F877A.h>
#device adc = 10
#fuses XT,NOWDT
#use delay(clock= 500000)
#include<lcd.c>
int luz_adc;
void mover_pluma(int angulo){

    if(angulo >= 0 && angulo <= 180){
        float ms = (1/180)*angulo + 1;
        int valor = (ms*625)/20;
        set_pwm1_duty(valor);
    }

}
// Devuelve 1 si hay un obstaculo y 0 cuando no
int detectar_obstaculo(){
    luz_adc = read_adc();
    return luz_adc > 716 ? 1 : 0;
  
}

void main(){

  /*-----------------------------Configuraciones iniciales-----------------------------*/

    setup_adc_ports(RA0_ANALOG);             //Se indica que RA0 se utilizará como CAD
    setup_adc(ADC_CLOCK_INTERNAL);           //Indica que se utilizará el reloj interno
    set_adc_channel(0);                      //Indica que el pin RA0 será entrada

    setup_ccp1(CCP_PWM);                     //Indica que se trabajará en modo PWM
    setup_timer_2(T2_DIV_BY_16, 155 , 1);    //Fija la frecuencia de PWM a 50 Hz

    lcd_init();                              //Inicializa la pantalla LCD

 /*------------------------------------------------------------------------------------*/
    luz_adc = read_adc();
    printf(lcd_putc,"%i",luz_adc);
}
