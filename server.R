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
        data_filtered <- create_tran_org_summary("AGRRA_Bucket", "Coral") %>%
            filter(Locality %in% input$coral_cover_year_choose_locality) %>%
            filter(Year %in% input$coral_cover_year_choose_year)
        if (input$coral_cover_year_consolidate_year) {
            selected_years <- paste(input$coral_cover_year_choose_year, collapse = ", ")
            data_filtered <- data_filtered %>%
                mutate(Year = selected_years)
        }
        caption <- coral_cover_year_plot_caption()
        create_coral_cover_year_plot(data_filtered, input, caption)
    })
    # Coral cover by species plot
    output$coral_cover_species_plot <- renderPlot({
        ggplot(data = create_tran_org_summary("AGRRA_Bucket", "Coral"), aes(x = Locality, y = Percent))
    })
})
