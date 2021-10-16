library(tidyverse)
library(extrafont)

temp_fahre <- 0:150

f_oficial <- function(t) {(t-32)*5/9} 
f_mene    <- function(t) {(t - 30)/2}

celsius_oficial <- f_oficial(temp_fahre)
celsius_mene    <- f_mene(temp_fahre)

temps <- data.frame(temp_fahre, celsius_oficial, celsius_mene) %>%
  gather(celsius_oficial, celsius_mene, 
         key = tipo, 
         value = valores)

ggplot(temps, 
       aes(x = temp_fahre, y = valores, color = tipo)) + 
  geom_line(size = 1.5) +
  ylim(c(NA, 45)) +
  xlim(c(NA, 125)) +
  labs(x = 'Temperatura em Fahrenheit', 
       y = 'Temperatura convertida para Celsius', 
       color = "Tipo de conversão",
       title = "Uma forma simplificada de calcular temperaturas",
       subtitle = "Desenvolvido por Rodrigo Menegat, Polymath") +
  scale_color_brewer(palette = 'Accent') + 
  theme_minimal() +
  theme(text = element_text(family = 'Lato'),
        plot.title = element_text(face = "bold"),
        legend.position = "bottom")

