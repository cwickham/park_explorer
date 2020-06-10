library(shiny)
library(tidyverse)

# Import data
annual_visits <- read_rds("data/annual_visits.rds")
monthly_visits <- read_rds("data/monthly_visits.rds")

ui <- fluidPage(
  textInput("selected_park", "Park"),
  textOutput("park_name"),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$park_name <- renderText(input$selected_park)
  
  output$data <- renderTable(head(monthly_visits))
}

shinyApp(ui, server)