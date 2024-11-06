## server.R

# Load packages ---------------------------
library(shiny)

# Source objects ---------------------------
source("theme.R")
source("data_prepare.R")
source("plot_functions.R")
source("caption_functions.R")

# Define server ---------------------------
shinyServer(function(input, output) {
    # Coral cover by year plot
    coral_cover_year_plot_caption <- reactive({
        generate_coral_cover_year_caption(input)
    })
    output$coral_cover_year_plot <- renderPlot({
        data_filtered <- df_benthic_percents_coral %>%
            filter(Locality %in% input$coral_cover_year_choose_locality, Year %in% input$coral_cover_year_choose_year)
        if (input$coral_cover_year_consolidate_year) {
            data_filtered <- mutate(data_filtered, Year = paste(input$coral_cover_year_choose_year, collapse = ", "))
        }
        create_coral_cover_year_plot(data_filtered, input, coral_cover_year_plot_caption())
    })
    # Coral cover by species plot
    output$coral_cover_species_plot <- renderPlot({
        data_filtered <- df_benthic_percents %>%
            filter(AGRRA_Bucket == "Coral")
        create_coral_cover_species_plot(data_filtered)
    })
})
