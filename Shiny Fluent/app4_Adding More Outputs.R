library(dplyr)
library(shiny.fluent)
library(imola)
library(shiny.router)
library(glue)
library(plotly)
library(leaflet)

details_list_columns <- tibble(
  fieldName = c("rep_name", "date", "deal_amount", "client_name", "city", "is_closed"),
  name = c("Sales rep", "Close date", "Amount", "Client", "City", "Is closed?"),
  key = fieldName)

filters <- Stack(
  tokens = list(childrenGap = 10),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 30),
    DatePicker.shinyInput("fromDate", value = as.Date('2020/01/01'), label = "From date"),
    DatePicker.shinyInput("toDate", value = as.Date('2020/12/31'), label = "To date")
  ),
  Label("Filter by sales reps", className = "my_class"),
  NormalPeoplePicker.shinyInput(
    "selectedPeople",
    class = "my_class",
    options = fluentPeople,
    pickerSuggestionsProps = list(
      suggestionsHeaderText = 'Matching people',
      mostRecentlyUsedHeaderText = 'Sales reps',
      noResultsFoundText = 'No results found',
      showRemoveButtons = TRUE
    )
  ),
  Slider.shinyInput("slider",
                    value = 0, min = 0, max = 1000000, step = 100000,
                    label = "Minimum amount",
                    valueFormat = JS("function(x) { return '$' + x}"),
                    snapToStep = TRUE
  ),
  Toggle.shinyInput("closedOnly", value = TRUE, label = "Include closed deals only?")
)

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
    makeCard("Filters", filters, size = 4, style = "max-height: 320px"),
    makeCard("Deals count", plotlyOutput("plot"), size = 8, style = "max-height: 320px")
  ),
  uiOutput("analysis")
)

server <- function(input, output, session) {
  filtered_deals <- reactive({
    req(input$fromDate)
    selectedPeople <- (
      if(length(input$selectedPeople) > 0) input$selectedPeople
      else fluentPeople$key
    )
    minClosedVal <- if (isTRUE(input$closedOnly)) 1 else 0
    
    filtered_deals <- fluentSalesDeals %>%
      filter(
        rep_id %in% selectedPeople,
        date >= input$fromDate,
        date <= input$toDate,
        deal_amount >= input$slider,
        is_closed >= minClosedVal
      ) %>%
      mutate(is_closed = ifelse(is_closed == 1, "Yes", "No"))
  })
  
  output$analysis <- renderUI({
    items_list <- if(nrow(filtered_deals()) > 0){
      DetailsList(items = filtered_deals(), columns = details_list_columns)
    } else {
      p("No matching transactions.")
    }
    Stack(
      tokens = list(childrenGap = 10), horizontal = TRUE,
      makeCard("Top results", div(style="max-height: 500px; overflow: auto", items_list)),
      makeCard("Map", leafletOutput("map"))
    )
  })
  
  output$map <- renderLeaflet({
    deals <- filtered_deals()
      points <- cbind(deals$LONGITUDE, deals$LATITUDE)
      leaflet() %>%
        addProviderTiles(providers$Stamen.TonerLite, options = providerTileOptions(noWrap = TRUE)) %>%
        addMarkers(data = points)
  })
  
  output$plot <- renderPlotly({
    p <- ggplot(filtered_deals(), aes(x = rep_name)) +
      geom_bar(fill = unique(filtered_deals()$color)) +
      ylab("Number of deals") +
      xlab("Sales rep") +
      theme_light()
    ggplotly(p, height = 300)
  })
}

shinyApp(ui, server)
