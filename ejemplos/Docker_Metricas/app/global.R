# Librerías ---------------------------------------------------------------
library(dplyr)
library(data.table)
library(DBI)
library(bit64)
library(shinydashboard)
library(plotly)
library(lubridate)
# library(RPostgres)

# Fuentes de datos --------------------------------------------------------
path <- "/mnt/shared-bda/files_project/pedidos_random/"
data <- readRDS(paste0(path, "files/datasets/output/seguimiento_metricas/ejemplo_profundidad.rds"))

# Correr la app
source("server.R")
source("ui.R")
shinyApp(ui, server)
