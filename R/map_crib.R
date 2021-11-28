library(tidyverse)
library(leaflet)
library(googlesheets4)
library(sf)

# Import sqlite of neighbourhoods
map <- sf::read_sf("C:/Users/xande/Desktop/Scripts/crib-conquistadores/assets/neighbourhoods.sqlite")

# Import info from google drive and merge with map
sht <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/189FIa05wdj_xtxH14iOMpNa5N0mHiy36MxrOiAh441s/edit#gid=0")

map <- merge(x = map, y = sht, by.x = 'name', by.y = 'Neighbourhood')

map$name[map$name == 'boonies'] <- 'the burbs'

map$lab <- rep(NA)

for (i in 1:nrow(map)) {
    
    if (map$Current_ruler[i] == 'Empty') {
        map$lab[i] <- paste0( '<p>', "<big>", "<b>", map$name[i], " has yet to be taken!", 
                              "</b>", "</big>", '<p></p>', "<center>", 
                              "<img src = https://raw.githubusercontent.com/XanderHuggins/crib-conquistadores/master/assets/empty.png",  
                              " style='height:100px'", ">", "</center>", '</p>' ) 
    }
    
    if (map$Current_ruler[i] == 'Devon') {
        map$lab[i] <- paste0( '<p>', "<big>", "<b>", "The current boss of ",  map$name[i], 
                              " is:", "</b>", "</big>", '<p></p>', "<center>", 
                              "<img src = https://raw.githubusercontent.com/XanderHuggins/crib-conquistadores/master/assets/devon.png",  
                              " style='height:250px;' ", ">", "</center>", '</p>' ) 
    }
    
    if (map$Current_ruler[i] == 'Xander') {
        map$lab[i] <- paste0( '<p>', "<big>", "<b>", "The current boss of ",  map$name[i], 
                              " is:", "</b>", "</big>", '<p></p>', "<center>", 
                              "<img src =https://raw.githubusercontent.com/XanderHuggins/crib-conquistadores/master/assets/xander.png",  
                              " style='height:250px;' ", ">", "</center>", '</p>' ) 
    }
    
    if (map$Current_ruler[i] == 'Alex') {
        map$lab[i] <- paste0( '<p>', "<big>", "<b>", "The current boss of ",  map$name[i], 
                              " is:", "</b>", "</big>", '<p></p>', "<center>", 
                              "<img src = https://raw.githubusercontent.com/XanderHuggins/crib-conquistadores/master/assets/alex.png",  
                              " style='height:250px;' ", ">", "</center>", '</p>' ) 
    }
    
    if (map$Current_ruler[i] == 'Kirsten') {
        map$lab[i] <- paste0( '<p>', "<big>", "<b>", "The current boss of ",  map$name[i], 
                              " is:", "</b>", "</big>", '<p></p>', "<center>", 
                              "<img src = https://raw.githubusercontent.com/XanderHuggins/crib-conquistadores/master/assets/kirsten.png",  
                              " style='height:250px;' ", ">", "</center>", '</p>' ) 
    }
    
    if (map$Current_ruler[i] == 'David') {
        map$lab[i] <- paste0( '<p>', "<big>", "<b>", "The current boss of ",  map$name[i], 
                              " is:", "</b>", "</big>", '<p></p>', "<center>", 
                              "<img src = https://raw.githubusercontent.com/XanderHuggins/crib-conquistadores/master/assets/david.png",  
                              " style='height:250px; text-align:center' ", ">", '</p>' ) 
    }
    
    
}

# reclassify ruler into number ... 
map$col <- rep(NA)
map$col[map$Current_ruler == 'Empty']  <- '#656565'
map$col[map$Current_ruler == 'Devon']  <- '#F05B3A'
map$col[map$Current_ruler == 'Xander'] <- '#098BDA'
map$col[map$Current_ruler == 'Alex']   <- '#EAB126'
map$col[map$Current_ruler == 'Kirsten'] <- '#3CAB4F'


leaflet() %>%
    addProviderTiles(providers$Stamen.Terrain) %>%
    addPolygons(data = map, 
                color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = map$col,
                highlightOptions = highlightOptions(color = "black", weight = 5, bringToFront = TRUE),
                label = lapply(map$lab, htmltools::HTML))