#-------- packages --------
library(dplyr)
library(ggplot2)
library(ggthemes)
library(gganimate)
library(maps)

#-------- importing data --------
load("gdp_regional_long.RData")

state_geo_data <- map_data("state")

#-------- creating a map for a desired year --------
design_color <- "snow"

plot <- ggplot(data = gdp_regional_long %>%
                 filter(year == 2017)) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = gdp), 
               colour = design_color,
               size = 0.02)

plot <- plot + theme_map() +
  coord_fixed(1.3)

plot <- plot + geom_polygon(data = state_geo_data, 
                            aes(x = long, y = lat, group = group), 
                            colour = design_color, 
                            fill = "transparent",
                            size = 0.09)

plot <- plot + viridis::scale_fill_viridis(option = "inferno", labels = scales::comma)

plot <- plot + theme(panel.background = element_rect(fill = design_color, colour = design_color),
             plot.background = element_rect(fill = design_color),
             legend.background = element_rect(fill = "transparent"),
             legend.title = element_text(face = "bold"))

plot <- plot + labs(title = "U.S. GDP by County",
                    subtitle = "2017",
                    caption = "source: Bureau of Economic Analysis, U.S. Department of Commerce",
                    fill = "GDP (2019 USD)")

plot <- plot +  
  annotate(geom = "text", 
           x = -73.5, 
           y = 30, 
           label = paste0("Total GDP: ", gdp_regional_long %>%
                           filter(year == 2017) %>%
                           select(gdp) %>%
                           unique() %>%
                           summarize(gdp = sum(gdp, na.rm = TRUE)) %>%
                           pull(1) %>%
                           scales::comma()),
           size = 4) 

ggsave("plot.png", plot, height = 7, width = 10)

#-------- creating a gif (remove year filter if doing so) --------
gif <- plot +
  transition_time(year)

anim <- animate(gif, height = 800, width = 1000)

anim_save("gif.gif", anim)




