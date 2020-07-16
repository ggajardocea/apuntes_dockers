

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "Métricas"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Alarmas", tabName = "alarmas", icon = icon("exclamation-triangle")),
      menuItem("Métricas", tabName = "metricas", icon = icon("bar-chart")),
      menuItem("datos", tabName = "datos", icon = icon("chart-line")),
      menuItem("readMe", tabName = "readme", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    tabItems(
    tabItem(tabName = "metricas", color = "red",
            fluidRow(
              
              # Add box for graph 
              box(
                title = "Estimation Plot",
                solidHeader = TRUE,
                status = "primary",
                width = 9,
                plotlyOutput("plot")
               ),
              
              
              # Add box for estimation parameters
              box(
                width = 3,
                title = "Estimation Parameters",
                status = "primary",
                solidHeader = TRUE,
                
                # Users can choose between each dataset expect for the x variable
                selectInput("tabla", "Selecciona una tabla", choices = unique(data$tabla), selected = unique(data$tabla)[1]),
                uiOutput("secondSelection"),
                # selectInput("variable", "Selecciona una variable", unique(data$columna), selected = unique(data$tabla)[1]),
                selectizeInput("metrica", "Elige una metrica:", unique(data$metrica), selected = unique(data$metrica)[1], multiple = TRUE),
                
                actionButton("trigger_estimation","Graficar",
                             icon("play"),
                             class="estimation_button"
                )
              )
            )),
    
    tabItem(tabName = "alarmas", color = "red",
            fluidRow(
              
              # Add box for graph 
              box(
                title = "Variables con alarma",
                solidHeader = TRUE,
                status = "primary",
                width = 9,
                DT::dataTableOutput("alarmas")
                # plotlyOutput("plot")
                # dataTableOutput("plot")
              ),
              
              # Add box for Accuracy
              # valueBoxOutput("accuracy_box", width = 3),
              
              # Add box for estimation parameters
              box(
                width = 3,
                title = "Encontrar ",
                status = "primary",
                solidHeader = TRUE,
                
                # Users can choose between each dataset expect for the x variable
                selectInput("periodo", "Selecciona período", choices = unique(data$periodo), selected = unique(data$periodo)[length(unique(unique(data$periodo)))]),
                selectInput("metrica_alarma", "Selecciona métrica de alarma", choices = unique(data$metrica), selected = unique(data$metrica)[1]),
                selectInput("meses_historia", "Selecciona meses de historia", choices = 1:6, selected = 3),
                selectInput("perc_var", "Selecciona porcentaje de variación", choices = seq(5, 101, by = 5), selected = 10),
                # uiOutput("secondSelection"),
                # selectInput("variable", "Selecciona una variable", unique(data$columna), selected = unique(data$tabla)[1]),
                # selectizeInput("metrica", "Elige una metrica:", unique(data$metrica), selected = unique(data$metrica)[1], multiple = TRUE),
                
                actionButton("trigger_estimation2", "Mostrar alarmas",
                             icon("play"),
                             class="estimation_button"
                )
              )
            )),
    
    
    
    tabItem(tabName = "datos", color = "red",
            DT::dataTableOutput("mtcars")),
    
    # About Page
    tabItem(tabName = "readme",
            includeMarkdown("about.md"))
    )
  )
)