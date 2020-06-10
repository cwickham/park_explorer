library(shiny)
library(tidyverse)

# Import data
annual_visits <- read_rds("data/annual_visits.rds")
monthly_visits <- read_rds("data/monthly_visits.rds")

parks <- annual_visits$park_name %>% unique()

ui <- fluidPage(
  selectInput("selected_park", "Park", choices = parks,
    selected = "Crater Lake NP"),
  textOutput("park_name"),
  textOutput("park_summary")
)

server <- function(input, output, session) {
  output$park_name <- renderText(input$selected_park)
  
  output$park_summary <- renderText(input$selected_park)
}

shinyApp(ui, server)