
library(tidyverse)
library(plotly)
library(heatmaply)

## 2018
offense_data_2018 <- read.csv("data/DC-2018/NIBRS_OFFENSE.csv") %>% mutate(year = 2018)
offense_2018 <- read.csv("data/DC-2018/NIBRS_OFFENSE_TYPE.csv")
victim_data_2018 <- read.csv("data/DC-2018/NIBRS_VICTIM.csv") %>% mutate(year = 2018)
relation_2018 <- read.csv("data/DC-2018/NIBRS_VICTIM_OFFENDER_REL.csv")
relationship_2018 <- read.csv("data/DC-2018/NIBRS_RELATIONSHIP.csv")

offense_data_2018 <- left_join(offense_data_2018,offense_2018, by = "OFFENSE_TYPE_ID")
relation_2018 <- left_join(relation_2018,relationship_2018, by = "RELATIONSHIP_ID")
victim_data_2018 <- right_join(victim_data_2018,relation_2018, by = "VICTIM_ID")
total_data_2018 <- left_join(victim_data_2018,offense_data_2018, by = c("INCIDENT_ID","year"))
total_data_2018 <- total_data_2018 %>% select(c(RELATIONSHIP_NAME,OFFENSE_CATEGORY_NAME, year))

## 2019
offense_data_2019 <- read.csv("data/DC-2019/NIBRS_OFFENSE.csv") %>% mutate(year = 2019)
offense_2019 <- read.csv("data/DC-2019/NIBRS_OFFENSE_TYPE.csv")
victim_data_2019 <- read.csv("data/DC-2019/NIBRS_VICTIM.csv") %>% mutate(year = 2019)
relation_2019 <- read.csv("data/DC-2019/NIBRS_VICTIM_OFFENDER_REL.csv")
relationship_2019 <- read.csv("data/DC-2019/NIBRS_RELATIONSHIP.csv")

offense_data_2019 <- left_join(offense_data_2019,offense_2019, by = "OFFENSE_TYPE_ID")
relation_2019 <- left_join(relation_2019,relationship_2019, by = "RELATIONSHIP_ID")
victim_data_2019 <- right_join(victim_data_2019,relation_2019, by = "VICTIM_ID")
total_data_2019 <- left_join(victim_data_2019,offense_data_2019, c("INCIDENT_ID","year"))
total_data_2019 <- total_data_2019 %>% select(c(RELATIONSHIP_NAME,OFFENSE_CATEGORY_NAME, year))

## 2020
offense_data_2020 <- read.csv("data/DC-2020/NIBRS_OFFENSE.csv") %>% mutate(year = 2020)
offense_2020 <- read.csv("data/DC-2020/NIBRS_OFFENSE_TYPE.csv")
victim_data_2020 <- read.csv("data/DC-2020/NIBRS_VICTIM.csv") %>% mutate(year = 2020)
relation_2020 <- read.csv("data/DC-2020/NIBRS_VICTIM_OFFENDER_REL.csv")
relationship_2020 <- read.csv("data/DC-2020/NIBRS_RELATIONSHIP.csv")

offense_data_2020 <- left_join(offense_data_2020,offense_2020, by = "OFFENSE_TYPE_ID")
relation_2020 <- left_join(relation_2020,relationship_2020, by = "RELATIONSHIP_ID")
victim_data_2020 <- right_join(victim_data_2020,relation_2020, by = "VICTIM_ID")
total_data_2020 <- left_join(victim_data_2020,offense_data_2020, by = c("INCIDENT_ID","year"))
total_data_2020 <- total_data_2020 %>% select(c(RELATIONSHIP_NAME,OFFENSE_CATEGORY_NAME, year))

## 2021
offense_data_2021 <- read.csv("data/DC-2021/NIBRS_OFFENSE.csv") %>% mutate(year = 2021)
offense_2021 <- read.csv("data/DC-2021/NIBRS_OFFENSE_TYPE.csv")
victim_data_2021 <- read.csv("data/DC-2021/NIBRS_VICTIM.csv") %>% mutate(year = 2021)
relation_2021 <- read.csv("data/DC-2021/NIBRS_VICTIM_OFFENDER_REL.csv")
relationship_2021 <- read.csv("data/DC-2021/NIBRS_RELATIONSHIP.csv")

