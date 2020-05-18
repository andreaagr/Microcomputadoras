#include <LiquidCrystal.h>
#include <Servo.h>

LiquidCrystal lcd = LiquidCrystal(2, 3, 4, 5, 6, 7);        //Creando objeto LCD: (RS, E, D4, D5, D6, D7)
Servo servomotor1,servomotor2;
int ldrPin = 0;                                             //LDR en el pin analogico 0
int ldrValor = 0;                                           //Variable que guarda el valor leído del LDR
int vacantes_tot = 5, vacantes_disp= 5, pluma;
String v1 = "Totales:";

void setup() {

      Serial.begin(9600);                                   //Iniciamos el monitor serie para mostrar el resultado

      servomotor1.attach(9);                                //Iniciamos los servos para que empiecen a trabajar con el pin 9 y 10
      servomotor2.attach(10);

      lcd.begin(16, 2);                                     //Inicialización del LCD
      iniciar();                                            //El primer dato a recibir del puerto serán las vacantes totales del estacionamiento

}

void loop() {

      permitir_salida();
      if(leer_sensor() > 1000 and vacantes_disp > 0){
              permitir_entrada();
      }

}

void iniciar(){

      while(Serial.available() < 1){}                       //Si no hay un dato que leer del puerto serial, espera

      vacantes_tot = Serial.parseInt();                     //Despliega las vacantes totales y disponibles en el LCD
      vacantes_disp = vacantes_tot;
      v1.concat(vacantes_tot);
      lcd.setCursor(0, 0);
      lcd.print(v1);
      desplegar_vacantes();
      servomotor1.write(0);                                 //Inicializa los servomotores en 0°
      servomotor2.write(0);

}

void permitir_entrada(){

      servomotor1.write(90);
      while(leer_sensor() > 583){}                          //Espera hasta que ya no se detecte obstaculos
      delay(3000);                                          //Espera 3 segundos antes de bajar la pluma
      servomotor1.write(0);                                 //Baja la pluma
      vacantes_disp --;                                     //Disminuye las vacantes
      desplegar_vacantes();
      Serial.print("e");                                    //Envia dato a la aplicación

}

int leer_sensor(){

      return analogRead(ldrPin);

}

void permitir_salida(){

      if(Serial.available() > 0){                           //Si hay datos que leer del puerto serial...
            pluma = Serial.parseInt();
            if(pluma == 0){                                 //Bajar pluma
                  servomotor2.write(0);
            }else if(pluma == 1){                           //Subir pluma
                  servomotor2.write(90);
                  vacantes_disp ++;
                  desplegar_vacantes();
            }

      }

}

void desplegar_vacantes(){

      String v2 = "Disponibles:";
      v2.concat(vacantes_disp);
      lcd.setCursor(0,1);
      lcd.print(v2);

}
