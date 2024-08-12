library(shiny)
library(shiny.fluent)

ui <- fluentPage(
  titlePanel("CSV Data Viewer and Plotter"),
  Pivot(
    PivotItem(
      headerText = "Upload Data",
      Stack(
        tokens = list(childrenGap = 20),
        fileInput("file1", label = "Upload CSV", accept = c(".csv")),
        Text("Upload a CSV file to view and analyze data.")
      )
    ),
    PivotItem(
      headerText = "View Data",
      uiOutput("dataTable")
    ),
    PivotItem(
      headerText = "Plot Data",
      Stack(
        tokens = list(childrenGap = 20),
        DropdownInput("selectColumn", label = "Select Column", options = NULL),
        PlotOutput("dataPlot")
      )
    )
  )
)


server <- function(input, output, session) {
  data <- reactiveVal(data.frame())
  
  observeEvent(input$file1, {
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    data(df)
  })
  
  output$dataTable <- renderDetailsList({
    req(data())
    list(items = data())
  })
  
  observe({
    req(data())
    updateDropdownInput(session, "selectColumn", choices = names(data()))
  })
  
  output$dataPlot <- renderPlot({
    req(input$selectColumn)
    df <- data()
    ggplot(df, aes_string(x = input$selectColumn)) + 
      geom_histogram(bins = 30) +
      theme_minimal() +
      labs(x = input$selectColumn, title = paste("Histogram of", input$selectColumn))
  })
}


shinyApp(ui = ui, server = server)
