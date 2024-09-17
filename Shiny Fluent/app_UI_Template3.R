library(shiny)
library(shiny.fluent)
library(plotly)
library(glue)

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
          makeValueBox("Total Sales", "120K", "#f4f2ee"),
          makeValueBox("Average Sales", "70K", "#f4f2ee"),
          makeValueBox("Customer Satisfaction", "89%", "#f4f2ee"),
          makeValueBox("Open Issues", "34", "#f4f2ee")
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
        Slider.shinyInput("dateRange", label = "Select Date Range:", min = 2020, max = 2024, value = c(2022, 2024)),
        Dropdown.shinyInput("category", label = "Select Category:", choices = c("Tech", "Finance", "Health")),
        Dropdown.shinyInput("region", label = "Select Region:", choices = c("North", "South", "East", "West"))
      ), 
      size = 4, 
      style = "max-height: 450px"
    ),
    makeCard(
      "Interactive Deal Analysis", 
      plotlyOutput("plot"), 
      size = 8, 
      style = "max-height: 450px"
    )
  )
)


server <- function(input, output, session) {
  output$plot <- renderPlotly({
    df <- data.frame(Date = c(2022, 2023), Count = c(10, 15))
    plot_ly(df, x = ~Date, y = ~Count, type = 'bar')
  })
}

shinyApp(ui, server)