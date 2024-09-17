library(shiny)
library(shiny.fluent)

ui <- fluentPage(
  Pivot(
    PivotItem(
      headerText = "Test",
      Text("If you see this, the basic setup works!")
    )
  )
)

server <- function(input, output, session) {
}

shinyApp(ui = ui, server = server)
