## ui.R

# Load packages ---------------------------
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)

# Source Objects ---------------------------
source("theme.R")
home_text <- paste(readLines("text/home.txt"))

# Define ui ---------------------------
ui <- dashboardPage(
    dashboardHeader(title = "Explore TAMR"),
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
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom_styles.css")),
        use_theme(dash_theme),
        tabItems(
            tabItem(
                tabName = "home",
                fluidRow(
                    column(
                        width = 12,
                        h1("Turneffe Data Exploration App"),
                        br(),
                        h3("Our Long-Term Reef Monitoring Data"),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box",
                                    p(home_text[1], face = "bold"), p(home_text[2]), p(home_text[3]), p(home_text[4])
                                )
                            )
                        ),
                        h3("Project Collaborators"),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box alternate",
                                    p(home_text[5]), p(home_text[6])
                                )
                            )
                        ),
                        h3("Access Our Data"),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box alternate-2",
                                    p(home_text[7])
                                )
                            )
                        )
                    ),
                    fluidRow(column(width = 12, div(style = "height: 20px;")))
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
