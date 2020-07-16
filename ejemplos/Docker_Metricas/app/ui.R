

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "Métricas"),
  
  dashboardSidebar(
    sidebarMenu(
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
                # dataTableOutput("plot")
              ),
              
              # Add box for Accuracy
              # valueBoxOutput("accuracy_box", width = 3),
              
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
    tabItem(tabName = "datos", color = "red",
            DT::dataTableOutput("mtcars")),
    
    # About Page
    tabItem(tabName = "readme",
            includeMarkdown("about.md")))
  )
)