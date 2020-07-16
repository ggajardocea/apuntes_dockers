library(plotly)
tabla <- c("clientes.pf_acoc_emp")
metricas <- c("min")
variable <- c("monto.cuota.inicial")

unique(data$tabla)
grafico <- data %>% 
  filter(tabla == tabla,
         metrica %in% metricas,
         columna == variable) %>% 
  ggplot(aes(x = periodo, y = valor, group = metrica, color = metrica)) +
  geom_line() +
  geom_point() +
  labs(title = paste0("Métricas de ", variable),
       x = "Periodo", y = "Valor", color = "Métrica")

ggplotly(grafico)
