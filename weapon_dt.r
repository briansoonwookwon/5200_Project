library(tidyverse)
library(DT)

weapon_22 = read.csv("./data/DC-2022/NIBRS_WEAPON.csv") 
weapon_21 = read.csv("./data/DC-2021/NIBRS_WEAPON.csv") 
weapon_20 = read.csv("./data/DC-2020/NIBRS_WEAPON.csv") 
weapon_19 = read.csv("./data/DC-2019/NIBRS_WEAPON.csv") 
weapon_18 = read.csv("./data/DC-2018/NIBRS_WEAPON.csv") 
weapon_code = read.csv("./data/DC-2022/NIBRS_WEAPON_TYPE.csv")

weapon_22 = merge(weapon_22, weapon_code, by = "weapon_id")
weapon_21 = merge(weapon_21, weapon_code, by = "weapon_id")
weapon_20 = merge(weapon_20, weapon_code, by.x = "WEAPON_ID", by.y = "weapon_id")
weapon_19 = merge(weapon_19, weapon_code, by.x = "WEAPON_ID", by.y = "weapon_id")
weapon_18 = merge(weapon_18, weapon_code, by.x = "WEAPON_ID", by.y = "weapon_id")

weapon_22_count = as.data.frame(table(weapon_22$weapon_name))
weapon_21_count = as.data.frame(table(weapon_21$weapon_name))
weapon_20_count = as.data.frame(table(weapon_20$weapon_name))
weapon_19_count = as.data.frame(table(weapon_19$weapon_name))
weapon_18_count = as.data.frame(table(weapon_18$weapon_name))

weapon_df = merge(merge(merge(merge(weapon_18_count, weapon_19_count, by = "Var1", all = TRUE), weapon_20_count, by = "Var1", all = TRUE), weapon_21_count, by = "Var1", all = TRUE), weapon_22_count, by = "Var1", all = TRUE)
colnames(weapon_df) = c("Weapon Type", "2018", "2019", "2020", "2021", "2022")

datatable(data = weapon_df,
          caption = "Table",
          filter = "top")