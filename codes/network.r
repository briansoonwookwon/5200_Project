library(tidyverse)
library(plotly)
library(igraph)
library(GGally)
library(network)

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

offense_data_bundle1 = rbind(offense_data_2018,offense_data_2019,offense_data_2020)
offense_data_bundle2 = rbind(offense_data_2021,offense_data_2022)

colnames(offense_data_bundle1) = tolower(colnames(offense_data_bundle1))

offense_data_bundle1 <- offense_data_bundle1 %>% select(-c(offense_type_id, offense_code))
offense_data_bundle2 <- offense_data_bundle2 %>% select(-c(offense_code))

offense_data_total = rbind(offense_data_bundle1,offense_data_bundle2)

offense_data_total = offense_data_total %>% filter(offense_name %in% names(head(sort(table(offense_data_total$offense_name), decreasing = TRUE), 15)))

duplicated_data <- offense_data_total[offense_data_total$incident_id %in% offense_data_total$incident_id[duplicated(offense_data_total$incident_id)],]

num_incidents <- duplicated_data$incident_id %>% unique()

adjacency_list <- c("source","target") %>% t() %>% as.data.frame()

adjacency_list <- c("source","target") %>% t() %>% as.data.frame()

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

crime_names <- rownames(adjacency_matrix) %>% as.data.frame()

offense_freq <- offense_data_total$offense_name %>% table() %>% as.data.frame()
offense_freq$Freq <- (offense_freq$Freq-mean(offense_freq$Freq))/ sd(offense_freq$Freq)

crime_stats <- left_join(crime_names, offense_freq)

net = network(adjacency_matrix, directed = FALSE)

net %v% "Crime" = crime_stats$.
net %v% "Freq" = crime_stats$Freq
net %v% "Label" = crime_stats$.

net <- set.edge.value(net, "Weight", adjacency_matrix)

# Color palette
colors = c("#E63946", "#F1FAEE", "#A8DADC", "#457B9D", "#1D3557")
color_palette <- colorRampPalette(colors)(15)

p <- ggnet2(net,
            mode = "circle",
            node.size = "Freq",
            node.color = "Crime",
            edge.size = 0.2,
            edge.color = "grey",
            edge.alpha = .5) +
  theme(legend.position = "none") +
  scale_colour_manual(values = color_palette) + 
  labs(title = "Relationships between offenses within incidents")

ggplotly(p)