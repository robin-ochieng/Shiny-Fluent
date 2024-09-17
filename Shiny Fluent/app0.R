library(shiny)
library(shiny.fluent)
library(plotly)

# Helper function to create a card-like UI element
makeCard <- function(title, content) {
  div(
    class = "custom-card",
    div(
      class = "card-header",
      Text(title, variant = "mediumPlus")
    ),
    div(
      class = "card-body",
      content
    ),
    style = list(margin = "10px", border = "1px solid #cccccc", borderRadius = "5px", padding = "10px")
  )
}

ui <- fluentPage(
  div(
    class = "grid-container",
    div(class = "header", 
        tagList(
          img(src = "appsilon-logo.png", class = "logo"), 
          div(Text("Sales Reps Analysis", variant = "xLarge"), class = "title"),
          CommandBar(
            items = list(
              CommandBarItem("New", "Add"),
              CommandBarItem("Upload", "Upload"),
              CommandBarItem("Share", "Share"),
              CommandBarItem("Download", "Download")
            )
          )
        )
    ),
    div(class = "sidenav", 
        Nav(
          groups = list(
            list(links = list(
              list(name = 'Home', url = '#', key = 'home', icon = 'Home'),
              list(name = 'Analysis', url = '#', key = 'analysis', icon = 'AnalyticsReport')
            ))
          ),
          initialSelectedKey = 'home'
        )
    ),
    div(class = "main",
        fluidPage(
          fluidRow(
            column(4,
                   makeCard("Filters",
                            tagList(
                              selectInput("selectVariable", "Select Variable", choices = c("Var1", "Var2")),
                              sliderInput("sliderInput", "Select Range:", min = 0, max = 100, value = c(20, 80))
                            )
                   )
            ),
            column(8,
                   plotlyOutput("plot")
            )
          )
        )
    ),
    div(class = "footer", 
        Text("Built with ❤ by Appsilon", variant = "medium")
    )
  ),
  tags$head(
    tags$link(href = "style.css", rel = "stylesheet", type = "text/css")
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlotly({
    plot_ly(data = mtcars, x = ~mpg, y = ~disp, type = 'scatter', mode = 'markers')
  })
}

shinyApp(ui, server)
