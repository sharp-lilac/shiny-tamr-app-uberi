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
                menuSubItem("Coral Health", tabName = "page_1-2"),
                menuSubItem("Coral Size", tabName = "page_1-1"),
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
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    infoBoxOutput("keyCollectors"),
                                    infoBoxOutput("keyYears"),
                                    infoBoxOutput("keyLocale"),
                                    infoBoxOutput("keySites")
                                ) %>% tagAppendAttributes(class = "keyBoxes")
                            )
                        ),
                        h3(tags$strong("Disclaimer")),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box alternate",
                                    p(home_text[1], face = "bold")
                                )
                            )
                        ),
                        h3("Our Long-Term Reef Monitoring Data"),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box",
                                    p(home_text[2], face = "bold"), p(home_text[3]), p(home_text[4]), p(home_text[5])
                                )
                            )
                        ),
                        h3("Project Collaborators"),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box alternate",
                                    p(home_text[6]), p(home_text[7])
                                )
                            )
                        ),
                        h3("Access Our Data"),
                        fluidRow(
                            column(
                                width = 9,
                                div(
                                    class = "section-box alternate-2",
                                    p(home_text[8])
                                )
                            )
                        )
                    ),
                    fluidRow(column(width = 12, div(style = "height: 20px;")))
                )
            ),
            tabItem(
                tabName = "page_1-2",
                h2("Coral Health Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("Dead Coral"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        sidebarLayout(
                            sidebarPanel(
                                width = 2,
                                pickerInput(
                                    inputId = "coral_health_choose_locality",
                                    label = "Select Localities:",
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
                                    inputId = "coral_health_choose_year",
                                    label = "Select Years:",
                                    choices = years,
                                    selected = years,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3"
                                    ),
                                    multiple = TRUE
                                ),
                                pickerInput(
                                    inputId = "coral_health_choose_genus",
                                    label = "Select Genera:",
                                    choices = coral_genera,
                                    selected = coral_genera,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3"
                                    ),
                                    multiple = TRUE
                                ),
                                prettyRadioButtons(
                                    inputId = "coral_health_group_toggle",
                                    label = "Select Group:",
                                    choices = c("Locality", "Year", "Genus"),
                                    selected = "Year",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
                                )
                            ),
                            mainPanel(
                                plotOutput(outputId = "coral_health_plot", height = "1200px") %>%
                                    withSpinner(type = 8, color = palette[4]),
                                textOutput(outputId = "coral_health_caption"),
                                width = 10
                            )
                        )
                    ),
                    tabPanel(
                        h3("Disease and Bleaching"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        sidebarLayout(
                            sidebarPanel(
                                width = 2,
                                pickerInput(
                                    inputId = "coral_disease_choose_locality",
                                    label = "Select Localities:",
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
                                    inputId = "coral_disease_choose_year",
                                    label = "Select Years:",
                                    choices = years,
                                    selected = years,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3"
                                    ),
                                    multiple = TRUE
                                ),
                                pickerInput(
                                    inputId = "coral_disease_choose_genus",
                                    label = "Select Genera:",
                                    choices = coral_genera,
                                    selected = coral_genera,
                                    options = pickerOptions(
                                        actionsBox = TRUE,
                                        size = 10,
                                        selectedTextFormat = "count > 3"
                                    ),
                                    multiple = TRUE
                                )
                            ),
                            mainPanel(
                                plotOutput(outputId = "coral_disease_plot", height = "1100px") %>%
                                    withSpinner(type = 8, color = palette[4]),
                                textOutput(outputId = "coral_disease_caption"),
                                width = 10
                            )
                        )
                    )
                )
            ),
            tabItem(
                tabName = "page_1-1",
                h2("Coral Size Explorer"),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                sidebarLayout(
                    sidebarPanel(
                        width = 2,
                        pickerInput(
                            inputId = "coral_size_choose_locality",
                            label = "Select Localities:",
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
                            inputId = "coral_size_choose_year",
                            label = "Select Years:",
                            choices = years,
                            selected = years,
                            options = pickerOptions(
                                actionsBox = TRUE,
                                size = 10,
                                selectedTextFormat = "count > 3"
                            ),
                            multiple = TRUE
                        ),
                        pickerInput(
                            inputId = "coral_size_choose_genus",
                            label = "Select Genera:",
                            choices = coral_genera,
                            selected = coral_genera,
                            options = pickerOptions(
                                actionsBox = TRUE,
                                size = 10,
                                selectedTextFormat = "count > 3"
                            ),
                            multiple = TRUE
                        ),
                        prettyRadioButtons(
                            inputId = "coral_size_xaxis_toggle",
                            label = "Select X-Axis:",
                            choices = c("Locality", "Year", "Genus"),
                            selected = "Year",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        )
                    ),
                    mainPanel(
                        plotOutput(outputId = "coral_size_plot", height = "700px") %>%
                            withSpinner(type = 8, color = palette[4]),
                        textOutput(outputId = "coral_size_caption"),
                        width = 10
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
                                    label = "Select Localities:",
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
                                    label = "Select Years:",
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
                                textOutput(outputId = "coral_cover_year_caption"),
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
                                    label = "Select Localities:",
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
                                    label = "Select Years:",
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
                                textOutput(outputId = "coral_cover_species_caption"),
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
                            label = "Select Localities:",
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
                            label = "Select Years:",
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
                        ),
                        prettyRadioButtons(
                            inputId = "benthic_comp_reef_toggle",
                            label = "Select Reef Type:",
                            choices = c("All" = "All", "Backreef" = "Backreef", "Deep Forereef" = "Deep_Forereef", "Shallow Forereef" = "Shallow_Forereef"),
                            selected = "All",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        )
                    ),
                    mainPanel(
                        plotOutput(outputId = "benthic_comp_plot", height = "700px") %>%
                            withSpinner(type = 8, color = palette[4]),
                        textOutput(outputId = "benthic_comp_caption"),
                        width = 10
                    )
                )
            ),
            tabItem(
                tabName = "page_3-1",
                h2("Fish Size Explorer"),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                sidebarLayout(
                    sidebarPanel(
                        width = 2,
                        pickerInput(
                            inputId = "fish_size_choose_locality",
                            label = "Select Localities:",
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
                            inputId = "fish_size_choose_year",
                            label = "Select Years:",
                            choices = years,
                            selected = years,
                            options = pickerOptions(
                                actionsBox = TRUE,
                                size = 10,
                                selectedTextFormat = "count > 3"
                            ),
                            multiple = TRUE
                        ),
                        pickerInput(
                            inputId = "fish_size_choose_family",
                            label = "Select Fish Families:",
                            choices = fish_families,
                            selected = fish_families,
                            options = pickerOptions(
                                actionsBox = TRUE,
                                size = 10,
                                selectedTextFormat = "count > 3"
                            ),
                            multiple = TRUE
                        ),
                        prettyRadioButtons(
                            inputId = "fish_size_xaxis_toggle",
                            label = "Select X-Axis:",
                            choices = fish_choices,
                            selected = "Fish_Family",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        ),
                        prettyRadioButtons(
                            inputId = "fish_size_means_toggle",
                            label = "Select Group for Mean:",
                            choices = fish_choices[1:3],
                            selected = "Year",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        )
                    ),
                    mainPanel(
                        plotOutput(outputId = "fish_size_plot", height = "700px") %>%
                            withSpinner(type = 8, color = palette[4]),
                        textOutput(outputId = "fish_size_caption"),
                        width = 10
                    )
                )
            ),
            tabItem(
                tabName = "page_3-2",
                h2("Fish Biomass Explorer"),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                sidebarLayout(
                    sidebarPanel(
                        width = 2,
                        pickerInput(
                            inputId = "fish_biomass_choose_locality",
                            label = "Select Localities:",
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
                            inputId = "fish_biomass_choose_year",
                            label = "Select Years:",
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
                            inputId = "fish_biomass_xaxis_toggle",
                            label = "Select X-Axis:",
                            choices = c("Locality", "Year"),
                            selected = "Locality",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        ),
                        prettyRadioButtons(
                            inputId = "fish_biomass_group_toggle",
                            label = "Select Group:",
                            choices = c("Locality", "Year"),
                            selected = "Year",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        ),
                        prettyRadioButtons(
                            inputId = "fish_biomass_reef_toggle",
                            label = "Select Reef Type:",
                            choices = c("All" = "All", "Backreef" = "Backreef", "Deep Forereef" = "Deep_Forereef", "Shallow Forereef" = "Shallow_Forereef"),
                            selected = "All",
                            outline = TRUE,
                            status = "primary",
                            icon = icon("check")
                        )
                    ),
                    mainPanel(
                        plotOutput(outputId = "fish_biomass_plot", height = "1100px") %>%
                            withSpinner(type = 8, color = palette[4]),
                        textOutput(outputId = "fish_biomass_caption"),
                        width = 10
                    )
                )
            ),
            tabItem(
                tabName = "page_3-3",
                h2("Fish Observations Explorer"),
                tabsetPanel(
                    tabPanel(
                        h3("Transect-Level"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        sidebarLayout(
                            sidebarPanel(
                                width = 2,
                                pickerInput(
                                    inputId = "fish_count_choose_locality",
                                    label = "Select Localities:",
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
                                    inputId = "fish_count_choose_year",
                                    label = "Select Years:",
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
                                    inputId = "fish_count_xaxis_toggle",
                                    label = "Select X-Axis:",
                                    choices = c(fish_choices[1:2], fish_choices[4]),
                                    selected = "Year",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
                                ),
                                prettyRadioButtons(
                                    inputId = "fish_count_means_toggle",
                                    label = "Select Group for Mean:",
                                    choices = fish_choices[1:2],
                                    selected = "Locality",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
                                )
                            ),
                            mainPanel(
                                plotOutput(outputId = "fish_count_plot", height = "1000px") %>%
                                    withSpinner(type = 8, color = palette[4]),
                                textOutput(outputId = "fish_count_caption"),
                                width = 10
                            )
                        )
                    ),
                    tabPanel(
                        h3("Site-Level"),
                        fluidRow(column(width = 12, div(style = "height: 20px;"))),
                        sidebarLayout(
                            sidebarPanel(
                                width = 2,
                                pickerInput(
                                    inputId = "fish_count_site_choose_locality",
                                    label = "Select Localities:",
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
                                    inputId = "fish_count_site_choose_year",
                                    label = "Select Years:",
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
                                    inputId = "fish_count_site_xaxis_toggle",
                                    label = "Select X-Axis:",
                                    choices = fish_choices[1:2],
                                    selected = "Year",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
                                ),
                                prettyRadioButtons(
                                    inputId = "fish_count_site_means_toggle",
                                    label = "Select Group for Mean:",
                                    choices = fish_choices[1:2],
                                    selected = "Locality",
                                    outline = TRUE,
                                    status = "primary",
                                    icon = icon("check")
                                )
                            ),
                            mainPanel(
                                plotOutput(outputId = "fish_count_site_plot", height = "1000px") %>%
                                    withSpinner(type = 8, color = palette[4]),
                                textOutput(outputId = "fish_count_site_caption"),
                                width = 10
                            )
                        )
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
                div(style = "float:left;", img(src = "images/Turneffe_Map.jpg", class = "responsive-img")),
                fluidRow(column(width = 12, div(style = "height: 20px;"))),
                downloadButton("download_map", "Download Map"),
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
