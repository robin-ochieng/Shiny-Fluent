library(dplyr)
library(shiny.fluent)
library(imola)
library(shiny.router)

details_list_columns <- tibble(
  fieldName = c("rep_name", "date", "deal_amount", "client_name", "city", "is_closed"),
  name = c("Sales rep", "Close date", "Amount", "Client", "City", "Is closed?"),
  key = fieldName)

ui <- fluentPage(
  uiOutput("analysis")
)

server <- function(input, output, session) {
  filtered_deals <- reactive({
    filtered_deals <- fluentSalesDeals %>% filter(is_closed > 0)
  })
  
  output$analysis <- renderUI({
    items_list <- if(nrow(filtered_deals()) > 0){
      DetailsList(items = filtered_deals(), columns = details_list_columns)
    } else {
      p("No matching transactions.")
    }
    
    Stack(
      tokens = list(childrenGap = 5),
      Text(variant = "large", "Sales deals details", block = TRUE),
      div(style="max-height: 500px; overflow: auto", items_list)
    )
  })
}

shinyApp(ui, server)


