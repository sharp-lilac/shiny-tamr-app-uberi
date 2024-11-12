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
    # Coral health by year, locality, genus plot
    coral_health_plot_caption <- reactive({
        generate_coral_health_caption(input)
    })
    output$coral_health_plot <- renderPlot({
        req(input$coral_health_choose_locality)
        req(input$coral_health_choose_year)
        req(input$coral_health_choose_genus)
        group_name <- input$coral_health_group_toggle
        data_filtered <- df_coral_health %>%
            filter(
                Locality %in% input$coral_health_choose_locality,
                Year %in% input$coral_health_choose_year,
                Genus %in% input$coral_health_choose_genus
            )
        create_coral_health_plot(data_filtered, input, coral_health_plot_caption())
    })
    # Coral disease and bleaching pie charts
    coral_disease_plot_caption <- reactive({
        generate_coral_disease_caption(input)
    })
    output$coral_disease_plot <- renderPlot({
        req(input$coral_disease_choose_locality)
        req(input$coral_disease_choose_year)
        req(input$coral_disease_choose_genus)
        data_filtered <- df_coral_disease %>%
            filter(Locality %in% input$coral_disease_choose_locality, Year %in% input$coral_disease_choose_year, Genus %in% input$coral_disease_choose_genus)
        data_filtered_1 <- data_filtered %>%
            filter(!is.na(Bleaching.x)) %>%
            mutate(Bleaching.x = case_when(
                Bleaching.x %in% c("Pale", "Pale Bleached  ", "Bleached") ~ "Bleaching Signs",
                Bleaching.x == "Unbleached" ~ "Unbleached",
                TRUE ~ "Unknown"
            )) %>%
            group_by(Bleaching.x) %>%
            summarise(Count = n()) %>%
            mutate(Percent = round(Count / sum(Count) * 100))
        data_filtered_2 <- data_filtered %>%
            filter(Bleaching.x != "Unbleached" & Bleaching.x != "Unknown") %>%
            group_by(Bleaching.x) %>%
            summarise(Count = n()) %>%
            mutate(Percent = round(Count / sum(Count) * 100))
        data_filtered_3 <- data_filtered %>%
            filter(Name != "NA") %>%
            mutate(Name = case_when(Name == "No disease" ~ "No disease", TRUE ~ paste0(strrep(" ", 40), "Disease"))) %>%
            group_by(Name) %>%
            summarise(Count = n()) %>%
            mutate(Percent = (Count / sum(Count) * 100))
        data_filtered_4 <- data_filtered %>%
            filter(Name != "No disease" & Name != "NA") %>%
            group_by(Name) %>%
            summarise(Count = n()) %>%
            mutate(Percent = round(Count / sum(Count) * 100))
        create_coral_disease_plot(data_filtered_1, data_filtered_2, data_filtered_3, data_filtered_4, input, coral_disease_plot_caption())
    })
    # Coral size by year, locality, genus plot
    coral_size_plot_caption <- reactive({
        generate_coral_size_caption(input)
    })
    output$coral_size_plot <- renderPlot({
        req(input$coral_size_choose_locality)
        req(input$coral_size_choose_year)
        req(input$coral_size_choose_genus)
        group_name <- input$coral_size_xaxis_toggle
        data_filtered <- df_coral_size %>%
            filter(Locality %in% input$coral_size_choose_locality, Year %in% input$coral_size_choose_year, Genus %in% input$coral_size_choose_genus)
        create_coral_size_plot(data_filtered, input, coral_size_plot_caption())
    })
    # Coral cover by year plot
    coral_cover_year_plot_caption <- reactive({
        generate_coral_cover_year_caption(input)
    })
    output$coral_cover_year_plot <- renderPlot({
        req(input$coral_cover_year_choose_locality)
        req(input$coral_cover_year_choose_year)
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
        req(input$coral_cover_species_choose_locality)
        req(input$coral_cover_species_choose_year)
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
        reef_name <- input$benthic_comp_reef_toggle
        df_benthic_percents_filtered <- df_benthic_percents %>%
            filter(
                Locality %in% input$benthic_comp_choose_locality,
                Year %in% input$benthic_comp_choose_year,
                (Zone == reef_name | reef_name == "All")
            )
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
    # Fish size plot
    fish_size_plot_caption <- reactive({
        generate_fish_size_caption(input)
    })
    output$fish_size_plot <- renderPlot({
        req(input$fish_size_choose_locality)
        req(input$fish_size_choose_year)
        req(input$fish_size_choose_family)
        axis_name <- input$fish_size_xaxis_toggle
        means_name <- input$fish_size_means_toggle
        df_master_fish_size$Year <- as.factor(df_master_fish_size$Year)
        data_filtered <- df_master_fish_size %>%
            filter(
                Locality %in% input$fish_size_choose_locality,
                Year %in% input$fish_size_choose_year,
                Fish_Family %in% input$fish_size_choose_family
            ) %>%
            mutate(
                Start_Time = if_else(Start_Time == "MISSING", NA, Start_Time),
                Start_Time = hour(hm(Start_Time)),
                Start_Time = if_else(Start_Time == 23, 11, Start_Time) # fix error of 2023 fish from 11am being 11pm
            )
        create_fish_size_plot(data_filtered, input, fish_size_plot_caption())
    })
    # Fish count and richness plot by transect
    output$fish_count_plot <- renderPlot({
        df_master_fish_count$Year <- as.factor(df_master_fish_count$Year)
        plot1 <- ggplot(df_master_fish_count, aes(x = Year, y = Count)) +
            geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
            theme_classic() +
            gg_theme +
            labs(y = "Number Fish / Transect", x = "") +
            scale_fill_manual(name = "Locality", values = palette) +
            stat_summary(aes(fill = Locality), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_y_continuous(breaks = seq(0, 500, by = 50), sec.axis = dup_axis(name = "")) +
            theme(legend.position = "none")

        plot2 <- ggplot(df_master_fish_count, aes(x = Year, y = Richness)) +
            geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
            theme_classic() +
            gg_theme +
            labs(caption = "66 fish species MBRS, 72 AGRRA", y = "Fish Species / Transect", x = "Year") +
            scale_fill_manual(name = "Locality", values = palette) +
            stat_summary(aes(fill = Locality), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_y_continuous(breaks = seq(0, 30, by = 5), sec.axis = dup_axis(name = ""))

        ggarrange(plot1, plot2, nrow = 2, heights = c(0.75, 1))
    })
    # Fish count and richness plot by site
    output$fish_count_site_plot <- renderPlot({
        df_master_fish_count_site$Year <- as.factor(df_master_fish_count_site$Year)
        plot1 <- ggplot(df_master_fish_count_site, aes(x = Year, y = Count)) +
            geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
            theme_classic() +
            gg_theme +
            labs(y = "Number Fish / Site", x = "") +
            scale_fill_manual(name = "Locality", values = palette) +
            stat_summary(aes(fill = Locality), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_y_continuous(breaks = seq(0, 2000, by = 100), sec.axis = dup_axis(name = "")) +
            theme(legend.position = "none")

        plot2 <- ggplot(df_master_fish_count_site, aes(x = Year, y = Richness)) +
            geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
            theme_classic() +
            gg_theme +
            labs(caption = "66 fish species MBRS, 72 AGRRA", y = "Fish Species / Site", x = "Year") +
            scale_fill_manual(name = "Locality", values = palette) +
            stat_summary(aes(fill = Locality), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_y_continuous(breaks = seq(0, 50, by = 5), sec.axis = dup_axis(name = "")) +
            coord_cartesian(ylim = c(0, 50))

        ggarrange(plot1, plot2, nrow = 2, heights = c(0.75, 1))

        # need to standardize by num transects per site - maybe only sites with certain num transects?
    })

    # Download map
    output$download_map <- downloadHandler(
        filename = function() {
            "Turneffe_Map.jpg"
        },
        content = function(file) {
            file.copy("www/images/Turneffe_Map.jpg", file)
        }
    )
})
