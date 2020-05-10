# Apuntes dockers
Los containers sueles ser confundidos con máquinas virtuales (MV), pero tienen importantes diferencias.
La principal es que las máquinas virtuales tienen un kernel cada una, a diferencia de los dockers que corren sobre el kernel del host. Esto hace que las MV sean notoriamente más lentas y requieran de minutos para arrancar, a diferencia de los containers que solo requieren segundos.

![alt text](https://www.nakivo.com/blog/wp-content/uploads/2019/05/Docker-containers-are-not-lightweight-virtual-machines.png "Diferencia entre VM y containers")

Lo atractivo de los dockes es que permiten
+ Asegurar el funcionamiento de las apps en un mismo ambiente, sea donde sea que esté corriendo
+ Proyectos aislados. Eliminar conflictos de librerías y problemas de seguridad.
+ Permite que uno pueda continuar de forma simple proyectos de otras personas.

## Instalación
Los detalles de la instalación del docker engine para ubuntu se pueden encontrar en este [link](https://docs.docker.com/engine/install/ubuntu/). Existe un _Convenience Script_ al final del tutorial, que si todo sale bien hace la instalación por si solo. Pero se recomienda seguir los pasos.

## Conceptos importantes
+ __Docker File__: consiste en un simple .txt para crear el container. Se hace un __build__ sobre este y con eso se crea la imagen, que luego se usa para hacer __run__ al docker
Por ejemplo un docker file simple consiste en 3 cosas 
```
FROM php:7.0-apache
COPY src/ var/www/html
EXPOSE 80
```
La primera línea contiene el template en que se basa, la segunda copia al directorio de la imagen al directorio de la imagen a utilizar y la tercera consiste en el puerto al que se le hace caso.

+ __Imagen__: Es una foto de cierto momento, un template del ambiente. Consiste y contiene los siguientes elementos:
    * OS
    * Software
    * Código de la aplicación

+ __Volume__: cada container tiene su propia estructura de almacenamiento. Si se borra el container, se borran los datos.
Para esto se debe _persistir_ la data, es decir, mapear del host al container.

```
docker run -v /path/host:/path/docker <name>
```

+ __Port__: La gestión de los port es importante porque permiten responder a la pregunta de ¿Como el usuario accede a mi app?
Cada container tiene una ip asignada por default, pero esta es solo accesible desde el docker host, mediante, por ejemplo, el navegador.
Para externos, se puede acceder a la ip del docker host habiendo mapeado el port del container a un port libre del host, mediante

```
$ docker run -p port_host:port_docker <name>
```
Con esto el externo puede acceder a la app mediante `ip_host:port_host`


## Comandos básicos

### Ver la versión del container
```
$ docker version
```

### Ver los containers
Con `docker ps` se ven los que corren, y el argumento `-a` permite ver los que están inactivos
```
$ docker ps
```
```
$ docker ps -a
```

### Ver las imágenes disponibles
```
$ docker images
```

### Manipular los containers
Correr

```
$ docker run <image name>
```

Correr y asignar un nombre (`app_name`)

```
$ docker run --name <app_name> <image_name>
```

Detener

```
$ docker stop <container_id>
```

Eliminar un container

```
$ docker rm <container id | container name>
```

Eliminar una imagen
```
$ docker rmi <image name>
```

Obtener una imagen
```
$ docker pull <image name>
```
Ejecutar un comando en un container corriendo
```
$ docker exec <name> cat /etc/hosts
```
Detach/attach
```
$ docker run -d <name>
$ docker attach <id>
```
### Inspeccionar un container
Esto es útil en caso de que se quiera modificar algún parámetro (por ejemplo contraseñas) al correr un container. Se puede ver en un __json__ donde está el parámetro y que valor toma.
Esto es especialmente útil para ver las __environment variables__ que pueden ingresarse para correr el container de cierta forma.
```
$ docker inspect <name>
```
Para inspeccionar que es lo que está almacenando
```
docker logs <container id | container name>
```

### Environment Variables
Algunas aplicaciones, por ejemplo una simple que tira un texto, como un de los ejemplos

Al usar `docker inspect` se pueden encontrar las variables de ambiente que pueden modificarse en `config/env`.

## Ejemplo
Se creará una simple página web, se creará el `Dockerfile`, se hará el `build` hacia la imagen y se correrá la imagen. El ejemplo está en el repositorio en `ej_flask_v1`
Los pasos a seguir son los siguientes
+ OS - Ubuntu
+ Update apt repo
+ Installar dependencias usando apt
+ Instalar dependencias de Python usando pip
+ Copiar código fuente a `/opt`
+ Correr el servidor web usando comando flask

### Dockerfile
Instrucciones + Argumentos. Izquierda instrucciones y derecha argumentos.
Todas las imagenes se basan en otra imagen basada en un OS o simplemente basada en un  OS.
```
FROM Ubuntu
RUT apt-get update
RUN apt-get install python

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```
Para montar la imagen
```
docker build Dockerfile -t ej_flask_v1
```

Para subirla a la página de docker
```
docker push <nombre_cuenta_docker_hub/nombre_app>
```
Puede que sea necesario logearse primero.

## CMD vs ENTRYPOINT
Imágenes como `ubuntu` no poseen ningún proceso, por ende se iniciar y terminan inmediatamente.
En el `Dockerfile`, el parámetro que está en la Instrucción `CMD` es el que se ejecuta, en `ubuntu` por ejemplo es `bash` por defecto. Esto implica que se le pueden pasar parámetros, o que al usar la imagen se puede modificar y poner `CMD sleep 5` por ejemplo.

Para poner argumentos es posible usar la instrucción `ENTRYPOINT`, la cual indica una acción, por ejemplo, para hacer dormir el ubuntu 10 segundos, se pone en el `Dockerfile`
```
FROM ubuntu
ENTRYPOINT ['sleep']
CMD ['5']
```
Y al correr la imagen basta con correr
```
$ docker run ubuntu-sleeper 10
```
Automáticamente asociará el parámetro con la instrucción especificada por el `ENTRYPOINT`.
Como la función debe tener un parámetro, con `CMD` es posible poner uno por defecto, en este caso 5. Si esto no se hace y no se especifica un parámetro dará error.

Es posible pisar el parámetro, especificando 
```
$ docker run --entrypoint sleep2.0 ubuntu-sleeper 10
```

## Docker Networking
Al instalar docker se crean 3 redes automáticas
+ Bridge: creada por defecto. Corresponde al conjunto de ips que se van creando entre containers para entenderse dentro del host, una red virtual privada. Para acceder desde otro lado se deben mapear desde puerto del host a puerto del docker. Por defecto crea una sola, pero puede generar más.
Es posible crear redes de containers aisladas, mediante
```
docker network create \
    --driver bridge \
    --subnet <ip adress/port>
    <nombre_red>
```

Y listarlas mediante:
```
docker network ls
```
 Para inspeccionar la red a la que pertenece basta con usar `inspect`.
+ None: Red aislada, sin acceso a host o red de containers.
+ Host: se puede configurar el container para que utilice la red del host, sin tener que mapear, pero esto impide mapear múltiples.

### Embedded DNS
Para acceder a otros containers, se pueden utilizar las ip asignadas, simplemente con
```
mysql.connect(<ip_adress>)
```
Pero no es lo ideal, porque las ips pueden cambiar cuando el sistema de reinicia. Por ende es mejor usar el nombre
```
mysql.connect(<docker_name>)
```

## Docker Storage
Donde almacena data y archivos del sistema.
Al instalar dockers, se crea por defecto 
```
/var/lib/docker
    aufs
    containers
    image
    volumes
```

Para entender como se almacenan archivos en el container hay que entender el concepto de `layered architecture`. Esta es creada por el orden de las instrucciones del Dockerfile, y cada una tiene un peso incremental sobre la capa anterior.
Esto también implica que al crear multiples aplicaciones con la misma base, el peso que tiene cada capa repetida es cero, y solo se agregan las nuevas.

Las capas de la imagen son __Read Only__, los cambios de archivos o modificaciones se hacen en la capa del container. Esto debido a que la modificación de la imagen puede afectar múltiples dockers, pero a veces es necesario hacer modificaciones. Para esto, en la capa de container se crea una copia de la modificación.

![layers](imagenes/layers.png)

### Volumes
Como se mencionó antes, se puede mapear una carpeta del host al docker, para no perder data si se destruye el docker, estas se pueden mapear donde sea, pero dentro de la carpeta de instalación del docker se puede crear uno nuevo con
```
docker volume create data_volume
```

Y mapeándolo mediante
```
docker run -v data_volume:/path/docker <container_name>
```
Este tiene el nombre de `volume mounting`, cuando es por defecto, y `bind mount`, cuando está en otro lugar y se debe especificar la ruta completa.

De hecho, la sintaxis recomendada equivalente es la siguiente
```
docker run --mount type=bind, source=/path/host/, target=/path/docker/ <container_name>
```

## Docker compose
Importante para crear apps complejas con múltiples servicios y opciones. Solo útil para todos los dockers corriendo en el mismo host.

## Docker Registry
Docker hub, docker login

## Docker Engine

# Bibliografía y enlaces útiles
[Docker Tutorial for Beginners - A Full DevOps Course on How to Run Applications in Containers](https://www.youtube.com/watch?v=fqMOX6JJhGo&t=1209s)

[Docker Series — Creating your first Dockerfile. Medium](https://medium.com/pintail-labs/docker-series-creating-your-first-dockerfile-573bfea4991)

[Learn Docker in 12 Minutes](https://www.youtube.com/watch?v=YFl2mCHdv24&t=)
