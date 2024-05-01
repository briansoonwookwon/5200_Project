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

# Color palette
# colors = c("#F1FAEE", "#A8DADC", "#457B9D", "#1D3557")
# colors = c("#ccdbdc","#9ad1d4","#80ced7","#007ea7","#003249")
colors = c("#ccdbdc","#edf8b1", "#7fcdbb", "#2c7fb8")
# colors = c("#caf0f8", "#ade8f4", "#90e0ef", "#48cae4", "#00b4d8", "#0096c7", "#0077b6", "#023e8a", "#03045e") 

# Plot bubble map
map = plot_geo(df, lat = ~lat, lon = ~lng) %>%
  add_markers(
    text = ~paste("State: ", state, "<br>City: ", city, "<br>Crime Rate: ", crime_rate, "<br>Population: ", population), 
    size = ~population, 
    color = ~crime_rate,
    colors = colors,
    opacity = 10000,
    marker = list(sizemode = 'area', sizeref = 0.2, line = list(color = 'black', width = 2))) %>%
    colorbar(title = "Crime Rate") %>%
  layout(title = 'Crime Rate Bubble Map for US cities in 2019', geo = list(scope = 'usa'),
         annotations = list(list(x = 0.8, y = 0.55, text = "Washington D.C.", showarrow = TRUE, xanchor = 'left', yanchor = 'bottom',  ax = 30, ay = 30, font = list(size = 12, color = "red")),
                       list(x = 1, y = 0,  text = "Size by population", showarrow = FALSE, xanchor='right', yanchor='auto', xshift=0, yshift=0, font=list(size=12, color="grey"))))
map
