library(shiny)
library(shinythemes)
library(tidyverse)

source("helpers.R")

# Import data
annual_visits <- read_rds("data/annual_visits.rds")
monthly_visits <- read_rds("data/monthly_visits.rds")

parks <- annual_visits$park_name %>% unique()

ui <- fluidPage(theme = shinytheme("sandstone"),
  titlePanel("National Park Visit Explorer"),
  fluidRow(
    column(4, 
      selectInput("selected_park", "Park", choices = parks,
        selected = "Crater Lake NP")
    ),
    column(4,
      sliderInput("selected_year", "Year", 
        value = 2019,
        min = min(annual_visits$year), 
        max = max(annual_visits$year),
        step = 1,
        sep = "")
    )
  ),
  h1(textOutput("park_name")),
  h3("Annual Visits"),
  fluidRow(
    column(8,
      plotOutput("annual_plot")
    ),
    column(4,
      textOutput("park_summary")
    )
  ),
  h3("Monthly Visits"),
  fluidRow(
    column(8, 
      plotOutput("monthly_plot"),
      checkboxInput("display_average", "Display monthly average")
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
      filter(year == input$selected_year) %>% 
      summarize_park()
  })

  output$monthly_table <- renderTable(digits = 0, {
    monthly_data() %>% 
      filter(year == input$selected_year) %>% 
      select(month_name, recreation_visits)
  })
  

  # Outputs that use all years ----------------------------------------------

  output$annual_plot <- renderPlot({
    annual_data() %>% 
      plot_annual(highlight_year = input$selected_year)
  })

  output$monthly_plot <- renderPlot({
    monthly_data() %>% 
      plot_monthly(display_average = input$display_average,
        highlight_year = input$selected_year) 
  })
  
}

shinyApp(ui, server)