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
            menuItem("Explore Coral",
                tabName = "page_1", icon = icon("magnifying-glass"),
                menuSubItem("Coral Community", tabName = "page_1-1"),
                menuSubItem("Coral Health", tabName = "page_1-2"),
                menuSubItem("Coral Cover", tabName = "page_1-3")
            ),
            menuItem("Explore Macroalgae",
                tabName = "page_2", icon = icon("magnifying-glass"),
                menuSubItem("Macroalgae Species", tabName = "page_2-1"),
                menuSubItem("Macroalgae Cover", tabName = "page_2-2")
            ),
            menuItem("Explore Fish",
                tabName = "page_3", icon = icon("magnifying-glass"),
                menuSubItem("Fish Size", tabName = "page_3-1"),
                menuSubItem("Fish Biomass", tabName = "page_3-2"),
                menuSubItem("Fish Observations", tabName = "page_3-3")
            ),
            menuItem("Map", tabName = "page_4", icon = icon("map"))
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
                tabName = "page_1-1",
                h3("Coral Community Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Coral size, depth, functional group by year")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Coral size, depth, functional group by locality")
                        )
                    ),
                    tabPanel(
                        h2("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Coral size, depth, functional group by species")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_1-2",
                h3("Coral Health Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Bleaching and disease by year")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Bleaching and disease by locality")
                        )
                    ),
                    tabPanel(
                        h2("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Bleaching and disease by species")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_1-3",
                h3("Coral Cover Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Percent coral cover by year")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Percent coral cover by locality")
                        )
                    ),
                    tabPanel(
                        h2("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Percent coral cover by species")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_2-1",
                h3("Macroalgae Species Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Macroalgae species by year")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Macroalgae species by locality")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_2-2",
                h3("Macroalgae Cover Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Macroalgae percent cover by year")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Macroalgae percent cover by locality")
                        )
                    ),
                    tabPanel(
                        h2("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Macroalgae percent cover by species")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_3-1",
                h3("Fish Size Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish size by year and family")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish size by locality and family")
                        )
                    ),
                    tabPanel(
                        h2("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish size by species")
                        )
                    ),
                    tabPanel(
                        h2("By Time of Day"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish size by time of day")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_3-2",
                h3("Fish Biomass Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish biomass by year and group")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish biomass by locality and group")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_3-3",
                h3("Fish Observations Explorer"),
                tabsetPanel(
                    tabPanel(
                        h2("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish count and richness by year and group")
                        )
                    ),
                    tabPanel(
                        h2("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish count and richness by locality and group")
                        )
                    ),
                    tabPanel(
                        h2("By Time of Day"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        fluidRow(
                            p("Fish count and richness by time of day and group")
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_4",
                h3("Map of Turneffe Atoll Marine Reserve")
            )
        )
    )
)
