# Librerías ---------------------------------------------------------------
# source("functions/sqlGetConn.R")
# source("functions/sqlGetQuery.R")
library(dplyr)
library(data.table)
library(DBI)
library(bit64)
library(shinydashboard)
library(plotly)
# library(RPostgres)

# Fuentes de datos --------------------------------------------------------
data <- readRDS("ejemplo_tablas2.rds")

# Conexiones

# sqlGetConn = function(server_name){
#   tryCatch({
#     if("expression" %in% class(server_name)){
#       connObj = server_name
#       if("expression" %in% class(connObj)){
#         connObj = eval(connObj)
#       }
#     }else if("character" %in% class(server_name)){
#       connObj = sqlServers[[server_name]]
#       if("expression" %in% class(connObj)){
#         connObj = eval(connObj)
#       }
#     }else{
#       connObj = server_name
#     }
#   },error = function(e){
#     stop("Cant connect to Database, wrong login parameters")
#   })
# 
# 
#   if(version$os == "mingw32"){
# 
#   }else{
#     # sqlQuery(connObj,"SET ANSI_PADDING ON")
#     # sqlQuery(connObj,"SET ANSI_WARNINGS ON")
#     # sqlQuery(connObj,"SET ANSI_NULLS ON")
#   }
#   return(connObj)
# }
# #
# sqlGetQuery = function(server_name,query, param = c(),dt=FALSE,key=c(),  ...){
#   try({
#     sql = sqlGetConn(server_name)
#     # query = sqlGsub(query,param)
#     # print(query)
#     rowset = dbGetQuery(sql,query,...)
#   })
# 
#   if(dt){
#     rowset = as.data.table(rowset)
#     setkeyv(rowset,key)
#     return(rowset)
#   }
#   else{
#     return(rowset)
#   }
# }
# 
# 
# datamart = expression({
#   dbConnect(
#     dbDriver("Postgres"),
#     dbname = "data_mart",
#     user = "userbda",
#     password = "Entel2018",
#     host = "bdadatamart.cqivfeqeecje.us-east-1.redshift.amazonaws.com",
#     bigint = "integer64",
#     port = 5439
#   )
# })
# 
# data2 <- sqlGetQuery(datamart, "select * from clientes.pdeuda_movil limit 10")
# datamart = eval(datamart)
# DBI::dbDisconnect(datamart)

# Correr la app
source("server.R")
source("ui.R")
shinyApp(ui, server)
