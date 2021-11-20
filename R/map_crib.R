library(tidyverse)
library(leaflet)
library(googlesheets4)
library(sf)

# Import sqlite of neighbourhoods
map <- sf::read_sf("C:/Users/xande/Desktop/Scripts/crib-conquistadores/assets/neighbourhoods.sqlite")

# Import info from google drive and merge with map
sht <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/189FIa05wdj_xtxH14iOMpNa5N0mHiy36MxrOiAh441s/edit#gid=0")
map <- merge(x = map, y = sht, by.x = 'name', by.y = 'Neighbourhood')

# reclassify ruler into number ... 
map$col <- rep(NA)
map$col[map$Current_ruler == 'Devon'] <- '#EAB126'
map$col[map$Current_ruler == 'Xander'] <- '#098BDA'
map$col[map$Current_ruler == 'Alex'] <- '#F05B3A'
# 

map$popup_text <- 
    paste0('<center> The current conquistador of ', '<strong>', map$name, '</strong>', ' is:', '<br/>',
           map$Current_ruler, '</center>')
    
leaflet() %>%
    addProviderTiles(providers$Stamen.Terrain) %>%
    addPolygons(data = map, 
                color = "#444444", weight = 1, smoothFactor = 0.5,
                # color = ~no,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = map$col,
                highlightOptions = highlightOptions(color = "black", weight = 5, bringToFront = TRUE),
                label = lapply(map$popup_text, htmltools::HTML))
