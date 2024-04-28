library(tidyverse)
library(networkD3)

# Read all necessary files
offense_19 = read.csv("./data/DC-2019/NIBRS_OFFENSE.csv") 
offender_19 = read.csv("./data/DC-2019/NIBRS_OFFENDER.csv") 
victim_19 = read.csv("./data/DC-2019/NIBRS_VICTIM.csv")
weapon_19 = read.csv("./data/DC-2019/NIBRS_WEAPON.csv") 
injury_19 = read.csv("./data/DC-2019/NIBRS_VICTIM_INJURY.csv")

# Select offense_id, incident_id, offender_id, victim_id, offense_code, injury_id, weapon_id
offense_19 = offense_19 %>% select(2,3,4)
offender_19 = offender_19 %>% select(2,3)
victim_19 = victim_19 %>% select(2,3)
weapon_19 = weapon_19 %>% select(2,3)
injury_19 = injury_19 %>% select(2,3)

# Read codes files for nodes
offense_code = read.csv("./data/DC-2019/NIBRS_OFFENSE_TYPE.csv")
injury_code = read.csv("./data/DC-2019/NIBRS_INJURY.csv")
weapon_code = read.csv("./data/DC-2019/NIBRS_WEAPON_TYPE.csv")

# Get offense_code, offense_type_id, offense_name
offense_code = offense_code %>% select(1,2,3)
# Change offense_type_id to offense_code
offense_19 = merge(offense_19, offense_code, by = "OFFENSE_TYPE_ID")
offense_19 = offense_19 %>% select(2,3,4)
# Merge by incident_id, offense_id, victim_id
df_19 = merge(merge(merge(merge(offense_19, offender_19, by = "INCIDENT_ID"), victim_19, by = "INCIDENT_ID"), injury_19, by = "VICTIM_ID"), weapon_19, by = "OFFENSE_ID")
# Remove incident_id, offense_id, victim_id, offender_id
df_19 = df_19 %>% select(-1,-2,-3,-5)

# # Make column names to lower case
colnames(df_19) = tolower(colnames(df_19))

# Paste character to make ids unique
df_19$injury_id = paste0("i", df_19$injury_id)
df_19$weapon_id = paste0("w", df_19$weapon_id)

# # Count the unique combinations of offense types and weapon types and subset if there are more than 100 cases
first_link = df_19 %>%
    group_by(offense_code, weapon_id) %>%
    summarise(value = n(), .groups = "drop") %>%
    arrange(desc(value)) %>%
    rename(source = offense_code, target = weapon_id) %>%
    filter(value > 100)
# # Count the unique combinations of weapon types and injury types and subset if there are more than 100 cases
second_link = df_19 %>%
    group_by(weapon_id, injury_id) %>%
    summarise(value = n(), .groups = "drop") %>%
    arrange(desc(value)) %>%
    rename(source = weapon_id, target = injury_id) %>%
    filter(value > 100)
# # Combine those two links
links.df = as.data.frame(rbind(first_link,second_link))

# Get the codes and names
offense_code = offense_code %>%
    select(2,3) %>%
    rename(name = OFFENSE_CODE, label = OFFENSE_NAME)
injury_code = injury_code %>% 
    select(1,3) %>%
    rename(name = INJURY_ID, label = INJURY_NAME)
weapon_code = weapon_code %>% 
    select(1,3) %>%
    rename(name = WEAPON_ID, label = WEAPON_NAME)

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
net = sankeyNetwork(Links = links.df,     
              Nodes = nodes.df,     
              Source = 'source_id', 
              Target = 'target_id', 
              Value = 'value',     
              NodeID = 'label',      
              fontSize = 16,        
              iterations = 0)

# Add a title
net_with_title = prependContent(net, tags$b(HTML('Injuries and weapon type by offense type in 2019')))
net_with_title