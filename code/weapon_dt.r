library(tidyverse)
library(DT)

# Read data files
weapon_22 = read.csv("./data/DC-2022/NIBRS_WEAPON.csv") 
weapon_21 = read.csv("./data/DC-2021/NIBRS_WEAPON.csv") 
weapon_20 = read.csv("./data/DC-2020/NIBRS_WEAPON.csv") 
weapon_19 = read.csv("./data/DC-2019/NIBRS_WEAPON.csv") 
weapon_18 = read.csv("./data/DC-2018/NIBRS_WEAPON.csv") 
weapon_code = read.csv("./data/DC-2022/NIBRS_WEAPON_TYPE.csv")

# Merge with code files for corresponding weapon names
weapon_22 = merge(weapon_22, weapon_code, by = "weapon_id")
weapon_21 = merge(weapon_21, weapon_code, by = "weapon_id")
weapon_20 = merge(weapon_20, weapon_code, by.x = "WEAPON_ID", by.y = "weapon_id")
weapon_19 = merge(weapon_19, weapon_code, by.x = "WEAPON_ID", by.y = "weapon_id")
weapon_18 = merge(weapon_18, weapon_code, by.x = "WEAPON_ID", by.y = "weapon_id")

# Calculate the percentage based on the count
weapon_22_count = as.data.frame(round(table(weapon_22$weapon_name)/nrow(weapon_22)*100,2))
weapon_21_count = as.data.frame(round(table(weapon_21$weapon_name)/nrow(weapon_21)*100,2))
weapon_20_count = as.data.frame(round(table(weapon_20$weapon_name)/nrow(weapon_20)*100,2))
weapon_19_count = as.data.frame(round(table(weapon_19$weapon_name)/nrow(weapon_19)*100,2))
weapon_18_count = as.data.frame(round(table(weapon_18$weapon_name)/nrow(weapon_18)*100,2))

# Merge all years
weapon_df = merge(merge(merge(merge(weapon_18_count, weapon_19_count, by = "Var1", all = TRUE), weapon_20_count, by = "Var1", all = TRUE), weapon_21_count, by = "Var1", all = TRUE), weapon_22_count, by = "Var1", all = TRUE)
colnames(weapon_df) = c("Weapon Type", "2018", "2019", "2020", "2021", "2022")

# Create datatable
datatable(data = weapon_df, caption = "Table", filter = "top")