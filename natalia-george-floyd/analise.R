library(tidyverse)
library(sf)
library(tidycensus)
library(extrafont)
loadfonts()

# Config do tidycensus ----------------------------------------------------

options(tigris_use_cache = TRUE)
census_api_key("c06729f47ca727f264fec12b37bb65ab2806188f", install = T)
Sys.getenv("CENSUS_API_KEY")
readRenviron("~/.Renviron")



# Carrega counties de NY --------------------------------------------------

counties <- get_acs(geography = "county", state = "NY", variables = "B01003_001E", geometry = T)


# Carrega pontos de protesto ----------------------------------------------

protest_points <- read_csv("george-floyd-exports-june-22 (1).csv")

protest_points_sf <- st_as_sf(
  protest_points,
  coords = c("longitude", "latitude"),
  crs = 4269)


# Filtra protestos que aconteceram nos counties de NY ---------------------

protests_ny <- st_intersection(counties, protest_points_sf)



# Filtra counties em que houve protestos ----------------------------------

#isso vai gerar um vetor com o id (no caso, o id é simplesmente o número da linha do df de counties)
counties_affected_list <- st_intersects(protests_ny, counties) %>% 
  unlist() %>%
  unique()

#agora filtro os counties que apareceram nesse vetor
#vou usar este objeto para acrescentar uma camada visual para destacar os counties em que ocorreram protestos com um preenchimento diferente
counties_affected <- counties %>%
  filter(row_number() %in% counties_affected_list)



# Plota -------------------------------------------------------------------

ggplot() +
  geom_sf(data = counties, aes(geometry = geometry), 
          color = "lightgrey", fill = 'ghostwhite') +
  geom_sf(data = counties_affected, aes(geometry = geometry), 
          color = "lightgrey", fill = 'khaki') +
  geom_sf(data = protests_ny, 
          aes(geometry = geometry, size = size, color = escalation),
          alpha = .5, fill = NA, shape = 21) + #stroke = 1) +
  labs(size = 'Size', color = 'Escalation?', title = 'Location of George Floyd Protests in the State of NY') +
  scale_size_manual(
    values = c(
      'Not recorded' = 1, 
      'Small' = 2, 
      'Moderate' = 4, 
      'Large' = 8)) +
  scale_color_manual(values = c('Yes' = 'firebrick', 'No' = 'dodgerblue')) +
  theme_void() +
  theme(text = element_text(family = 'Lato'))
