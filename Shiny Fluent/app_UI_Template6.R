library(shiny)
library(shiny.fluent)
library(plotly)
library(glue)
library(dplyr)

# Inbuilt dataset
data(mtcars)

makeValueBox <- function(title, value, color = "#0078D7") {
  div(
    class = "value-box",
    style = list(
      padding = "20px",
      margin = "10px",
      color = "#FFFFFF",
      backgroundColor = color,
      borderRadius = "5px",
      display = "flex",
      alignItems = "center",
      width = "300px"
    ),
    div(
      style = list(marginLeft = "5px", marginRight = "5px"),
      Text(variant = "medium", title, block = TRUE),
      Text(variant = "xxLarge", value, block = TRUE)
    )
  )
}

Card1 <- function(title, content, size = 12, style = "") {
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

makeCard <- function(title, content, size = 12, style = "") {
  div(
    class = glue("card ms-depth-8 ms-sm{size} ms-xl{size}"),
    style = glue("padding: 20px; background-color: #fff; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); {style}"),
    div(
      style = "margin-bottom: 20px; font-size: 24px; color: #333;",
      title
    ),
    div(  # Line div
      style = "height: 0.8px; background-color: #ccc; margin-bottom: 20px;"
    ),
    div(
      content
    )
  )
}




ui <- fluentPage(
  tags$head(tags$style(HTML("
    .card { padding: 28px; margin-bottom: 28px; }
    .header { padding: 20px 0; text-align: center; font-size: 24px; font-weight: bold; }
    .value-box { transition: background-color 0.3s ease; }
    .value-box:hover { background-color: #005a9e; }
    .analysis-button { background-color: #fff; color: #333; border-color: #ccc; } 
  "))),
  Text(variant = "xxLarge", "Dynamic Car Analysis Dashboard: Explore Trends & Insights", block = TRUE, className = "header"),
  Stack(
    tokens = list(childrenGap = 10),
    horizontal = TRUE,
    horizontalAlign = "center",
    Card1(
      "", 
      div(
        Stack(
          horizontal = TRUE,
          tokens = list(childrenGap = 10),
          makeValueBox("Total Cars", as.character(nrow(mtcars)), "#f4f2ee"),
          makeValueBox("Average MPG", round(mean(mtcars$mpg), 2), "#f4f2ee"),
          makeValueBox("Maximum HP", as.character(max(mtcars$hp)), "#f4f2ee"),
          makeValueBox("Minimum HP", as.character(min(mtcars$hp)), "#f4f2ee")
        )
      ),
      size = 12,
      style = "max-height: 100px"
    )
  ),
  Stack(
    tokens = list(childrenGap = 10),
    horizontal = TRUE,
    makeCard(
      "Data Filters", 
      div(
        Dropdown.shinyInput("cylFilter", label = "Select Cylinder Count:", options = unique(mtcars$cyl), selected = unique(mtcars$cyl)[1]),
        CompoundButton.shinyInput("runAnalysis", style = list(marginTop = "20px", marginBottom = "28px"), text = "Run Analysis", secondaryText = '', className = "analysis-button")
      ), 
      size = 4, 
      style = "max-height: 480px; background-color: #f4f2ee;"
    ),
    makeCard(
      "Car Performance Metrics by Cylinder", 
      plotlyOutput("plot"), 
      size = 8, 
      style = "max-height: 480px"
    )
  )
)


server <- function(input, output, session) {
  observeEvent(input$runAnalysis, {
    output$plot <- renderPlotly({
      req(input$cylFilter)
      df <- mtcars %>% filter(cyl == input$cylFilter)
      plot_ly(df, x = ~cyl, y = ~mpg, type = 'bar', marker = list(color = '#007bff')) %>%
        layout(title = "MPG by Cylinder",
               xaxis = list(title = "Cylinders"),
               yaxis = list(title = "MPG"))
    })
  })
}

shinyApp(ui, server)