library(tidyverse)
library(igraph)

# Read data files
offense_data_2018 <- read.csv("data/DC-2018/NIBRS_OFFENSE.csv") %>% mutate(year = 2018)
location_2018 <- read.csv("data/DC-2018/NIBRS_LOCATION_TYPE.csv")
offense_2018 <- read.csv("data/DC-2018/NIBRS_OFFENSE_TYPE.csv")
offense_data_2018 <- left_join(offense_data_2018,location_2018, by = "LOCATION_ID")
offense_data_2018 <- left_join(offense_data_2018,offense_2018, by = "OFFENSE_TYPE_ID")

offense_data_2019 <- read.csv("data/DC-2019/NIBRS_OFFENSE.csv") %>% mutate(year = 2019)
location_2019 <- read.csv("data/DC-2019/NIBRS_LOCATION_TYPE.csv")
offense_2019 <- read.csv("data/DC-2019/NIBRS_OFFENSE_TYPE.csv")
offense_data_2019 <- left_join(offense_data_2019,location_2019, by = "LOCATION_ID")
offense_data_2019 <- left_join(offense_data_2019,offense_2019, by = "OFFENSE_TYPE_ID")

offense_data_2020 <- read.csv("data/DC-2020/NIBRS_OFFENSE.csv") %>% mutate(year = 2020)
location_2020 <- read.csv("data/DC-2020/NIBRS_LOCATION_TYPE.csv")
offense_2020 <- read.csv("data/DC-2020/NIBRS_OFFENSE_TYPE.csv")
offense_data_2020 <- left_join(offense_data_2020,location_2020, by = "LOCATION_ID")
offense_data_2020 <- left_join(offense_data_2020,offense_2020, by = "OFFENSE_TYPE_ID")

offense_data_2021 <- read.csv("data/DC-2021/NIBRS_OFFENSE.csv") %>% mutate(year = 2021)
location_2021 <- read.csv("data/DC-2021/NIBRS_LOCATION_TYPE.csv")
offense_2021 <- read.csv("data/DC-2021/NIBRS_OFFENSE_TYPE.csv")
offense_data_2021 <- left_join(offense_data_2021,location_2021, by = "location_id")
offense_data_2021 <- left_join(offense_data_2021,offense_2021, by = "offense_code")

offense_data_2022 <- read.csv("data/DC-2022/NIBRS_OFFENSE.csv") %>% mutate(year = 2022)
location_2022 <- read.csv("data/DC-2022/NIBRS_LOCATION_TYPE.csv")
offense_2022 <- read.csv("data/DC-2022/NIBRS_OFFENSE_TYPE.csv")
offense_data_2022 <- left_join(offense_data_2022,location_2022, by = "location_id")
offense_data_2022 <- left_join(offense_data_2022,offense_2022, by = "offense_code")

# Merge different years data
offense_data_bundle1 = rbind(offense_data_2018,offense_data_2019,offense_data_2020)
offense_data_bundle2 = rbind(offense_data_2021,offense_data_2022)
colnames(offense_data_bundle1) = tolower(colnames(offense_data_bundle1))
offense_data_bundle1 <- offense_data_bundle1 %>% select(-c(offense_type_id, offense_code))
offense_data_bundle2 <- offense_data_bundle2 %>% select(-c(offense_code))
offense_data_total = rbind(offense_data_bundle1,offense_data_bundle2)

# Create adjacency list
duplicated_data <- offense_data_total[offense_data_total$incident_id %in% offense_data_total$incident_id[duplicated(offense_data_total$incident_id)],]
num_incidents <- duplicated_data$incident_id %>% unique()
adjacency_list <- c("source","target") %>% t() %>% as.data.frame()

# Create adjacency matrix
for(i in 1:length(num_incidents)){
  incident_instance <- num_incidents[i]
  incident_df <- duplicated_data %>% filter(incident_id == incident_instance)
  for(g in 1:(nrow(incident_df)-1)){
    if(g == nrow(incident_df)){
      life = 0
    }
    for(f in (g+1):nrow(incident_df)){
      insert <- c(incident_df[g,11],incident_df[f,11])
      adjacency_list <- rbind(adjacency_list, insert)
    }
  }
}
colnames(adjacency_list) <- adjacency_list[1,]
adjacency_list <- adjacency_list[-1,]
adjacency_matrix <- as.matrix(adjacency_list)
adjacency_matrix <- get.adjacency(graph.edgelist(adjacency_matrix)) %>% as.matrix()

# Save it as csv for later use
write.csv(adjacency_matrix, "./data/adjacency_matrix.csv")