# Shiny Fluent

## Fluent Shiny Dashboard Project

## Overview
This project is developed using the [Shiny Fluent](https://appsilon.github.io/shiny.fluent/articles/shiny-fluent.html) framework to create an intuitive and interactive dashboard for analyzing sales data. It includes several Shiny applications that demonstrate the functionality of data filtering, data presentation, and further data analysis.

## Files and Directories
- **Fluent UI Dashboard**: The main directory for the dashboard components.
- **.RData**: Files where R data objects are saved.
- **.Rhistory**: Files recording the history of R commands.
- **app_checkbox.R**: Demonstrates the implementation of checkbox elements.
- **app_combobox.R**: Features combobox UI elements.
- **app_modules.R**: Contains reusable Shiny modules.
- **app_UI_nav[1-3].R**: Navigation bars for the UI.
- **app_UI_Template[1-6].R**: Different UI templates for the dashboard.
- **app[0-3].R**: Primary application scripts, including:
- **app0.R**: Base application setup.
- **app1.R**: Advanced configurations.
- **app2_Sales_Deals_Datatable.R**: Data tables for sales deals.
- **app3_Adding_Filtering.R**: Dynamic data filtering functionalities.


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
