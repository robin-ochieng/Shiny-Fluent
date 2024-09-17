library(shiny)
library(shiny.fluent)

calcModes <- list(
  list(key = "add", text = "Addition"),
  list(key = "mul", text = "Multiplication")
)

calcUI <- function(id) {
  ns <- NS(id)
  div(style = "margin: 15px 0px 15px",
      ChoiceGroup(ns("mode"), label = "Operation", value = "add", options = calcModes),
      Label("Values"),
      flowLayout(
        SpinButton(ns("a"), label = "A = ", value = 3),
        SpinButton(ns("b"), label = "B = ", value = 5)
      )
  )
}

calcServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    result <- reactive({
      switch(req(input$mode),
             add = input$a + input$b,
             mul = input$a * input$b
      )
    })
    return(result)
  })
}

shinyApp(
  ui = fluidPage(
    calcUI("calc"),
    textOutput("result")
  ),
  server = function(input, output) {
    result <- calcServer("calc")
    output$result <- renderText(
      paste("The module returned", result())
    )
  }
)