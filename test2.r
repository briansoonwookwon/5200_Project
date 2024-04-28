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

generate_data_table <- function(data, id, initial_show = FALSE) {
  div(
    id = id,
    class = "data-table",
    datatable(
      data,
      options = list(pageLength = 5),
      caption = "Data Table"
    ),
    style = ifelse(initial_show, "display: block;", "display: none;")
  )
}

generate_all_tables <- function(data_tables) {
  tagList(
    generate_data_table(data_tables$offense, "offense", initial_show = TRUE),
    generate_data_table(data_tables$weapon, "weapon"),
    generate_data_table(data_tables$injury, "injury"),
    generate_data_table(data_tables$location, "location")
  )
}

generate_buttons <- function() {
  btn_offense <- tags$button("Offense", class = "btn btn-primary", onclick = "showDataTable('offense')")
  btn_weapon <- tags$button("Weapon", class = "btn btn-primary", onclick = "showDataTable('weapon')")
  btn_injury <- tags$button("Injury", class = "btn btn-primary", onclick = "showDataTable('injury')")
  btn_location <- tags$button("Location", class = "btn btn-primary", onclick = "showDataTable('location')")
  
  tags$div(btn_offense, btn_weapon, btn_injury, btn_location)
}


html_output <- tagList(
  generate_buttons(),
  generate_all_tables(data_tables),
  tags$script(HTML("
    function showDataTable(table) {
      $('.data-table').hide();
      $('#' + table).show();
    }
    
    $(document).ready(function() {
      showDataTable('offense'); // Set initial table to be shown
    });
  "))
)

html_output
