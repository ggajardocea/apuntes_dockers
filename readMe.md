# Tutorial dockers
Los containers sueles ser confundidos con máquinas virtuales (MV), pero tienen importantes diferencias.
La primera es que las máquinas virtuales tienen un OS cada una, a diferencia de los dockers que corren sobre el OS del host. Esto hace que las MV sean notoriamente más lentas y requieran de minutos para arrancar, a diferencia de los containers que solo requieren segundos.

![alt text](https://www.nakivo.com/blog/wp-content/uploads/2019/05/Docker-containers-are-not-lightweight-virtual-machines.png "Diferencia entre VM y containers")

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
