library(tidyverse)
library(networkD3)

# Read all necessary files
offense_20 = read.csv("./data/DC-2020/NIBRS_OFFENSE.csv") 
offender_20 = read.csv("./data/DC-2020/NIBRS_OFFENDER.csv") 
victim_20 = read.csv("./data/DC-2020/NIBRS_VICTIM.csv")
weapon_20 = read.csv("./data/DC-2020/NIBRS_WEAPON.csv") 
injury_20 = read.csv("./data/DC-2020/NIBRS_VICTIM_INJURY.csv")

# Select offense_id, incident_id, offender_id, victim_id, offense_code, injury_id, weapon_id
offense_20 = offense_20 %>% select(2,3,4)
offender_20 = offender_20 %>% select(2,3)
victim_20 = victim_20 %>% select(2,3)
weapon_20 = weapon_20 %>% select(2,3)
injury_20 = injury_20 %>% select(2,3)

# Read codes files for nodes
offense_code = read.csv("./data/DC-2020/NIBRS_OFFENSE_TYPE.csv")
injury_code = read.csv("./data/DC-2020/NIBRS_INJURY.csv")
weapon_code = read.csv("./data/DC-2020/NIBRS_WEAPON_TYPE.csv")

# Get offense_code, offense_type_id, offense_name
offense_code = offense_code %>% select(1,2,3)
# Change offense_type_id to offense_code
offense_20 = merge(offense_20, offense_code, by = "OFFENSE_TYPE_ID")
offense_20 = offense_20 %>% select(2,3,4)
# Merge by incident_id, offense_id, victim_id
df_20 = merge(merge(merge(merge(offense_20, offender_20, by = "INCIDENT_ID"), victim_20, by = "INCIDENT_ID"), injury_20, by = "VICTIM_ID"), weapon_20, by = "OFFENSE_ID")
# Remove incident_id, offense_id, victim_id, offender_id
df_20 = df_20 %>% select(-1,-2,-3,-5)

# # Make column names to lower case
colnames(df_20) = tolower(colnames(df_20))

# Paste character to make ids unique
df_20$injury_id = paste0("i", df_20$injury_id)
df_20$weapon_id = paste0("w", df_20$weapon_id)

# # Count the unique combinations of offense types and weapon types and subset if there are more than 100 cases
first_link = df_20 %>%
    group_by(offense_code, weapon_id) %>%
    summarise(value = n(), .groups = "drop") %>%
    arrange(desc(value)) %>%
    rename(source = offense_code, target = weapon_id) %>%
    filter(value > 100)
# # Count the unique combinations of weapon types and injury types and subset if there are more than 100 cases
second_link = df_20 %>%
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
net_with_title = prependContent(net, tags$b(HTML('Injuries and weapon type by offense type in 2020')))
net_with_title