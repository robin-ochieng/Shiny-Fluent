library(shiny)
library(shiny.fluent)
library(plotly)  # For interactive charts

# Custom rendering of group headers and adding icons
navigation_styles <- list(
  root = list(
    height = "100%",
    width = "250px",  # Slightly wider to accommodate icons and text
    boxSizing = "border-box",
    border = "1px solid #eee",
    overflowY = "auto"
  )
)

link_groups <- list(
  list(
    name = "Pages",
    links = list(
      list(name = "Activity", icon = "Ribbon", key = "activity"),
      list(name = "News", icon = "News", key = "news")
    )
  ),
  list(
    name = "More Pages",
    links = list(
      list(name = "Settings", icon = "Settings", key = "settings"),
      list(name = "Notes", icon = "QuickNote", key = "notes")
    )
  )
)

ui <- function(id) {
  fluidPage(
    div(
      style = list(display = "flex", flexDirection = "row"),
      Nav(
        groups = link_groups,
        selectedKey = "activity",  # Default selection
        styles = navigation_styles,
        onLinkClick = JS("(_, item) => Shiny.setInputValue('selectedTab', item.key)")
      ),
      div(
        style = list(flexGrow = 1, padding = "20px"),
        uiOutput("tabContent")  # Dynamically updated UI output
      )
    )
  )
}

server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Reactive value to store the current tab
    selectedTab <- reactive({ input$selectedTab })
    
    output$tabContent <- renderUI({
      switch(selectedTab(),
             activity = plotlyOutput("barPlot"),
             news = plotlyOutput("pieChart"),
             NULL
      )
    })
    
    # Generate a bar plot for the "Activity" tab
    output$barPlot <- renderPlotly({
      data <- data.frame(
        Category = c("A", "B", "C"),
        Values = c(10, 15, 8)
      )
      plot_ly(data, x = ~Category, y = ~Values, type = 'bar')
    })
    
    # Generate a pie chart for the "News" tab
    output$pieChart <- renderPlotly({
      data <- data.frame(
        Category = c("News1", "News2", "News3"),
        Values = c(40, 30, 30)
      )
      plot_ly(data, labels = ~Category, values = ~Values, type = 'pie', textinfo = 'label+percent')
    })
  })
}

if (interactive()) {
  shinyApp(ui("app"), function(input, output) server("app"))
}
