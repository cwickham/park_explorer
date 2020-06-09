library(shiny)

ui <- fluidPage(
  textInput("selected_park", "Park"),
  textOutput("park_name")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)