offense_data_2021 <- left_join(offense_data_2021,offense_2021, by = "offense_code")
relation_2021 <- left_join(relation_2021,relationship_2021, by = "relationship_id")
victim_data_2021 <- right_join(victim_data_2021,relation_2021, by = "victim_id")
total_data_2021 <- left_join(victim_data_2021,offense_data_2021, by = c("incident_id","year"))
total_data_2021 <- total_data_2021 %>% select(c(relationship_name,offense_category_name, year))

## 2022
offense_data_2022 <- read.csv("data/DC-2022/NIBRS_OFFENSE.csv") %>% mutate(year = 2022)
offense_2022 <- read.csv("data/DC-2022/NIBRS_OFFENSE_TYPE.csv")
victim_data_2022 <- read.csv("data/DC-2022/NIBRS_VICTIM.csv") %>% mutate(year = 2022)
relation_2022 <- read.csv("data/DC-2022/NIBRS_VICTIM_OFFENDER_REL.csv")
relationship_2022 <- read.csv("data/DC-2022/NIBRS_RELATIONSHIP.csv")

offense_data_2022 <- left_join(offense_data_2022,offense_2022, by = "offense_code")
relation_2022 <- left_join(relation_2022,relationship_2022, by = "relationship_id")
victim_data_2022 <- right_join(victim_data_2022,relation_2022, by = "victim_id")
total_data_2022 <- left_join(victim_data_2022,offense_data_2022, by = c("incident_id","year"))
total_data_2022 <- total_data_2022 %>% select(c(relationship_name,offense_category_name, year))

## adjusting colnames for difference
colnames(total_data_2021) <- c("RELATIONSHIP_NAME","OFFENSE_CATEGORY_NAME", "year")
colnames(total_data_2022) <- c("RELATIONSHIP_NAME","OFFENSE_CATEGORY_NAME", "year")

## groups
total_data_relation <- rbind(total_data_2018, total_data_2019, total_data_2020, total_data_2021, total_data_2022)

## relationships store for next chunk
relationships <- total_data_relation$RELATIONSHIP_NAME %>% factor() %>% levels()

## Splitting the relationships type into indicies and then filtering by them
family_relationships_index <- c(6,14,15,16,19,21,22)
partner_relationships_index <- c(1,5,7,8,11,12,23,24,25,26)
acquaintance_relationships_index <- c(3,4,9,10,13,17,18,20)
stranger_relationships_index <- c(27)
other_relationships_index <- c(2)

family_relationships <- relationships[family_relationships_index]
partner_relationships <- relationships[partner_relationships_index]
acquaintance_relationships <- relationships[acquaintance_relationships_index]
stranger_relationships <- relationships[stranger_relationships_index]
other_relationships <- relationships[other_relationships_index]

## Function for new column of values
relation_checker <- function(value){
  if(value %in% family_relationships){
    val <- "Family"
  } else if(value %in% partner_relationships){
    val <- "Partner/Partners Family"
  } else if(value %in% acquaintance_relationships){
    val <- "Acquaintance"
  } else if(value %in% stranger_relationships){
    val <- "Stranger"
  } else{
    val <- "Other"
  }
}

## vectorizing the function and adding the colum
relation_checker <- Vectorize(relation_checker)

total_data_relation <- total_data_relation %>% mutate(Relation_group = relation_checker(RELATIONSHIP_NAME)) %>% filter(Relation_group != "Other")
#total_data_relation$Relation_group %>% table()

## Making matrix for Viz
mat <- total_data_relation %>% group_by(Relation_group,OFFENSE_CATEGORY_NAME) %>% tally() %>%
  spread(Relation_group,n) %>% as.data.frame()
mat[is.na(mat)] <- 0
rownames(mat) <- mat$OFFENSE_CATEGORY_NAME
mat <- mat %>% select(-OFFENSE_CATEGORY_NAME)

# Color palette
colors = c("#F1FAEE", "#A8DADC", "#457B9D", "#1D3557")
# colors = c("#ccdbdc","#edf8b1", "#7fcdbb", "#2c7fb8")

## Heatmap code
ptotal <- heatmaply(mat,
                    label_names = c("Crime Group", "Relation", "Relation Prevelance"),
                    colors = colors,
                    # width  = 800, 
                    height = 600,
                    dendrogram = FALSE,
                    # limits = c(0,10000),
                    scale = "row",
                    branches_lwd = 0.1,
                    # hide_colorbar = TRUE,
                    grid_color = "white",
                    grid_width = 0.00001,
                    dend_hoverinfo = FALSE,
                    main = "Heatmap of offense category by relationship between victim and offender")
ptotal