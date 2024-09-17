library(shiny)
library(shiny.fluent)

shinyApp(
  ui = div(
    Checkbox.shinyInput("checkbox", value = TRUE),
    textOutput("checkboxValue")
  ),
  server = function(input, output) {
    output$checkboxValue <- renderText({
      sprintf("Value: %s", input$checkbox)
    })
  }
)
