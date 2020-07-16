## Seguimiento métricas
Este es un MVP para el seguimiento de métricas del CoE Empresas. Se busca:

+ Proponer herramienta de visualización de calidad del dato
+ Generar un sistema de alarmas para las variables
+ Hacer métricas de calidad para 3 tipos de variables
    + __Identificadores__: ruts, descr moviles, grupo cliente, etc...
        + __nChar__: Cantidad de characteres promedio del identificador
        + __nCat__: Cantidad de registros únicos
        + __nNull__: Cantidad de nulos
        + __pNull__: Proporción de nulos
  
    + __Numéricas__
        + __min__
        + __max__
        + __mean__
        + __median__
  
    + __Categóricas__
        + __nCat__: Cantidad de categorías
        + __nNull__: Cantidad de nulos
        + __pNull__: Proporción de nulos
        + __pMode__: Proporción de la categoría moda
        
### Cosas que resolver

+ En algunos casos los nulos de la ETL se llenan con ceros, se consideraron vacíos para las categóricas, pero hay que ver que hacer con las numéricas. 
+ Algunos botones hacen lo que quieren. Malditos