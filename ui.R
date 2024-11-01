## ui.R

# Load packages ---------------------------
library(shiny)
library(shinydashboard)

# Define ui ---------------------------
ui <- dashboardPage(
    dashboardHeader(title = "App Launch"),
    dashboardSidebar(disable = TRUE),
    dashboardBody("App launch test - auto-deploy")
)
