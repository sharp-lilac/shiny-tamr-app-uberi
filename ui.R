## ui.R

# Load packages ---------------------------
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)

# Source Objects ---------------------------
source("theme.R")

# Define ui ---------------------------
ui <- dashboardPage(
    dashboardHeader(title = "Title!"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Home", tabName = "home", icon = icon("home")),
            menuItem("Page1", tabName = "page_1", icon = icon("lemon")),
            menuItem("Page2",
                tabName = "page_2", icon = icon("leaf"),
                menuSubItem("Page2-1", tabName = "page_2-1"),
                menuSubItem("Page2-2", tabName = "page_2-2")
            )
        )
    ),
    dashboardBody(
        use_theme(dash_theme),
        tags$style(HTML("
            .bttn, .bttn-lg, .bttn-md, .bttn-sm, .bttn-xs {
                background-color: #88C0D0;
                color: #FFFFFF;
            }
            .bttn-jelly.bttn-primary {
                background-color: #88C0D0;
                color: #FFFFFF;
            }
            .bttn-jelly.bttn-warning {
                background-color: #D08770;
                color: #FFFFFF;
            }
            .bttn-jelly.bttn-danger {
                background-color: #BF616A;
                color: #FFFFFF;
            }
            .bttn-jelly.bttn-success {
                background-color: #A3BE8C;
                color: #FFFFFF;
            }
            .bttn-jelly.bttn-royal {
                background-color: #5E81AC;
                color: #FFFFFF;
            }
        ")),
        fluidRow(column(width = 12, div(style = "height: 20px;"))),
        tabItems(
            tabItem(
                tabName = "home",
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                fluidRow(
                    h1("Home")
                ),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                fluidRow(
                    column(width = 2, actionBttn(inputId = "Id113", label = "primary", style = "jelly", color = "primary")),
                    column(width = 2, actionBttn(inputId = "Id113", label = "success", style = "jelly", color = "success")),
                    column(width = 2, actionBttn(inputId = "Id113", label = "warning", style = "jelly", color = "warning")),
                    column(width = 2, actionBttn(inputId = "Id113", label = "danger", style = "jelly", color = "danger")),
                    column(width = 2, actionBttn(inputId = "Id113", label = "royal", style = "jelly", color = "royal"))
                )
            ),
            tabItem(
                tabName = "page_1",
                tabsetPanel(
                    tabPanel(
                        "Tab 1",
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            h1("Tab 1 Content")
                        )
                    ),
                    tabPanel(
                        "Tab 2",
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            h1("Tab 2 Content")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_2-1",
                tabsetPanel(
                    tabPanel(
                        "Tab 3",
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            h1("Tab 3 Content")
                        )
                    ),
                    tabPanel(
                        "Tab 4",
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            h1("Tab 4 Content")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_2-2",
                tabsetPanel(
                    tabPanel(
                        "Tab 5",
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            h1("Tab 5 Content")
                        )
                    ),
                    tabPanel(
                        "Tab 6",
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            h1("Tab 6 Content")
                        )
                    )
                )
            )
        )
    )
)
