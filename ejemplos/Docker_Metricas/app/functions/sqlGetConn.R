sqlGetConn = function(server_name){
  tryCatch({
    if("expression" %in% class(server_name)){
      connObj = server_name
      if("expression" %in% class(connObj)){
        connObj = eval(connObj)
      }
    }else if("character" %in% class(server_name)){
      connObj = sqlServers[[server_name]]
      if("expression" %in% class(connObj)){
        connObj = eval(connObj)
      }
    }else{
      connObj = server_name
    }
  },error = function(e){
    stop("Cant connect to Database, wrong login parameters")
  })
  
  
  if(version$os == "mingw32"){
    
  }else{
    # sqlQuery(connObj,"SET ANSI_PADDING ON")
    # sqlQuery(connObj,"SET ANSI_WARNINGS ON")
    # sqlQuery(connObj,"SET ANSI_NULLS ON")
  }
  return(connObj)
}