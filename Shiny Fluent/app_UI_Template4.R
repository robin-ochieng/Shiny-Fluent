library(shiny)
library(shiny.fluent)
library(plotly)
library(glue)

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
  tags$head(tags$style(HTML("
    .card { padding: 28px; margin-bottom: 28px; }
    .header { padding: 20px 0; text-align: center; font-size: 24px; font-weight: bold; }
    .value-box { transition: background-color 0.3s ease; }
    .value-box:hover { background-color: #005a9e; } /* Approximation of darken(#0078D7, 10%) */
  "))),
  Text(variant = "xxLarge", "Dynamic Deal Dashboard: Explore Trends & Insights", block = TRUE, className = "header"),
  Stack(
    tokens = list(childrenGap = 10),
    horizontal = TRUE,
    horizontalAlign = "center",
    makeCard(
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
        Dropdown.shinyInput("cylFilter", label = "Select Cylinder Count:", choices = unique(mtcars$cyl)),
        Dropdown.shinyInput("gearFilter", label = "Select Gear Count:", choices = unique(mtcars$gear)),
        Dropdown.shinyInput("carbFilter", label = "Select Carburetor Count:", choices = unique(mtcars$carb))
      ), 
      size = 4, 
      style = "max-height: 450px"
    ),
    makeCard(
      "Interactive Car Analysis", 
      plotlyOutput("plot"), 
      size = 8, 
      style = "max-height: 450px"
    )
  )
)


server <- function(input, output, session) {
  filteredData <- reactive({
    mtcars %>%
      filter(
        cyl %in% input$cylFilter,
        gear %in% input$gearFilter,
        carb %in% input$carbFilter
      )
  })
  
  output$plot <- renderPlotly({
    df <- filteredData()
    plot_ly(df, x = ~cyl, y = ~mpg, type = 'bar', color = ~factor(cyl), text = ~paste("HP:", hp), hoverinfo = "text")
  })
}


shinyApp(ui, server)