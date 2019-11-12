library(tidyverse)
library(readxl)

dados_brutos <- read_excel("macro_criacao_UOs_Siafi/planilha_CCONT.xlsx", sheet = "lista_formatada", col_names = c("UO", "DetalheUO1", "DetalheUO2"))

k <- 1
saida <- c()

for (i in 1:nrow(dados_brutos)) {
  saida[k]   <- dados_brutos$UO[i]
  saida[k+1] <- dados_brutos$DetalheUO1[i]
  saida[k+2] <- dados_brutos$DetalheUO2[i]
  k <- k+3
}

write.csv2(saida, file = "macro_criacao_UOs_Siafi/lista_colar.csv", row.names = FALSE)
