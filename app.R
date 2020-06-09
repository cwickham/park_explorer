library(shiny)

ui <- fluidPage(
  textInput("selected_park", "Park")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)