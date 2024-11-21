## server.R

# Load packages ---------------------------
library(shiny)
library(mailR)

# Source objects ---------------------------
source("theme.R")
source("data_prepare.R")
source("functions_plots.R")
source("functions_captions.R")
home_text <- paste(readLines("text/home.txt"))

# Define server ---------------------------
shinyServer(function(input, output, session) {
    # Quick tab change
    observeEvent(input$coral_explorer_nav, {
        updateTabItems(session, inputId = "tabs", selected = "page_1-2")
    })
    observeEvent(input$benthic_explorer_nav, {
        updateTabItems(session, inputId = "tabs", selected = "page_2")
    })
    observeEvent(input$fish_explorer_nav, {
        updateTabItems(session, inputId = "tabs", selected = "page_3-1")
    })
    # Show more buttons
    show_more_text_value1 <- reactiveVal(FALSE)
    observeEvent(input$show_more1, {
        show_more_text_value1(!show_more_text_value1())
    })
    output$show_more_text1 <- renderUI({
        if (show_more_text_value1()) {
            tagList(
                p(home_text[4]),
                p(home_text[5]),
                p(home_text[6])
            )
        } else {
            NULL
        }
    })
    show_more_text_value2 <- reactiveVal(FALSE)
    observeEvent(input$show_more2, {
        show_more_text_value2(!show_more_text_value2())
    })
    output$show_more_text2 <- renderUI({
        if (show_more_text_value2()) {
            tagList(
                p(home_text[8]),
                p(home_text[9]),
                p(home_text[10]),
                p(home_text[11])
            )
        } else {
            NULL
        }
    })
    # Key data summary Boxes
    output$number_collectors_box <- renderInfoBox({
        infoBox(collectors_count, "Data Collectors", icon = shiny::icon(NULL))
    })
    output$number_years_box <- renderInfoBox({
        infoBox(years_count, "Years of Data", icon = shiny::icon(NULL))
    })
    output$number_sites_box <- renderInfoBox({
        infoBox(sites_count, "Sites Sampled", icon = shiny::icon(NULL))
    })
    # Coral health by year, locality, genus plot
    coral_health_plot_caption <- reactive({
        generate_coral_health_caption(input)
    })
    output$coral_health_caption <- renderText({
        coral_health_plot_caption()
    })
    coral_health_plot <- reactive({
        req(input$coral_health_choose_locality, input$coral_health_choose_year, input$coral_health_choose_genus)
        data_filtered <- df_coral_health %>%
            filter(Locality %in% input$coral_health_choose_locality, Year %in% input$coral_health_choose_year, Genus %in% input$coral_health_choose_genus)
        create_coral_health_plot(data_filtered, input)
    })
    output$coral_health_plot <- renderPlot({
        coral_health_plot()
    })
    # Coral disease and bleaching pie charts
    coral_disease_plot_caption <- reactive({
        generate_coral_disease_caption(input)
    })
    output$coral_disease_caption <- renderText({
        coral_disease_plot_caption()
    })
    coral_disease_plot <- reactive({
        req(input$coral_disease_choose_locality, input$coral_disease_choose_year, input$coral_disease_choose_genus)
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
            mutate(Name = case_when(Name == "No Disease" ~ "No Disease", TRUE ~ paste0(strrep(" ", 40), "Disease"))) %>%
            group_by(Name) %>%
            summarise(Count = n()) %>%
            mutate(Percent = (Count / sum(Count) * 100))
        data_filtered_4 <- data_filtered %>%
            filter(Name != "No Disease" & Name != "NA") %>%
            group_by(Name) %>%
            summarise(Count = n()) %>%
            mutate(Percent = round(Count / sum(Count) * 100))
        create_coral_disease_plot(data_filtered_1, data_filtered_2, data_filtered_3, data_filtered_4, input)
    })
    output$coral_disease_plot <- renderPlot({
        coral_disease_plot()
    })
    # Coral size by year, locality, genus plot
    coral_size_plot_caption <- reactive({
        generate_coral_size_caption(input)
    })
    output$coral_size_caption <- renderText({
        coral_size_plot_caption()
    })
    coral_size_plot <- reactive({
        req(input$coral_size_choose_locality, input$coral_size_choose_year, input$coral_size_choose_genus)
        data_filtered <- df_coral_size %>%
            filter(Locality %in% input$coral_size_choose_locality, Year %in% input$coral_size_choose_year, Genus %in% input$coral_size_choose_genus)
        create_coral_size_plot(data_filtered, input)
    })
    output$coral_size_plot <- renderPlot({
        coral_size_plot()
    })
    # Coral cover by year plot
    coral_cover_year_plot_caption <- reactive({
        generate_coral_cover_year_caption(input)
    })
    output$coral_cover_year_caption <- renderText({
        coral_cover_year_plot_caption()
    })
    coral_cover_year_plot <- reactive({
        req(input$coral_cover_year_choose_locality, input$coral_cover_year_choose_year)
        data_filtered <- df_benthic_percents_coral %>%
            filter(Locality %in% input$coral_cover_year_choose_locality, Year %in% input$coral_cover_year_choose_year)
        if (input$coral_cover_year_consolidate_year) {
            data_filtered <- mutate(data_filtered, Year = paste(input$coral_cover_year_choose_year, collapse = ", "))
        }
        if (input$coral_cover_year_consolidate_locality) {
            data_filtered <- mutate(data_filtered, Locality = paste(input$coral_cover_year_choose_locality, collapse = ", "))
        }
        create_coral_cover_year_plot(data_filtered, input)
    })
    output$coral_cover_year_plot <- renderPlot({
        coral_cover_year_plot()
    })
    # Coral cover by species plot
    coral_cover_species_plot_caption <- reactive({
        generate_coral_cover_species_caption(input)
    })
    output$coral_cover_species_caption <- renderText({
        coral_cover_species_plot_caption()
    })
    coral_cover_species_plot <- reactive({
        req(input$coral_cover_species_choose_locality, input$coral_cover_species_choose_year)
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
        create_coral_cover_species_plot(data_filtered, input)
    })
    output$coral_cover_species_plot <- renderPlot({
        coral_cover_species_plot()
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
    output$benthic_comp_caption <- renderText({
        benthic_comp_plot_caption()
    })
    benthic_comp_plot <- reactive({
        req(input$benthic_comp_choose_locality, input$benthic_comp_choose_year)
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
        create_benthic_comp_plot(data_filtered, input)
    })
    output$benthic_comp_plot <- renderPlot({
        benthic_comp_plot()
    })
    # Fish size plot
    fish_size_plot_caption <- reactive({
        generate_fish_size_caption(input)
    })
    output$fish_size_caption <- renderText({
        fish_size_plot_caption()
    })
    fish_size_plot <- reactive({
        req(input$fish_size_choose_locality, input$fish_size_choose_year, input$fish_size_choose_family)
        df_master_fish_size$Year <- as.factor(df_master_fish_size$Year)
        data_filtered <- df_master_fish_size %>%
            filter(Locality %in% input$fish_size_choose_locality, Year %in% input$fish_size_choose_year, Fish_Family %in% input$fish_size_choose_family) %>%
            mutate(
                Start_Time = if_else(Start_Time == "MISSING", NA, Start_Time),
                Start_Time = hour(hm(Start_Time)),
                Start_Time = if_else(Start_Time == 23, 11, Start_Time)
            )
        create_fish_size_plot(data_filtered, input)
    })
    output$fish_size_plot <- renderPlot({
        fish_size_plot()
    })
    # Fish biomass plot
    fish_biomass_plot_caption <- reactive({
        generate_fish_biomass_caption(input)
    })
    output$fish_biomass_caption <- renderText({
        fish_biomass_plot_caption()
    })
    fish_biomass_plot <- reactive({
        req(input$fish_biomass_choose_locality, input$fish_biomass_choose_year)
        reef_name <- input$fish_biomass_reef_toggle
        df_master_fish_biomass$Year <- as.factor(df_master_fish_biomass$Year)
        df_master_fish_biomass$Locality <- as.factor(df_master_fish_biomass$Locality.x)
        data_filtered <- df_master_fish_biomass %>%
            filter(Locality %in% input$fish_biomass_choose_locality, Year %in% input$fish_biomass_choose_year, (Zone == reef_name | reef_name == "All"))
        data_filtered_1 <- data_filtered %>% filter(Biomass_Category == "C")
        data_filtered_2 <- data_filtered %>% filter(Biomass_Category == "H")
        create_fish_biomass_plot(data_filtered_1, data_filtered_2, input)
    })
    output$fish_biomass_plot <- renderPlot({
        fish_biomass_plot()
    })
    # Fish count and richness plot by transect
    fish_count_plot_caption <- reactive({
        generate_fish_count_caption(input)
    })
    output$fish_count_caption <- renderText({
        fish_count_plot_caption()
    })
    fish_count_plot <- reactive({
        req(input$fish_count_choose_locality, input$fish_count_choose_year)
        df_master_fish_count$Year <- as.factor(df_master_fish_count$Year)
        data_filtered <- df_master_fish_count %>%
            filter(Locality %in% input$fish_count_choose_locality, Year %in% input$fish_count_choose_year) %>%
            mutate(
                Start_Time = if_else(Start_Time == "MISSING", NA, Start_Time),
                Start_Time = hour(hm(Start_Time)),
                Start_Time = if_else(Start_Time == 23, 11, Start_Time)
            )
        create_fish_count_plot(data_filtered, input)
    })
    output$fish_count_plot <- renderPlot({
        fish_count_plot()
    })
    # Fish count and richness plot by site
    fish_count_site_plot_caption <- reactive({
        generate_fish_count_site_caption(input)
    })
    output$fish_count_site_caption <- renderText({
        fish_count_site_plot_caption()
    })
    fish_count_site_plot <- reactive({
        req(input$fish_count_site_choose_locality, input$fish_count_site_choose_year)
        df_master_fish_count_site$Year <- as.factor(df_master_fish_count_site$Year)
        data_filtered <- df_master_fish_count_site %>%
            filter(Transects == 8) %>%
            filter(Locality %in% input$fish_count_site_choose_locality, Year %in% input$fish_count_site_choose_year)
        create_fish_count_site_plot(data_filtered, input)
    })
    output$fish_count_site_plot <- renderPlot({
        fish_count_site_plot()
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
    # Localities Data Table
    output$reef_localities_surveyed_table <- DT::renderDataTable({
        reef_localities_surveyed_table %>%
            DT::datatable(
                caption = HTML(paste(readLines("text/map.txt"))[5]),
                options = list(
                    pageLength = 11,
                    lengthChange = FALSE,
                    searching = FALSE,
                    paging = FALSE,
                    info = FALSE,
                    dom = "t",
                    columnDefs = list(
                        list(targets = 0, visible = FALSE),
                        list(targets = 1, width = "100px"),
                        list(targets = 2, width = "50px"),
                        list(targets = 3, width = "75px"),
                        list(targets = 4, width = "50px"),
                        list(targets = 5, width = "50px"),
                        list(targets = 6, width = "50px")
                    )
                )
            )
    })
    # Download coral health plot
    output$coral_health_download <- downloadHandler(
        filename = function() {
            paste("coral_health_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = coral_health_plot(), width = 15, height = 15)
        }
    )
    # Download coral disease plot
    output$coral_disease_download <- downloadHandler(
        filename = function() {
            paste("coral_disease_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = coral_disease_plot(), width = 15, height = 12)
        }
    )
    # Download coral size explore plot
    output$coral_size_download <- downloadHandler(
        filename = function() {
            paste("coral_size_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = coral_size_plot(), width = 15, height = 8)
        }
    )
    # Download coral over year plot
    output$coral_cover_year_download <- downloadHandler(
        filename = function() {
            paste("coral_cover_year_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = coral_cover_year_plot(), width = 15, height = 8)
        }
    )
    # Download coral cover species plot
    output$coral_cover_species_download <- downloadHandler(
        filename = function() {
            paste("coral_cover_species_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = coral_cover_species_plot(), width = 15, height = 8)
        }
    )
    # Download benthic comp plot
    output$benthic_comp_download <- downloadHandler(
        filename = function() {
            paste("benthic_comp_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = benthic_comp_plot(), width = 15, height = 8)
        }
    )
    # Download fish size plot
    output$fish_size_download <- downloadHandler(
        filename = function() {
            paste("fish_size_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = fish_size_plot(), width = 15, height = 8)
        }
    )
    # Download fish biomass plot
    output$fish_biomass_download <- downloadHandler(
        filename = function() {
            paste("fish_biomass_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = fish_biomass_plot(), width = 18, height = 16)
        }
    )
    # Download fish count plot
    output$fish_count_download <- downloadHandler(
        filename = function() {
            paste("fish_count_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = fish_count_plot(), width = 15, height = 13)
        }
    )
    # Download fish count by site plot
    output$fish_count_site_download <- downloadHandler(
        filename = function() {
            paste("fish_count_site_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            ggsave(file, plot = fish_count_site_plot(), width = 15, height = 13)
        }
    )
    # Manage feedback form
    observeEvent(input$clear_feedback, {
        updateTextAreaInput(session = getDefaultReactiveDomain(), "feedback_text", value = "")
    })

    observeEvent(input$submit_feedback, {
        feedback <- input$feedback_text
        if (nchar(feedback) > 5000) {
            showModal(modalDialog(
                title = "Error",
                "Your feedback exceeds the 5000-character limit. Please shorten it.",
                easyClose = TRUE,
                footer = NULL
            ))
        } else {
            password <- Sys.getenv("EMAIL_PASSWORD")
            sender_email <- Sys.getenv("SENDER_EMAIL")
            recipient_email <- Sys.getenv("RECIPIENT_EMAIL")

            tryCatch(
                {
                    send.mail(
                        from = sender_email,
                        to = recipient_email,
                        subject = "New Feedback: Shiny TAMR",
                        body = feedback,
                        smtp = list(
                            host.name = "smtp.gmail.com", port = 465,
                            user.name = sender_email,
                            passwd = password, ssl = TRUE
                        ),
                        authenticate = TRUE,
                        send = TRUE
                    )
                    showModal(modalDialog(
                        title = "Submitted",
                        "Thank you for your feedback! We have received it.",
                        easyClose = TRUE,
                        footer = NULL
                    ))
                    updateTextAreaInput(session = getDefaultReactiveDomain(), "feedback_text", value = "")
                },
                error = function(e) {
                    showModal(modalDialog(
                        title = "Error",
                        paste("Something went wrong. Please try again later.\nError details: ", e$message),
                        easyClose = TRUE,
                        footer = NULL
                    ))
                }
            )
        }
    })
})
