sqlGetQuery = function(server_name,query, param = c(),dt=FALSE,key=c(),  ...){
  try({
    sql = sqlGetConn(server_name)
    # query = sqlGsub(query,param)
    # print(query)
    rowset = dbGetQuery(sql,query,...)
  })
  
  if(dt){
    rowset = as.data.table(rowset)
    setkeyv(rowset,key)
    return(rowset)
  }
  else{
    return(rowset)
  }
}