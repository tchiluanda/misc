library(tidyverse)

data <- read.csv2('EXP_2021.csv')

ncms_interesse <- c(02031100, 02031200, 02031900, 02032100, 02032200, 02032900)

data_suino <- data %>%
  filter(CO_NCM %in% ncms_interesse)

tab_ncm <- read.csv2('NCM.csv') %>%
  select(CO_NCM, NO_NCM_POR) %>%
  mutate(CO_NCM = as.numeric(CO_NCM))

tab_via <- read.csv2('VIA.csv')
tab_urf <- read.csv2('URF.csv')
tab_unidade <- read.csv2('NCM_UNIDADE.csv')
tab_pais <- read.csv2('PAIS.csv') %>%
  select(CO_PAIS, NO_PAIS) %>%
  mutate(CO_PAIS = as.numeric(CO_PAIS))

data_completo <- data_suino %>%
  left_join(tab_ncm) %>%
  left_join(tab_urf) %>%
  left_join(tab_via) %>%
  left_join(tab_unidade) %>%
  left_join(tab_pais)

data_export <- data_completo %>%
  select(
    Ano = CO_ANO,
    Mes = CO_MES,
    Nome_Item_NCM = NO_NCM_POR,
    Origem_URF = NO_URF,
    Estado = SG_UF_NCM,
    Pais_destino = NO_PAIS,
    Via = NO_VIA,
    Quantidade_kg = KG_LIQUIDO,
    Valor_FOB = VL_FOB
  )



write.csv2(data_export, file = 'exportacoes_suinos_2021.csv', fileEncoding = "UTF-8")
