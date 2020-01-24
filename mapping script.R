library(dplyr)
library(ggplot2)
library(ggthemes)
library(gganimate)
library(maps)

load("gdp_regional_long.RData")

map("county")

map_data("county")
map_data("state")



