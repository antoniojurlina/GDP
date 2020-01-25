#-------- packages --------
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(maps)

#-------- importing data --------
gdp_csv <- read_csv(paste0(paste0(here::here(), "/CAGDP2/"),
                           "CAGDP2__ALL_AREAS_2001_2018.csv"))

county_data <- map_data("county")

#-------- cleaning the data --------
region_totals <- which(str_detect(gdp_csv$IndustryClassification, pattern = "All industry total"))

gdp_regional <- gdp_csv[region_totals, ] %>%
  separate(col = "GeoFIPS", into = c("fips", "location"), sep = '" ,"') %>%
  separate(col = "location", into = c("subregion", "region"), sep = ", ") %>%
  select(fips, subregion, region, description = Description, 11:27) %>%
  filter

gdp_regional$region <- str_remove_all(gdp_regional$region, pattern = "\\*")

gdp_regional$subregion[1838] <- "dona ana" 
gdp_regional$subregion <- tolower(gdp_regional$subregion)

gdp_regional <- gdp_regional[-which(is.na(gdp_regional$region)), ]

gdp_regional[, 5:21] <- sapply(gdp_regional[, 5:21], as.numeric)

region_remove <- c(which(str_detect(gdp_regional$region, pattern = c("AK"))),
                   which(str_detect(gdp_regional$region, pattern = c("HI"))),
                   which(str_detect(gdp_regional$region, pattern = c("Staunton \\+ Waynesboro"))),
                   which(str_detect(gdp_regional$region, pattern = c("Colonial Heights \\+ Petersburg"))),
                   which(str_detect(gdp_regional$region, pattern = c("Fairfax City \\+ Falls Church"))),
                   which(str_detect(gdp_regional$region, pattern = c("Manassas \\+ Manassas Park"))),
                   which(str_detect(gdp_regional$region, pattern = c("Buena Vista \\+ Lexington"))))

gdp_regional <- gdp_regional[-region_remove, ]

#-------- merging the gdp data with county lat and long data --------
gdp_regional_region_names <- unique(gdp_regional$region)
county_data_region_names <- unique(county_data$region)

for(i in seq_along(gdp_regional_region_names)) {
  gdp_regional$region[which(gdp_regional$region == gdp_regional_region_names[i])] <- county_data_region_names[i]
}

gdp_regional <- left_join(county_data, gdp_regional, by = c("subregion", "region"))

#-------- turning the data frame from wide to long and saving it --------
columns_to_gather <- colnames(gdp_regional)[9:25]

gdp_regional_long <- gather(gdp_regional, columns_to_gather, key = "year", value = "gdp") %>%
  mutate(year = as.numeric(year),
         fips = as.integer(fips))

save(gdp_regional_long, file = "gdp_regional_long.RData")


