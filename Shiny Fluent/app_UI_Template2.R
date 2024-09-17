library(shiny)
library(shiny.fluent)
library(plotly)

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
      width = "240px"
    ),
    div(
      style = list(marginLeft = "10px"),
      Text(variant = "medium", title, block = TRUE),
      Text(variant = "xxLarge", value, block = TRUE)
    )
  )
}

makeCard <- function(title, content, size = 12, style = "", headerStyle = "background-color: #0078d4; color: white; padding: 10px;") {
  div(
    class = glue("card ms-depth-8 ms-sm{size} ms-xl{size}"),
    style = style,
    div(
      class = "card-header",
      style = headerStyle,
      Text(variant = "large", title, block = TRUE)
    ),
    div(
      class = "card-body",
      Stack(
        tokens = list(childrenGap = 5),
        content
      )
    )
  )
}


ui <- fluentPage(
  tags$head(tags$style(HTML("
    .card { padding: 28px; margin-bottom: 28px; }
    .header { padding: 20px 0; text-align: center; font-size: 24px; font-weight: bold; }
    .value-box { transition: background-color 0.3s ease; }
    .value-box:hover { background-color: darken(#0078D7, 10%); }
  "))),
  Text(variant = "xxLarge", "Dynamic Deal Dashboard: Explore Trends & Insights", block = TRUE, className = "header"),
  Stack(
    horizontal = TRUE,
    horizontalAlign = "end",
    tokens = list(childrenGap = 10),
    makeValueBox("Total Sales", "120K", "#0078D7"),
    makeValueBox("Customer Satisfaction", "89%", "#28A745"),
    makeValueBox("Open Issues", "34", "#FF6347")
  ),
  Stack(
    tokens = list(childrenGap = 10),
    horizontal = TRUE,
    makeCard("Data Filters", 
             div(
               Slider.shinyInput("dateRange", label = "Select Date Range:", min = 2020, max = 2024, value = c(2022, 2024)),
               Dropdown.shinyInput("category", label = "Select Category:", choices = c("Tech", "Finance", "Health")),
               Dropdown.shinyInput("region", label = "Select Region:", choices = c("North", "South", "East", "West"))
             ), 
             size = 4, style = "max-height: 320px"),
    makeCard("Interactive Deal Analysis", plotlyOutput("plot"), size = 8, style = "max-height: 450px")
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlotly({
    df <- data.frame(Date = c(2022, 2023), Count = c(10, 15))
    plot_ly(df, x = ~Date, y = ~Count, type = 'bar')
  })
}

shinyApp(ui, server)