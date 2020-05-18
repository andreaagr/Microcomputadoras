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
  <img src="images/SalidaAuto.png" width="620">
</div>

Adicionalmente a las 2 situaciones anteriores el sistema requiere de una inicialización, ya que se necesita obtener el dato de las vacantes totales que es enviado desde la aplicación Android además de realizar otras acciones. El diagrama de flujo correspondiente es el siguiente:

<div align = "center">
  <img src="images/Inicializar.png" width="300">
</div>


### Codificación

#### LCD
Para el uso del LCD se utilizó la librería que provee Arduino, la cual puede importarse de la siguiente manera:

~~~
#include <LiquidCrystal.h>
~~~

Con el fin de escribir mensajes en el LCD, el primer paso es definir una variable de tipo LiquidCrystal e indicarle los pines que se están usando para RS, E, D4, D5, D6 y D7. Lo anterior se le pasará como parámetro en ese orden.

~~~
LiquidCrystal lcd = LiquidCrystal(2, 3, 4, 5, 6, 7);
~~~  

Una vez que se realizó lo anterior en la función setup, se inicializará el LCD y se le deberá indicar la cantidad de renglones y columnas que tiene nuestra LCD. Por ejemplo la siguiente línea indica que se está usando un LCD de 16 columnas y 2 renglones.

~~~
lcd.begin(16, 2);
~~~  

Ya que se han realizado las configuraciones iniciales,es posible trabajar con el LCD a través de funciones como
print, setCursor y clear.

Para el proyecto se generó una función llamada desplegar_vacantes, que escribe en la segunda línea del LCD las vacantes disponibles y se utiliza cada que hay una actualización.

~~~

~~~  


### Análisis de resultados

### Conclusiones

[logo]: (picurl)

<style type="text/css">
    .classname{
        width: 200px;
    }
</style>
