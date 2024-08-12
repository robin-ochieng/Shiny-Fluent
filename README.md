# Shiny Fluent

## Fluent Shiny Dashboard Project

## Overview
This project is developed using the [Shiny Fluent](https://appsilon.github.io/shiny.fluent/articles/shiny-fluent.html) framework to create an intuitive and interactive dashboard for analyzing sales data. It includes several Shiny applications that demonstrate the functionality of data filtering, data presentation, and further data analysis.

## Files and Directories
- `app1.R`: Basic setup for a Shiny application.
- `app2_Sales_Deals_Datatable.R`: Displays sales deals in a datatable format.
- `app3_Adding_Filtering.R`: Introduces filtering options to the sales deals datatable.
- `app4_Adding_More_Filtering.R`: Extends filtering options for more detailed analysis.
- `app4_Adding_More_Outputs.R`: Adds additional output elements to the dashboard.
- `Fluent_Shiny_Dashboard.R`: Combines all elements into a comprehensive dashboard.

## Getting Started
To run these applications, you will need to have R and Shiny installed. You can install Shiny using the following R command:

```R
install.packages("shiny")

Further, to utilize the Shiny Fluent UI components, make sure to install the Shiny Fluent package with:

```R
remotes::install_github("Appsilon/shiny.fluent")

## Usage
To run any individual app, open the R script in an R environment and run:

`shiny::runApp('path_to_script/script_name.R')`

Replace path_to_script/script_name.R with the actual path to the script you want to run.
