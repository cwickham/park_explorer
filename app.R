library(shiny)
library(tidyverse)

source("helpers.R")

# Import data
annual_visits <- read_rds("data/annual_visits.rds")
monthly_visits <- read_rds("data/monthly_visits.rds")

parks <- annual_visits$park_name %>% unique()

ui <- fluidPage(
  fluidRow(
    column(4, 
      selectInput("selected_park", "Park", choices = parks,
        selected = "Crater Lake NP")
    ),
    column(4,
      numericInput("selected_year", "Year", 
        value = 2019,
        min = min(annual_visits$year), 
        max = max(annual_visits$year),
        step = 1)
    )
  ),
  textOutput("park_name"),
  fluidRow(
    column(8,
      plotOutput("annual_plot")
    ),
    column(4,
      textOutput("park_summary")
    )
  ),
  fluidRow(
    column(8, 
      plotOutput("monthly_plot"),
      checkboxInput("display_average", "Display monthly average?")
    ),
    column(4, 
      tableOutput("monthly_table")
    )
  )
)

server <- function(input, output, session) {
  output$park_name <- renderText(input$selected_park)

  # Subset data to selected park --------------------------------------------
  
  annual_data <- reactive({
    annual_visits %>% 
      filter(park_name == input$selected_park)
  })
  
  monthly_data <- reactive({
    monthly_visits %>% 
      filter(park_name == input$selected_park) 
  })
  
  # Outputs that use a single year ------------------------------------------

  output$park_summary <- renderText({
    annual_data() %>% 
      filter(year == 2019) %>% 
      summarize_park()
  })
  
  output$monthly_table <- renderTable(digits = 0, {
    monthly_data() %>% 
      filter(year == 2019) %>% 
      select(month_name, recreation_visits)
  })
  

  # Outputs that use all years ----------------------------------------------

  output$annual_plot <- renderPlot({
    annual_data() %>% 
      plot_annual()
  })
  
  output$monthly_plot <- renderPlot({
    monthly_data() %>% 
      plot_monthly(display_average = input$display_average) 
  })
  
}

shinyApp(ui, server)