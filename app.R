library(shiny)
library(tidyverse)

# Function to form a one sentence summary from a year
# of annual data
summarize_park <- function(one_year){
  comma <- scales::label_comma()
  one_year %>% 
    glue::glue_data(
      "In { year }, { park_name } had { comma(recreation_visits) } recreation visits."
    )
}

# Import data
annual_visits <- read_rds("data/annual_visits.rds")
monthly_visits <- read_rds("data/monthly_visits.rds")

parks <- annual_visits$park_name %>% unique()

ui <- fluidPage(
  fluidRow(
    column(4, 
      selectInput("selected_park", "Park", choices = parks,
        selected = "Crater Lake NP")
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
      plotOutput("monthly_plot")
    )
  )
)

server <- function(input, output, session) {
  output$park_name <- renderText(input$selected_park)
  
  annual_data <- reactive({
    annual_visits %>% 
      filter(park_name == input$selected_park)
  })
  
  output$park_summary <- renderText({
    annual_data() %>% 
      filter(year == 2019) %>% 
      summarize_park()
  })

  output$annual_plot <- renderPlot({
    annual_data() %>% 
      ggplot(aes(year, recreation_visits)) +
      geom_point(data = ~ filter(., year == 2019)) +
      geom_line() +
      scale_y_continuous(labels = scales::label_comma()) +
      labs(x = "", y = "Visits")
  })

  output$monthly_plot <- renderPlot({
    monthly_visits %>% 
      filter(park_name == input$selected_park) %>% 
      ggplot(aes(month, recreation_visits_proportion)) +
      geom_line(aes(group = year), alpha = 0.2) +
      geom_line(data = ~ filter(.x, year == 2019)) +
      stat_summary(fun = mean, 
        geom = "line", color = "#325D88", size = 1.5) +
      scale_x_continuous(breaks = 1:12, labels = month.abb) +
      scale_y_continuous(labels = scales::label_percent()) +
      labs(x = "", y = "Of Annual Visits")
  })
  
}

shinyApp(ui, server)