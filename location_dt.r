library(tidyverse)

offense_22 = read.csv("./data/DC-2022/NIBRS_OFFENSE.csv") 
offense_21 = read.csv("./data/DC-2021/NIBRS_OFFENSE.csv") 
offense_20 = read.csv("./data/DC-2020/NIBRS_OFFENSE.csv") 
offense_19 = read.csv("./data/DC-2019/NIBRS_OFFENSE.csv") 
offense_18 = read.csv("./data/DC-2018/NIBRS_OFFENSE.csv") 
location_code = read.csv("./data/DC-2022/NIBRS_LOCATION_TYPE.csv")

offense_22 = merge(offense_22, location_code, by = "location_id")
offense_21 = merge(offense_21, location_code, by = "location_id")
offense_20 = merge(offense_20, location_code, by.x = "LOCATION_ID", by.y = "location_id")
offense_19 = merge(offense_19, location_code, by.x = "LOCATION_ID", by.y = "location_id")
offense_18 = merge(offense_18, location_code, by.x = "LOCATION_ID", by.y = "location_id")

location_22_count = as.data.frame(table(offense_22$location_name))
location_21_count = as.data.frame(table(offense_21$location_name))
location_20_count = as.data.frame(table(offense_20$location_name))
location_19_count = as.data.frame(table(offense_19$location_name))
location_18_count = as.data.frame(table(offense_18$location_name))

location_df = merge(merge(merge(merge(location_18_count, location_19_count, by = "Var1", all = TRUE), location_20_count, by = "Var1", all = TRUE), location_21_count, by = "Var1", all = TRUE), location_22_count, by = "Var1", all = TRUE)
colnames(location_df) = c("Location Type", "2018", "2019", "2020", "2021", "2022")

datatable(data = location_df,
          caption = "Table",
          filter = "top")