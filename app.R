library(shiny)

ui <- fluidPage(
  textInput("selected_park", "Park"),
  textOutput("park_name")
)

server <- function(input, output, session) {
  output$park_name <- renderText(input$selected_park)
}

shinyApp(ui, server)