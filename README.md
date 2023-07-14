# vicon

Proyecto Vicon: sistema de visión configurable

Hardware de captura: Basys 3 / FT232H / MT9V111
Software basado en Qt y OpenCV

################################################################################

Contenidos:

Vivado - Modelado de la FPGA
Qt - Aplicación C++ Windows 10

################################################################################

Manual de usuario:

- Puesta en marcha

Conectar el hardware de captura y cargar el bitstream que se encuentra en la carpeta Vivado sobre la FPGA. Para poner en marcha la aplicación en el PC (tfm.exe), pulsar el botón Conectar, seleccionando previamente un dispositivo del desplegable (se muestran los dispositivos FT232 encontrados en el sistema). En ese instante, se empezará a mostrar el vídeo capturado. A la derecha del desplegable anterior, se puede observar de forma instantánea la velocidad de refresco del vídeo en frames por segundo (fps).
Si ocurriera cualquier error de conexión, este será informado a través de la barra de estado de la ventana (parte inferior). Si todo es correcto, aparecerá la palabra "Conectado". En otro caso, una descripción del error que permitirá al usuario realizar las acciones oportunas para que pueda funcionar adecuadamente.

- Cambio de modo

Por defecto, la imagen se muestra en escala de grises para proporcionar un mayor número de fps y, por tanto, una visión más fluida del vídeo. Para cambiar a modo color, bastará con marcar la casilla "color". Inmediatamente, la imagen capturada pasará a tener un formato en color. Se puede alternar en cualquier momoento entre los modos de escala de grises y color con solo marcar o desmarcar la casilla mencionada.

- Detección y reconocimiento facial

Para usar estas características, es suficiente con marcar las casillas correspondientes. Al marcar "Activar detección de rostros", se mostrará un rectángulo superpuesto a la imagen capturada, en tiempo real, sobre cada rostro detectado. Para que funcione correctamente, ha de haber iluminación adecuada (es suficiente con iluminación de día o en interiores con iluminación artificial). Para realizar el reconocimiento, es necesario que se haya activado previamente la función de detección. De esta forma, el sistema tratará de reconocer los rostros detectados. Cuando esto ocurra, mostrará el nombre asociado al rostro sobre el rectángulo que lo enmarque.
Se debe tener en cuenta que una iluminación trasera excesiva puede dificultar las tareas de detección y reconocimiento.

- Entrenamiento del sistema de reconocimiento facial

Para que el sistema sea capaz de reconocer rostros, es necesario entrenarlo con imágenes del rostro capturado y asociarlas a un nombre. Este proceso se puede realizar tanto de forma manual, creando una subcarpeta con el nombre de la persona dentro de la carpeta "images", e introduciendo en ella tantas imágenes que contengan el rostro de esa persona como se desee, nombradas con números sucesivos, en formato jpg (por ejemplo: 1.jpg, 2.jpg, 3.jpg). Un alto número de imágenes dotará el sistema de un mayor conocimiento y, por tanto, de mayor tasa de reconocimiento. Por otro lado, este proceso de puede realizar de forma automática desde la aplicación con solo escribir el nombre de la persona y pulsar sobre el botón "Añadir persona". Previamente, la imagen de dicha persona debe estar siendo captada por el sistema. Como lo que interesa es que el sistema cuente con numerosas capturas del mismo rostro con distintas posiciones y gestos, una vez pulsado, esta persona, deberá variar ligeramente aspectos como la rotación, inclinación, posición de los ojos, labios, etc. Para evitar la aparición de imágenes iguales, por defecto, el sistema captura imágenes cada 3 frames. El número de imágenes almacenado será de 100. En caso de que el nombre introducido ya exista en el sistema, se añadirán otro conjunto de imágenes a dicha persona. De esta forma, es posible aumentar el número de imágenes cambiando, por ejemplo, las condiciones de iluminación.

- Almacenamiento de imágenes y vídeos

Si se desea almacenar una captura de imagen del instante actual, habrá que pulsar sobre el botón "Guardar imagen". Aparecerá una ventana para introducir un nombre y ruta en la que queremos guardar la imagen. Tras aceptar, quedará almacenada en disco en dicha localización.
Si lo que se desea es almacenar el vídeo que se está viendo en tiempo real, se debe pulsar sobre "Guardar Vídeo". En este caso, la captura no empieza hasta que no se ha introducido la ruta y el nombre del archivo. Tras ello, para para la grabación habrá que pulsar nuevamente sobre el mismo botón, que habrá cambiado su texto a "Detener grabación".
