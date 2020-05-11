# Tutorial ShinyApp Linear Models
Esta app no es más que un robo de aca [este tutorial](https://www.bjoern-bos.de/post/learn-how-to-dockerize-a-shinyapp-in-7-steps/), con algunas modificaciones pequeñas para que me funcionara en la instancia.
Cualquier cosa están los archivos listos para ejecutarlos en mi [github](https://github.com/ggajardocea/apuntes_dockers/tree/master/ejemplos/Docker_ShinyApp).

Aca muestro las modificaciones:

## Dockerfile
Se muestra el dockerfile con las modificaciones que tuve que hacer

``` r
# Instalar R 3.5
FROM r-base:3.5.0

# NUEVO: Definir los proxys 
ENV http_proxy 'http://proxy.analytics-prd-cl.awslocal:8081'
ENV https_proxy 'http://proxy.analytics-prd-cl.awslocal:8081'

# Instalar los paquetes de ubuntu
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev

# Instalar la última versión de Shinyserver
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# Instalar los paquetes requeridos, la primera linea son los que yo agregué
RUN R -e "install.packages(c('dplyr', 'data.table'), repos='http://cran.rstudio.com/', dependencies = TRUE)"
RUN R -e "install.packages(c('shiny', 'shinydashboard'), repos='http://cran.rstudio.com/', dependencies = TRUE)"

# Copiar los archivos de configuración y la app a la imagen
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY /app /srv/shiny-server/

# Utilizar el puerto 80
EXPOSE 80

# NUEVO: cambiar permisos
RUN sudo chown shiny:shiny /var/lib/shiny-server
RUN sudo chown -R shiny:shiny /srv/shiny-server

# Copiar archivos de configuración a la imagen
COPY shiny-server.sh /usr/bin/shiny-server.sh

# Correr el script
CMD ["/usr/bin/shiny-server.sh"]
```

## Modificaciones a la App
La única modificación que hice fue que el archivo de data está ahora en txt, y lo leo y proceso un poco con dplyr. El global queda así

``` r
library(dplyr)
library(data.table)
data <- fread("data.txt", dec=",") %>% 
  mutate_all(as.numeric)

# Compute more values from x variable in a helper dataframe
data_helper <- NULL
data_helper$sqrt_x <- sqrt(data$x)
data_helper$x2 <- (data$x)^2
data_helper$x3 <- (data$x)^3
```

## Build + Run
Para el build es simplemente correr, estando en la carpeta donde se encuentra el `Dockerfile`:

``` bash
sudo dockebuild -t linear_models_3 .
```

Y luego correr la app considerando dos cosas
+ El mapeo de los puertos
+ Guardar los logs que quedan en la imagen en `/var/log/`, en alguna parte del host. Si no se hace esto es imposible saber por que falla la aplicación. 

``` bash
sudo docker run -p 80:80 -v /folder/with/docker:/var/log/ linear_models_3
```

## Push a Dockerhub
Una vez que el docker funciona, pueden subirlo al Dockerhub, asignándole un nombre y una versión. Antes de hacer push se debe:
+ Hacer login desde docker 
+ Crear el repositorio en [https://hub.docker.com/](https://hub.docker.com/) ponerle un nombre, digamos `app_pulenta`
+ Decidirnos por un tag para la versión que estamos pusheando

Esto en código es:

```
sudo docker login
```

``` r
sudo docker tag linear_models_3 <nombre_usuario>/app_pulenta:<tag_version>
```
```
docker push <nombre_usuario>/app_pulenta
```

## Trabajo futuro
+ Conectarse a redshift u otras fuentes de datos que no están en la docker image