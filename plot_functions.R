## plot_functions.R

# Load packages ---------------------------
library(ggplot2)

# Create plot of coral cover by year ---------------------------
create_coral_cover_year_plot <- function(data_filtered, input, caption) {
    if (input$coral_cover_year_xaxis_toggle == "Locality") {
        x_axis <- data_filtered$Locality
        group_var <- data_filtered$Year
        group_name <- "Year"
    } else {
        x_axis <- data_filtered$Year
        group_var <- data_filtered$Locality
        group_name <- "Locality"
    }
    base_plot <- ggplot(data_filtered, aes(x = x_axis, y = Percent_Coral)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        labs(caption = caption, y = "Percent Coral Cover", x = input$coral_cover_year_xaxis_toggle) +
        theme_classic() +
        gg_theme +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
    if ((input$coral_cover_year_consolidate_locality & input$coral_cover_year_xaxis_toggle == "Year") | (input$coral_cover_year_consolidate_year & input$coral_cover_year_xaxis_toggle == "Locality")) {
        base_plot +
            stat_summary(fun = mean, geom = "point", shape = 23, fill = "#3B4252", size = 3, position = position_dodge(width = 0.75))
    } else {
        base_plot +
            aes(fill = group_var) +
            stat_summary(aes(fill = group_var), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_fill_manual(name = group_name, values = palette, guide = guide_legend(nrow = 2))
    }
}

# Create plot of coral cover by species ---------------------------
create_coral_cover_species_plot <- function(data_filtered, input, caption) {
    base_plot <- ggplot(data_filtered, aes(x = reorder(Organism, -Percent, FUN = mean), y = Percent)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        labs(caption = caption, y = "Percent Cover", x = "Coral Species Code") +
        theme_classic() +
        gg_theme +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
    if (input$coral_cover_species_color_toggle == "Neither") {
        base_plot +
            stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "#3B4252", position = position_dodge(width = 0.75))
    } else if (input$coral_cover_species_color_toggle == "Locality") {
        base_plot +
            aes(fill = Locality) +
            stat_summary(aes(fill = Locality), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_fill_manual(name = "Locality", values = palette, guide = guide_legend(nrow = 2)) +
            scale_color_manual(values = palette)
    } else {
        base_plot +
            aes(fill = Year) +
            stat_summary(aes(fill = Year), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_fill_manual(name = "Year", values = palette, guide = guide_legend(nrow = 2)) +
            scale_color_manual(values = palette)
    }
}

# Create plot of benthic composition ---------------------------
create_benthic_comp_plot <- function(data_filtered, input) {
    ggplot(data_filtered, aes(x = Year, y = Benthic_Cover, fill = Bucket2_Name)) +
        geom_col() +
        theme_classic() +
        gg_theme +
        labs(y = "Percent Benthic Cover") +
        scale_fill_manual(name = "Group", values = palette, guide = guide_legend(nrow = 2)) +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
}
