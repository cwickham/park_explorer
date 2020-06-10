library(shiny)
library(tidyverse)

# Import data
annual_visits <- read_rds("data/annual_visits.rds")
monthly_visits <- read_rds("data/monthly_visits.rds")

ui <- fluidPage(
  selectInput("selected_park", "Park",
    choices = c("Crater Lake NP", "Acadia NP")),
  textOutput("park_name")
)

server <- function(input, output, session) {
  output$park_name <- renderText(input$selected_park)
}

shinyApp(ui, server)