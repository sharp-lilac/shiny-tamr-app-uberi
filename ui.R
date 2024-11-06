## ui.R

# Load packages ---------------------------
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)

# Source Objects ---------------------------
source("theme.R")
source("data_prepare.R")
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
                h2("Coral Community Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Coral size, depth, functional group by year")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Coral size, depth, functional group by locality")
                    ),
                    tabPanel(
                        h3("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Coral size, depth, functional group by species")
                    )
                )
            ),
            tabItem(
                tabName = "page_1-2",
                h2("Coral Health Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Bleaching and disease by year")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Bleaching and disease by locality")
                    ),
                    tabPanel(
                        h3("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Bleaching and disease by species")
                    )
                )
            ),
            tabItem(
                tabName = "page_1-3",
                h2("Coral Cover Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year and Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        sidebarLayout(
                            sidebarPanel(
                                width = 2,
                                pickerInput(
                                    inputId = "coral_cover_year_choose_locality",
                                    label = "Select Locality:",
                                    choices = localities,
                                    selected = localities,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3"
                                    ),
                                    multiple = TRUE
                                ),
                                switchInput(
                                    inputId = "coral_cover_year_consolidate_locality",
                                    label = "Consolidate!"
                                ),
                                pickerInput(
                                    inputId = "coral_cover_year_choose_year",
                                    label = "Select Year:",
                                    choices = years,
                                    selected = years,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3"
                                    ),
                                    multiple = TRUE
                                ),
                                switchInput(
                                    inputId = "coral_cover_year_consolidate_year",
                                    label = "Consolidate!"
                                )
                            ),
                            mainPanel(
                                plotOutput(outputId = "coral_cover_year_plot", height = "700px") %>%
                                    withSpinner(type = 8, color = palette[4]),
                                width = 10
                            )
                        )
                    ),
                    tabPanel(
                        h3("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Percent coral cover by species")
                    )
                )
            ),
            tabItem(
                tabName = "page_2-1",
                h2("Macroalgae Species Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Macroalgae species by year")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Macroalgae species by locality")
                    )
                )
            ),
            tabItem(
                tabName = "page_2-2",
                h2("Macroalgae Cover Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Macroalgae percent cover by year")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Macroalgae percent cover by locality")
                    ),
                    tabPanel(
                        h3("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Macroalgae percent cover by species")
                    )
                )
            ),
            tabItem(
                tabName = "page_3-1",
                h2("Fish Size Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish size by year and family")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish size by locality and family")
                    ),
                    tabPanel(
                        h3("By Species"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish size by species")
                    ),
                    tabPanel(
                        h3("By Time of Day"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish size by time of day")
                    )
                )
            ),
            tabItem(
                tabName = "page_3-2",
                h2("Fish Biomass Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish biomass by year and group")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish biomass by locality and group")
                    )
                )
            ),
            tabItem(
                tabName = "page_3-3",
                h2("Fish Observations Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("By Year"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish count and richness by year and group")
                    ),
                    tabPanel(
                        h3("By Locality"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish count and richness by locality and group")
                    ),
                    tabPanel(
                        h3("By Time of Day"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        p("Fish count and richness by time of day and group")
                    )
                )
            ),
            tabItem(
                tabName = "page_4",
                h2("Map of Turneffe Atoll Marine Reserve"),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                p("Map of Turneffe Atoll Marine Reserve. Each surveyed locality is indicated with a white circle, zones are indicated with warm colors, and ecosystems are indicated with solid cool colors. Shapefiles for zones belong to Belize Fisheries Department (Belize Geomatics 2022) and were made available through the Turneffe Atoll Sustainability Association. Shapefiles for the base map and ecosystems come from the publicly available Spatial Data Warehouse for Belize (Meerman 2013, Meerman 2017)."),
                div( style="width: 33%; margin: auto", img(src="images/Turneffe_Map.jpg", width="100%", height = "50%")), # nolint
                br(),
                p("Belize Geomatics. (2022). Turneffe Atoll Areas, Belize Replenishment Zones Project [dataset]. Meerman, J. C. (2013). Belize Basemap [dataset]. Biodiversity and Environmental Resource Data System of Belize.", 
                    br(), 
                    "http://www.biodiversity.bz/"
                ),
                br(),
                p("Meerman, J. C. (2017). Belize_Ecosystems_2017 [dataset]. Biodiversity and Environmental Resource Data System of Belize. ", 
                    br(), 
                    "http://www.biodiversity.bz/"
                ),
            )
        )
    )
)
