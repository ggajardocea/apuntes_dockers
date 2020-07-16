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
          mutate(periodo = ymd(periodo)) %>% 
          filter(tabla == input$tabla,
                 metrica %in% input$metrica,
                 columna == input$variable) %>%
          ggplot(aes(x = periodo, y = valor, group = metrica, color = metrica)) +
          geom_line() +
          geom_point() +
          labs(title = paste0("Métricas de ", input$variable, ". (", class(input$variable), ")"),
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
  
  
  observeEvent(input$trigger_estimation2, {
    output$alarmas <- DT::renderDataTable({
      data %>%
        filter(periodo >= (ymd(input$periodo) - months(as.numeric(input$meses_historia))),
               metrica %in% input$metrica_alarma) %>% 
        mutate(tipo_periodo = case_when(periodo == ymd(input$periodo) ~ "nuevo", 
                                        TRUE ~ "historia")) %>% 
        group_by(tipo_periodo, columna) %>% 
        summarise(valor = mean(valor)) %>% 
        pivot_wider(id_cols = columna, names_from = tipo_periodo, values_from = valor) %>% 
        mutate(cambio_perc = round(100*abs(nuevo - historia)/historia, 2)) %>% 
        filter(cambio_perc >= as.numeric(input$perc_var))
    })
  })
  
}