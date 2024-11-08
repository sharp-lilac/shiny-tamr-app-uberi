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
        if (input$coral_cover_year_consolidate_locality) {
            data_filtered <- mutate(data_filtered, Locality = paste(input$coral_cover_year_choose_locality, collapse = ", "))
        }
        create_coral_cover_year_plot(data_filtered, input, coral_cover_year_plot_caption())
    })
    # Coral cover by species plot
    coral_cover_species_plot_caption <- reactive({
        generate_coral_cover_species_caption(input)
    })
    output$coral_cover_species_plot <- renderPlot({
        data_filtered <- df_benthic_percents %>%
            filter(AGRRA_Bucket == "Coral", !is.na(Species)) %>%
            filter(Locality %in% input$coral_cover_species_choose_locality, Year %in% input$coral_cover_species_choose_year)
        if (input$coral_cover_species_select_species != "All") {
            data_filtered <- data_filtered %>%
                filter(Species == input$coral_cover_species_select_species)
        }
        top_organisms <- data_filtered %>%
            group_by(Organism) %>%
            summarize(Mean = mean(Percent, na.rm = TRUE)) %>%
            arrange(desc(Mean)) %>%
            slice_head(n = input$coral_cover_species_max_species) %>%
            pull(Organism)
        data_filtered <- data_filtered %>%
            filter(Organism %in% top_organisms)
        create_coral_cover_species_plot(data_filtered, input, coral_cover_species_plot_caption())
    })
    output$coral_cover_species_table <- DT::renderDataTable({
        df_ref_organisms %>%
            filter(AGRRA_Bucket == "Coral", !is.na(Species)) %>%
            select(Organism, Genus, Species) %>%
            DT::datatable(options = list(pageLength = 10, autoWidth = TRUE))
    })
    # Benthic composition plot
    benthic_comp_plot_caption <- reactive({
        generate_benthic_comp_caption(input)
    })
    output$benthic_comp_plot <- renderPlot({
        req(input$benthic_comp_choose_locality)
        req(input$benthic_comp_choose_year)
        group_name <- input$benthic_comp_xaxis_toggle
        cat_name <- input$benthic_comp_cat_toggle
        df_benthic_percents_filtered <- df_benthic_percents %>%
            filter(Locality %in% input$benthic_comp_choose_locality, Year %in% input$benthic_comp_choose_year)
        data_filtered <- df_benthic_percents_filtered %>%
            group_by(across(all_of(group_name))) %>%
            summarize(Group_Count = sum(Count)) %>%
            right_join(df_benthic_percents_filtered, by = group_name) %>%
            group_by(across(all_of(group_name)), !!sym(cat_name)) %>%
            summarize(
                Group_Organism_Count = sum(Count),
                Benthic_Cover = Group_Organism_Count / unique(Group_Count) * 100
            ) %>%
            ungroup()
        create_benthic_comp_plot(data_filtered, input, benthic_comp_plot_caption())
    })
})
