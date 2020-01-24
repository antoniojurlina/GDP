library(dplyr)
library(readr)
library(stringr)
library(tidyr)

gdp_csv <- read_csv(paste0(paste0(here::here(), "/CAGDP2/"),
                           "CAGDP2__ALL_AREAS_2001_2018.csv"))

region_totals <- which(str_detect(gdp_csv$IndustryClassification, pattern = "All industry total"))

gdp_regional <- gdp_csv[region_totals, ] %>%
  separate(col = "GeoFIPS", into = c("FIPS", "location"), sep = '" ,"') %>%
  separate(col = "location", into = c("County", "State"), sep = ", ") %>%
  select(FIPS, County, State, Description, 11:27)

gdp_regional$State <- str_remove_all(gdp_regional$State, pattern = "/*")

gdp_regional <- gdp_regional[-which(is.na(gdp_regional$State)), ]

gdp_regional[, 5:21] <- sapply(gdp_regional[, 5:21], as.numeric)

columns_to_gather <- colnames(gdp_regional)[5:21]

gdp_regional_long <- gather(gdp_regional, columns_to_gather, key = "Year", value = "GDP") %>%
  mutate(Year = as.numeric(Year),
         FIPS = as.integer(FIPS))

save(gdp_regional_long, file = "gdp_regional_long.RData")
