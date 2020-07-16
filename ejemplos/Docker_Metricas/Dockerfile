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
RUN R -e "install.packages(c('dplyr', 'data.table', 'DBI', 'bit64', 'RPostgres', 'shinydashboard', 'plotly'), repos='http://cran.rstudio.com/', dependencies = TRUE)"
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
RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]

# Correr el script
CMD ["/usr/bin/shiny-server.sh"]