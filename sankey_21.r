library(tidyverse)
library(networkD3)

# Read all necessary files
offense_21 = read.csv("./data/DC-2021/NIBRS_OFFENSE.csv") 
offender_21 = read.csv("./data/DC-2021/NIBRS_OFFENDER.csv") 
victim_21 = read.csv("./data/DC-2021/NIBRS_VICTIM.csv")
weapon_21 = read.csv("./data/DC-2021/NIBRS_WEAPON.csv") 
injury_21 = read.csv("./data/DC-2021/NIBRS_VICTIM_INJURY.csv")

# Select offense_id, incident_id, offender_id, victim_id, offense_code, injury_id, weapon_id
offense_21 = offense_21 %>% select(2,3,4)
offender_21 = offender_21 %>% select(2,3)
victim_21 = victim_21 %>% select(2,3)
weapon_21 = weapon_21 %>% select(2,3)
injury_21 = injury_21 %>% select(2,3)

# Merge by incident_id, offense_id, victim_id
df_21 = merge(merge(merge(merge(offense_21, offender_21, by = "incident_id"), victim_21, by = "incident_id"), injury_21, by = "victim_id"), weapon_21, by = "offense_id")
# Remove incident_id, offense_id, victim_id, offender_id
df_21 = df_21 %>% select(-1,-2,-3,-5)

# Paste character to make ids unique
df_21$injury_id = paste0("i", df_21$injury_id)
df_21$weapon_id = paste0("w", df_21$weapon_id)

# Count the unique combinations of offense types and weapon types and subset if there are more than 100 cases
first_link = df_21 %>%
    group_by(offense_code, weapon_id) %>%
    summarise(value = n(), .groups = "drop") %>%
    arrange(desc(value)) %>%
    rename(source = offense_code, target = weapon_id) %>%
    filter(value > 100)
# Count the unique combinations of weapon types and injury types and subset if there are more than 100 cases
second_link = df_21 %>%
    group_by(weapon_id, injury_id) %>%
    summarise(value = n(), .groups = "drop") %>%
    arrange(desc(value)) %>%
    rename(source = weapon_id, target = injury_id) %>%
    filter(value > 100)
# Combine those two links
links.df = as.data.frame(rbind(first_link,second_link))

# Read codes files for nodes
offense_code = read.csv("./data/DC-2021/NIBRS_OFFENSE_TYPE.csv")
injury_code = read.csv("./data/DC-2021/NIBRS_INJURY.csv")
weapon_code = read.csv("./data/DC-2021/NIBRS_WEAPON_TYPE.csv")

# Get the codes and names
offense_code = offense_code %>% 
    select(1,2) %>%
    rename(name = offense_code, label = offense_name)
injury_code = injury_code %>% 
    select(1,3) %>%
    rename(name = injury_id, label = injury_name)
weapon_code = weapon_code %>% 
    select(1,3) %>%
    rename(name = weapon_id, label = weapon_name)

# Make codes unique
injury_code$name = paste0("i", injury_code$name)
weapon_code$name = paste0("w", weapon_code$name)
# Combine all the nodes
nodes.df = rbind(offense_code, injury_code, weapon_code)
# Subset only nodes from the links
nodes.df = nodes.df %>% filter(name %in% c(unique(first_link$source),unique(first_link$target),unique(second_link$target)))

# Create source_id and target_id for a sankey diagram
links.df$source_id = match(links.df$source, nodes.df$name) - 1 
links.df$target_id = match(links.df$target, nodes.df$name) - 1 

# Create a sankey diagram
sankeyNetwork(Links = links.df,     
              Nodes = nodes.df,     
              Source = 'source_id', 
              Target = 'target_id', 
              Value = 'value',     
              NodeID = 'label',      
              fontSize = 16,        
              iterations = 0)