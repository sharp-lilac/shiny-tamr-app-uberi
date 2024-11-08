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
map_text <- paste(readLines("text/map.txt"))
link_text <- paste(readLines("text/links.txt"))

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
            menuItem("Explore Benthos",
                tabName = "page_2", icon = icon("magnifying-glass")
            ),
            menuItem("Explore Fish",
                tabName = "page_3", icon = icon("magnifying-glass"),
                menuSubItem("Fish Size", tabName = "page_3-1"),
                menuSubItem("Fish Biomass", tabName = "page_3-2"),
                menuSubItem("Fish Observations", tabName = "page_3-3")
            ),
            menuItem("Quick Links",
                tabName = "page_4", icon = icon("location-arrow"),
                menuSubItem("UB-ERI Website", href = link_text[1]),
                menuSubItem("AGRRA Website", href = link_text[2]),
                menuSubItem("HRHP Website", href = link_text[5]),
                menuSubItem("MBRS SMP Methods", href = link_text[3]),
                menuSubItem("Dryad Data", href = link_text[4]),
                menuSubItem("GitHub Repository", href = link_text[6])
            ),
            menuItem("Map", tabName = "page_5", icon = icon("map"))
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
                                ),
                                prettyRadioButtons(
                                    inputId = "coral_cover_year_xaxis_toggle",
                                    label = "Select X-Axis:",
                                    choices = c("Locality", "Year"),
                                    selected = "Year",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
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
                        sidebarLayout(
                            sidebarPanel(
                                width = 2,
                                pickerInput(
                                    inputId = "coral_cover_species_choose_locality",
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
                                pickerInput(
                                    inputId = "coral_cover_species_choose_year",
                                    label = "Select Year:",
                                    choices = years,
                                    selected = years,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3",
                                        liveSearch = TRUE
                                    ),
                                    multiple = TRUE
                                ),
                                prettyRadioButtons(
                                    inputId = "coral_cover_species_color_toggle",
                                    label = "Color by:",
                                    choices = c("Locality", "Year", "Neither"),
                                    selected = "Year",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
                                ),
                                numericInput(
                                    inputId = "coral_cover_species_max_species",
                                    label = "Number of Coral Species to Display",
                                    value = 10,
                                    min = 5,
                                    max = 15,
                                    step = 1
                                ),
                                pickerInput(
                                    inputId = "coral_cover_species_select_species",
                                    label = "Species of Interest",
                                    choices = c("All", coral_species),
                                    selected = "All",
                                    multiple = FALSE,
                                    options = pickerOptions(
                                        actionsBox = FALSE,
                                        size = 10,
                                        selectedTextFormat = "count > 3",
                                        liveSearch = TRUE
                                    )
                                )
                            ),
                            mainPanel(
                                plotOutput(outputId = "coral_cover_species_plot", height = "700px") %>%
                                    withSpinner(type = 8, color = palette[4]),
                                h3("Table of Coral Codes"),
                                DT::dataTableOutput(outputId = "coral_cover_species_table"),
                                width = 10
                            )
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_2",
                h2("Benthic Composition Explorer"),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                sidebarLayout(
                    sidebarPanel(
                        width = 2,
                        pickerInput(
                            inputId = "benthic_comp_choose_locality",
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
                        pickerInput(
                            inputId = "benthic_comp_choose_year",
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
                        prettyRadioButtons(
                            inputId = "benthic_comp_xaxis_toggle",
                            label = "Select X-Axis:",
                            choices = c("Locality", "Year"),
                            selected = "Year",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        ),
                        prettyRadioButtons(
                            inputId = "benthic_comp_cat_toggle",
                            label = "Select Benthic Categories:",
                            choices = c("Default" = "Bucket2_Name", "AGRRA Categories" = "AGRRA_Bucket"),
                            selected = "Bucket2_Name",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        )
                    ),
                    mainPanel(
                        plotOutput(outputId = "benthic_comp_plot", height = "700px") %>%
                            withSpinner(type = 8, color = palette[4]),
                        width = 10
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
                tabName = "page_5",
                h2("Map of Turneffe Atoll Marine Reserve"),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                fluidRow(
                    column(
                        width = 9,
                        div(
                            class = "section-box",
                            p(map_text[1])
                        )
                    )
                ),
                div(style = "width: 33%; float:left;", img(src = "images/Turneffe_Map.jpg", width = "100%", height = "50%")),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                fluidRow(
                    column(
                        width = 9,
                        div(
                            class = "section-box alternate",
                            p(map_text[2], br(), "http://www.biodiversity.bz/"),
                            br(),
                            p(map_text[3], br(), "http://www.biodiversity.bz/")
                        )
                    )
                )
            )
        )
    )
)
