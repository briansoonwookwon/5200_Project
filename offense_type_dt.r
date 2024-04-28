library(tidyverse)
library(DT)

offense_22 = read.csv("./data/DC-2022/NIBRS_OFFENSE.csv") 
offense_21 = read.csv("./data/DC-2021/NIBRS_OFFENSE.csv") 
offense_20 = read.csv("./data/DC-2020/NIBRS_OFFENSE.csv") 
offense_19 = read.csv("./data/DC-2019/NIBRS_OFFENSE.csv") 
offense_18 = read.csv("./data/DC-2018/NIBRS_OFFENSE.csv") 

offense_code1 = read.csv("./data/DC-2022/NIBRS_OFFENSE_TYPE.csv")
offense_code2 = read.csv("./data/DC-2018/NIBRS_OFFENSE_TYPE.csv")

offense_22 = merge(offense_22, offense_code1, by = "offense_code")
offense_21 = merge(offense_21, offense_code1, by = "offense_code")
offense_20 = merge(offense_20, offense_code2, by = "OFFENSE_TYPE_ID")
offense_19 = merge(offense_19, offense_code2, by = "OFFENSE_TYPE_ID")
offense_18 = merge(offense_18, offense_code2, by = "OFFENSE_TYPE_ID")

offense_22_count = as.data.frame(table(offense_22$offense_name))
offense_21_count = as.data.frame(table(offense_21$offense_name))
offense_20_count = as.data.frame(table(offense_20$OFFENSE_NAME))
offense_19_count = as.data.frame(table(offense_19$OFFENSE_NAME))
offense_18_count = as.data.frame(table(offense_18$OFFENSE_NAME))

offense_df = merge(merge(merge(merge(offense_18_count, offense_19_count, by = "Var1", all = TRUE), offense_20_count, by = "Var1", all = TRUE), offense_21_count, by = "Var1", all = TRUE), offense_22_count, by = "Var1", all = TRUE)
colnames(offense_df) = c("Offense Type", "2018", "2019", "2020", "2021", "2022")

datatable(data = offense_df,
          caption = "Table",
          filter = "top")