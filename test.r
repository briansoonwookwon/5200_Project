library(htmlwidgets)
library(htmltools)
library(DT)

# Sample data tables (replace with your actual data)
data_tables <- list(
  offense = data.frame(
    Offense_Type = c("Theft", "Assault", "Vandalism"),
    Count = c(100, 50, 30)
  ),
  weapon = data.frame(
    Weapon_Type = c("Knife", "Gun", "Club"),
    Count = c(20, 30, 10)
  ),
  injury = data.frame(
    Injury_Type = c("Minor", "Serious", "Fatal"),
    Count = c(40, 30, 20)
  ),
  location = data.frame(
    Location_Type = c("Street", "Home", "Park"),
    Count = c(60, 70, 40)
  )
)

# Function to generate HTML code for the data table
generate_data_table1 <- function(data, id) {
  div(
    id = id,
    class = "data-table",
    datatable(
      data,
      options = list(pageLength = 5),
      caption = "Data Table"
    ),
    style = ifelse(id == "offense", "display: block;", "display: none;")
  )
}

generate_data_table2 <- function(data, id) {
  div(
    id = id,
    class = "data-table",
    datatable(
      data,
      options = list(pageLength = 5),
      caption = "Data Table"
    ),
    style = ifelse(id == "weapon", "display: block;", "display: none;")
  )
}

generate_data_table3 <- function(data, id) {
  div(
    id = id,
    class = "data-table",
    datatable(
      data,
      options = list(pageLength = 5),
      caption = "Data Table"
    ),
    style = ifelse(id == "injury", "display: block;", "display: none;")
  )
}

generate_data_table4 <- function(data, id) {
  div(
    id = id,
    class = "data-table",
    datatable(
      data,
      options = list(pageLength = 5),
      caption = "Data Table"
    ),
    style = ifelse(id == "location", "display: block;", "display: none;")
  )
}

# Function to create buttons
generate_buttons <- function() {
  btn_offense <- tags$button("Offense", class = "btn btn-primary", onclick = "showDataTable('offense')")
  btn_weapon <- tags$button("Weapon", class = "btn btn-primary", onclick = "showDataTable('weapon')")
  btn_injury <- tags$button("Injury", class = "btn btn-primary", onclick = "showDataTable('injury')")
  btn_location <- tags$button("Location", class = "btn btn-primary", onclick = "showDataTable('location')")
  
  tags$div(btn_offense, btn_weapon, btn_injury, btn_location)
}

# Combine HTML elements
html_output <- tagList(
  generate_buttons(),
  generate_data_table1(data_tables$offense, "offense"),
  generate_data_table2(data_tables$weapon, "weapon"),
  generate_data_table3(data_tables$injury, "injury"),
  generate_data_table4(data_tables$location, "location"),
  tags$script(HTML("
    function showDataTable(table) {
      $('.data-table').hide();
      $('#' + table).show();
    }
  "))
)

html_output