library(tidyverse)
library(DT)

# Read data files
offense_22 = read.csv("./data/DC-2022/NIBRS_OFFENSE.csv") 
offense_21 = read.csv("./data/DC-2021/NIBRS_OFFENSE.csv") 
offense_20 = read.csv("./data/DC-2020/NIBRS_OFFENSE.csv") 
offense_19 = read.csv("./data/DC-2019/NIBRS_OFFENSE.csv") 
offense_18 = read.csv("./data/DC-2018/NIBRS_OFFENSE.csv") 
location_code = read.csv("./data/DC-2022/NIBRS_LOCATION_TYPE.csv")

# Merge with code files for corresponding location names
offense_22 = merge(offense_22, location_code, by = "location_id")
offense_21 = merge(offense_21, location_code, by = "location_id")
offense_20 = merge(offense_20, location_code, by.x = "LOCATION_ID", by.y = "location_id")
offense_19 = merge(offense_19, location_code, by.x = "LOCATION_ID", by.y = "location_id")
offense_18 = merge(offense_18, location_code, by.x = "LOCATION_ID", by.y = "location_id")

# Calculate the percentage based on the count
location_22_count = as.data.frame(round(table(offense_22$location_name)/nrow(offense_22)*100,2))
location_21_count = as.data.frame(round(table(offense_21$location_name)/nrow(offense_21)*100,2))
location_20_count = as.data.frame(round(table(offense_20$location_name)/nrow(offense_20)*100,2))
location_19_count = as.data.frame(round(table(offense_19$location_name)/nrow(offense_19)*100,2))
location_18_count = as.data.frame(round(table(offense_18$location_name)/nrow(offense_18)*100,2))

# Merge all years
location_df = merge(merge(merge(merge(location_18_count, location_19_count, by = "Var1", all = TRUE), location_20_count, by = "Var1", all = TRUE), location_21_count, by = "Var1", all = TRUE), location_22_count, by = "Var1", all = TRUE)
colnames(location_df) = c("Location Type", "2018", "2019", "2020", "2021", "2022")

# Create datatable
datatable(data = location_df, caption = "Table", filter = "top")