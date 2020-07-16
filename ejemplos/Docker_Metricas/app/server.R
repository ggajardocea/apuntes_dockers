server <- function(input, output) { 
  output$secondSelection <- renderUI({
    selectInput("variable", "Selecciona una variable", 
                   choices = data$columna[data$tabla == input$tabla],
                 selected= unique(data$columna[data$tabla == input$tabla])[1])
  })
  
  observeEvent(input$trigger_estimation, {
    output$plot <- renderPlotly({
      if (input$trigger_estimation == 0){ggplot()}
      else {
        grafico <- data %>%
          filter(tabla == input$tabla,
                 metrica %in% input$metrica,
                 columna == input$variable) %>%
          ggplot(aes(x = periodo, y = valor, group = metrica, color = metrica)) +
          geom_line() +
          geom_point() +
          labs(title = paste0("Métricas de ", input$variable),
               x = "Periodo", y = "Valor", color = "Métrica")
        
        ggplotly(grafico)
      }
    }
    )
  })
  
  
  observeEvent(input$trigger_estimation, {
    output$mtcars <- DT::renderDataTable({
      data %>%
        filter(tabla == input$tabla,
               metrica %in% input$metrica,
               columna == input$variable)
    })
  })
  
}