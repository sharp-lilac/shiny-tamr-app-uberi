## caption_functions.R

# Source Objects ---------------------------
caption_text <- paste(readLines("text/captions.txt"))

# Load packages ---------------------------
library(stringr)

# Create caption of coral health by year, locality, genus plot ---------------------------
generate_coral_health_caption <- function(input) {
    selected_localities <- paste(input$coral_health_choose_locality, collapse = ", ")
    selected_years <- paste(input$coral_health_choose_year, collapse = ", ")
    selected_genera <- paste(input$coral_health_choose_genus, collapse = ", ")
    caption_text <- paste0(
        "Figure Caption: Boxplot and density plot of coral health (percent of observed coral bodies that are dead) by year, locality, and genus. Data for localities (", selected_localities,
        ") for years (", selected_years, ") and for coral genera (", selected_genera, ") at Turneffe Atoll. ", caption_text[1]
    )
    str_wrap(caption_text, width = 150)
}

# Create caption of coral disease/bleaching by year, locality, genus plot ---------------------------
generate_coral_disease_caption <- function(input) {
    selected_localities <- paste(input$coral_disease_choose_locality, collapse = ", ")
    selected_years <- paste(input$coral_disease_choose_year, collapse = ", ")
    selected_genera <- paste(input$coral_disease_choose_genus, collapse = ", ")
    caption_text <- paste0(
        "Figure Caption: Bar plots of coral disease and bleaching by year, locality, and genus. Data for localities (", selected_localities,
        ") for years (", selected_years, ") and for coral genera (", selected_genera, ") at Turneffe Atoll. ", caption_text[2], caption_text[1]
    )
    str_wrap(caption_text, width = 150)
}

# Create caption of coral size by year, locality, genus plot ---------------------------
generate_coral_size_caption <- function(input) {
    selected_localities <- paste(input$coral_size_choose_locality, collapse = ", ")
    selected_years <- paste(input$coral_size_choose_year, collapse = ", ")
    selected_genera <- paste(input$coral_size_choose_genus, collapse = ", ")
    caption_text <- paste0(
        "Figure Caption: Plot of coral size metrics in centimeters (maximum length, width, and height). Data for localities (", selected_localities,
        ") for years (", selected_years, ") and for coral genera (", selected_genera, ") at Turneffe Atoll. ", caption_text[1]
    )
    str_wrap(caption_text, width = 150)
}

# Create caption of coral cover by year plot ---------------------------
generate_coral_cover_year_caption <- function(input) {
    selected_localities <- paste(input$coral_cover_year_choose_locality, collapse = ", ")
    selected_years <- paste(input$coral_cover_year_choose_year, collapse = ", ")
    if (input$coral_cover_year_consolidate_year) {
        caption_text <- paste0(
            "Figure Caption: Plot of percent coral cover across localities (", selected_localities,
            ") for years (", selected_years, ") at Turneffe Atoll. ", caption_text[1]
        )
    } else {
        caption_text <- paste0(
            "Plot of percent coral cover within localities (", selected_localities,
            ") and across years (", selected_years, ") at Turneffe Atoll. ", caption_text[1]
        )
    }
    str_wrap(caption_text, width = 150)
}

# Create caption of coral cover by species plot ---------------------------
generate_coral_cover_species_caption <- function(input) {
    if (input$coral_cover_species_select_species != "All") {
        selected_species <- input$coral_cover_species_select_species
    } else {
        selected_species <- "most common coral species"
    }
    selected_localities <- paste(input$coral_cover_species_choose_locality, collapse = ", ")
    selected_years <- paste(input$coral_cover_species_choose_year, collapse = ", ")
    caption_text <- paste0(
        "Figure Caption: Plot of percent coral cover by coral species. Data for localities (", selected_localities,
        ") and for years (", selected_years, ") for ", selected_species, " at Turneffe Atoll. ", caption_text[1]
    )
    str_wrap(caption_text, width = 150)
}

# Create caption of benthic composition plot ---------------------------
generate_benthic_comp_caption <- function(input) {
    selected_localities <- paste(input$coral_cover_species_choose_locality, collapse = ", ")
    selected_years <- paste(input$coral_cover_species_choose_year, collapse = ", ")
    group_name <- tolower(input$benthic_comp_xaxis_toggle)
    reef_name <- tolower(input$benthic_comp_reef_toggle)
    caption_text <- paste0(
        "Figure Caption: Plot of benthic composition by ", group_name, ". Data for localities (", selected_localities,
        ") and for years (", selected_years, ") at Turneffe Atoll (Reef type = ", reef_name, "). ", caption_text[1]
    )
    str_wrap(caption_text, width = 150)
}

# Create caption of fish size plot ---------------------------
generate_fish_size_caption <- function(input) {
    selected_localities <- paste(input$fish_size_choose_locality, collapse = ", ")
    selected_years <- paste(input$fish_size_choose_year, collapse = ", ")
    selected_fish <- paste(input$fish_size_choose_family, collapse = ", ")
    axis_name <- tolower(reverse_fish_choices[input$fish_size_xaxis_toggle])
    means_name <- tolower(reverse_fish_choices[input$fish_size_means_toggle])
    caption_text <- paste0(
        "Figure Caption: Plot of fish size by ", axis_name, ". Data for localities (", selected_localities,
        ") and for years (", selected_years, ") for fish families ( ", selected_fish, ") at Turneffe Atoll. Means of ", means_name, " are shown by colored diamonds. ",
        caption_text[3], caption_text[1]
    )
    str_wrap(caption_text, width = 150)
}
