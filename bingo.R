library(tidyverse)
library(extrafont)
loadfonts()

#  parâmetros -------------------------------------------------------------

qde_cartelas <- 12
maior_numero <- 50
dim_cartela <- c("linhas"  = 3, 
                 "colunas" = 3)
qde_numeros_cartela <- dim_cartela["linhas"] * dim_cartela["colunas"]


# constroi uma base com os numeros de cada cartela ------------------------

base_cartelas <- data.frame(n = 1:qde_numeros_cartela)

for (i in 1:qde_cartelas) {
  base_cartelas[,ncol(base_cartelas)+1] <- sort(sample(1:maior_numero, qde_numeros_cartela, replace = FALSE))
  colnames(base_cartelas)[i+1] <- paste0("Cartela_", str_pad(i, width = 3, pad = "0"))
}

# ajusta a base para o plot -----------------------------------------------

base_cartelas_ajustada <- base_cartelas %>%
  mutate(x = ((n-1) %%  dim_cartela["colunas"]) + 1,
         y = ((n-1) %/% dim_cartela["colunas"]) + 1) %>%
  gather(starts_with("Cartela_"), key = "Cartelas", value = "Numeros")

# a ideia é que se dividirmos um determinado número, subtraído de 1, pela quantidade de colunas, o quociente (obtido com o operador %/%) vai indicar a coluna em que o número deve ser posicionado, e o resto da divisão (obtido com o operador %%), a linha. Como estamos no R, acrescentamos 1 a esses valores de linhas e coluna.
 

# o plot propriamente dito ------------------------------------------------

bingo <- ggplot(base_cartelas_ajustada, aes(x = x, y = -y, label = Numeros)) +
  geom_tile(width = 1, height = 1, fill = "ghostwhite", color = "darkgrey") +
  geom_text(hjust = "center", vjust = "center", family = "Roboto Slab", color = "#333333") +
  annotate("text", x = 2, y = 0, label = "B I N G O", hjust = "center", 
           family = "Roboto Mono", fontface = "bold", color = "#333333") +
  facet_wrap(~Cartelas, ncol = 3) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        strip.text = element_blank(),
        legend.position = "none",
        text = element_text(family = "Roboto Slab", 
                            color = "#555555"),
        plot.caption = element_text(color = "#333333", face = "italic"),
        plot.title = element_text(family = "Calibri", face = "bold", hjust = "0.5"))

ggsave(bingo, file = "bingo.png", width = 6, height = 8, type = "cairo-png")
  
