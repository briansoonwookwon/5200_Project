library(rvest)
library(tidyverse)
library(plotly)

# Parse 2019 crime rate data from wikipedia
url = "https://en.wikipedia.org/wiki/List_of_United_States_cities_by_crime_rate"
page = read_html(url)
tables = html_table(page, fill = TRUE)
crime_data = tables[[1]]

# Preprocess the dataset
colnames(crime_data) = crime_data[2, ]
crime_data = crime_data[-c(1,2), ]
crime_data = crime_data %>% select(1,2,3,4) # Remove unnecessary columns
colnames(crime_data) = c("state", "city", "population", "crime_rate") # Change column names
crime_data$population = as.numeric(gsub(",", "", crime_data$population)) # Change to numeric
crime_data$crime_rate = as.numeric(crime_data$crime_rate) # Change to numeric

# Leave only one city per state by population
crime_data = crime_data %>%
  group_by(state) %>%
  slice(which.max(population))

# Remove footnote number
crime_data$city = gsub("\\d+$", "", crime_data$city)
crime_data$state =  gsub("\\d+$", "", crime_data$state)

# Change some city name manually for merging
crime_data = crime_data %>%
  mutate(city = if_else(city == "Washington, D.C.", "Washington", city)) %>%
  mutate(city = if_else(city == "Louisville Metro", "Louisville", city))

# Get latitude and longitude data
location = read.csv("./data/uscities.csv")
location = location %>% select(1,4,lat,lng)

# Merge two data sets
df = merge(crime_data, location, by = "city")
df = df %>% 
    filter(state == state_name) %>%
    select(-state_name)

# Plot bubble map
df %>%
  plot_geo(lat = ~lat, lon = ~lng) %>%
  add_markers(
    text = ~city, 
    size = ~crime_rate, 
    color = ~crime_rate,
    marker = list(
      sizemode = 'area',  
      sizeref = 0.2       
    )
  ) %>%
  layout(
    title = 'US Cities Crime Rate Map', 
    geo = list(scope = 'usa')
  )
