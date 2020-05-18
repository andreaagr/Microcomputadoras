# Estacionamiento con Arduino
Fecha de entrega: 22/05/20  
Elaborado por: García Ruiz Andrea  

### Objetivo
- Aplicar los conocimientos adquiridos en el curso de microcomputadoras para el desarrollo de un sistema basado en microcontrolador que incluya: un sensor de entrada, un sistema controlador con conexión hacia un celular y un actuador.

### Análisis del problema
A continuación se muestran las conexiones del sistema propuesto:

![Conexiones Estacionamiento](images/ConexionesProyecto.PNG)

En nuestro sistema tenemos 2 situaciones principales: la entrada y la salida de un auto.

Cuando un auto desea ingresar al estacionamiento, su presencia es detectada por el sensor. Si se tienen vacantes disponibles se levantará la pluma y se permitirá el acceso. La descripción más detallada de cómo se comporta el sistema para la entrada de automóviles se ilustra en el siguiente diagrama de flujo:  

<div align = "center">
  <img src="images/EntradaAuto.png" width="600">
</div>

Para la salida de automóviles, se recibe un dato proveniente de una aplicación Android que puede ser 1 o 0. Depeniendo del dato adquirido se levantará o bajará la pluma del estacionamiento, este proceso se ilustra a continuación:

<div align = "center">
  <img src="images/SalidaAuto.png" width="650">
</div>

Adicional a las 2 situaciones anteriores, el sistema requiere de una inicialización ya que se necesita obtener el dato de las vacantes totales, que es enviado desde la aplicación Android además de realizar otras acciones. El diagrama de flujo correspondiente es el siguiente:

<div align = "center">
  <img src="images/Inicializar.png" width="370">
</div>


### Codificación

#### LCD
Para el uso del LCD se utilizó la librería que provee Arduino, la cual puede importarse de la siguiente manera:

~~~
#include <LiquidCrystal.h>
~~~

Con el fin de escribir mensajes en el LCD, el primer paso es definir una variable de tipo LiquidCrystal e indicar los pines que se están usando para RS, E, D4, D5, D6 y D7. Lo anterior se le pasará como parámetro en ese orden.

~~~
LiquidCrystal lcd = LiquidCrystal(2, 3, 4, 5, 6, 7);
~~~  

Una vez que se realiza lo anterior, en la función setup se debe inicializar el LCD indicando la cantidad de renglones y columnas que tiene. Por ejemplo la siguiente línea indica que se está usando un LCD de 16 columnas y 2 renglones.

~~~
lcd.begin(16, 2);
~~~  

Ya que se realizaron las configuraciones iniciales,es posible trabajar con el LCD a través de funciones como
print, setCursor y clear.

Para el proyecto se generó una función llamada desplegar_vacantes, que escribe en la segunda línea del LCD las vacantes disponibles y se utiliza cada que hay una actualización.

~~~
void desplegar_vacantes(){
      String v2 = "Disponibles:";
      v2.concat(vacantes_disp);
      lcd.setCursor(0,1);
      lcd.print(v2);
}
~~~  

Las vacantes totales también se escriben en la pantalla LCD, pero esta acción se realiza después de adquirir el dato por bluetooth en la función iniciar.

~~~
void iniciar(){

      //Leer dato del puerto serie y guardarlo en vacantes_tot
      v1.concat(vacantes_tot);    
      lcd.setCursor(0, 0);  
      lcd.print(v1);  
      desplegar_vacantes();  

}
~~~

#### Servomotor
Arduino posee también una librería para trabajar con servomotores, que se importa con la siguiente línea:

~~~
#include <Servo.h>
~~~

El uso es sencillo,únicamente se debe definir la variable de tipo Servo y posteriormente en la función setup inidicar el pin en el que está conectado.

Para el proyecto se utilizaron 2 servomotores que están conectados al pin 9 y 10, la definición se realiza de la siguiente forma:

~~~
Servo servomotor1,servomotor2;
void setup() {

      //Otras configuraciones
      servomotor1.attach(9);                               
      servomotor2.attach(10);                               

}
~~~

Finalmente para mover los servomotores se utiliza la función write, en donde el parámetro que recibe es el ángulo al que se moverá el servo. En el proyecto se utiliza constatemente esta función para el movimiento de la pluma.

Internamente lo que realiza la función write, consiste en generar una señal PWM con un pulso de trabajo entre 1 ms y 2 ms. Dependiendo del valor se determina el giro del servomotor, es importante mencionar que el periodo de la señal es de 20 ms lo que indicará la velocidad del servomotor.   

### Análisis de resultados

### Conclusiones
