library(shiny.fluent)


makeCard <- function(title, content, size = 12, style = "") {
  div(
    class = glue("card ms-depth-8 ms-sm{size} ms-xl{size}"),
    style = style,
    Stack(
      tokens = list(childrenGap = 5),
      Text(variant = "large", title, block = TRUE),
      content
    )
  )
}


ui <- fluentPage(
  tags$style(".card { padding: 28px; margin-bottom: 28px; }"),
  Stack(
    tokens = list(childrenGap = 10), horizontal = TRUE,
    makeCard("Filters", , size = 4, style = "max-height: 320px"),
    makeCard("Deals count", plotlyOutput("plot"), size = 8, style = "max-height: 320px")
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)