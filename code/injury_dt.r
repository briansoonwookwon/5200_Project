library(tidyverse)
library(DT)

# Read data files
injury_22 = read.csv("./data/DC-2022/NIBRS_VICTIM_INJURY.csv")
injury_21 = read.csv("./data/DC-2021/NIBRS_VICTIM_INJURY.csv")
injury_20 = read.csv("./data/DC-2020/NIBRS_VICTIM_INJURY.csv")
injury_19 = read.csv("./data/DC-2019/NIBRS_VICTIM_INJURY.csv")
injury_18 = read.csv("./data/DC-2018/NIBRS_VICTIM_INJURY.csv")
injury_code = read.csv("./data/DC-2022/NIBRS_INJURY.csv")

# Merge with code files for corresponding injury names
injury_22 = merge(injury_22, injury_code, by = "injury_id")
injury_21 = merge(injury_21, injury_code, by = "injury_id")
injury_20 = merge(injury_20, injury_code, by.x = "INJURY_ID", by.y = "injury_id")
injury_19 = merge(injury_19, injury_code, by.x = "INJURY_ID", by.y = "injury_id")
injury_18 = merge(injury_18, injury_code, by.x = "INJURY_ID", by.y = "injury_id")

# Calculate the percentage based on the count
injury_22_count = as.data.frame(round(table(injury_22$injury_name)/nrow(injury_22)*100,2))
injury_21_count = as.data.frame(round(table(injury_21$injury_name)/nrow(injury_21)*100,2))
injury_20_count = as.data.frame(round(table(injury_20$injury_name)/nrow(injury_20)*100,2))
injury_19_count = as.data.frame(round(table(injury_19$injury_name)/nrow(injury_19)*100,2))
injury_18_count = as.data.frame(round(table(injury_18$injury_name)/nrow(injury_18)*100,2))

# Merge all years
injury_df = merge(merge(merge(merge(injury_18_count, injury_19_count, by = "Var1", all = TRUE), injury_20_count, by = "Var1", all = TRUE), injury_21_count, by = "Var1", all = TRUE), injury_22_count, by = "Var1", all = TRUE)
colnames(injury_df) = c("Injury Type", "2018", "2019", "2020", "2021", "2022")

# Create datatable
datatable(data = injury_df, caption = "Table", filter = "top")