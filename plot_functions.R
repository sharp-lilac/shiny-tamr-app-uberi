## plot_functions.R

# Load packages ---------------------------
library(ggplot2)
library(ggpubr)

# Create plot of coral health by year, locality, species ---------------------------
create_coral_health_plot <- function(data_filtered, input) {
    plot1 <- ggplot(df_coral_health, aes(x = Year, y = Dead)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Percent of the Coral Structure Dead") +
        stat_summary(fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = "")) +
        ylim(min = 0, max = 100)
    plot2 <- ggplot(df_coral_health, aes(x = Dead)) +
        geom_density(aes(color = Year), size = 1) +
        theme_classic() +
        gg_theme +
        labs(y = "Proportion of Observations", x = "Percent of the Coral Structure Dead") +
        scale_x_continuous(breaks = seq(0, 100, by = 10)) +
        xlim(min = 0, max = 100) +
        scale_color_manual(values = palette)
    ggarrange(plot1, plot2, nrow = 2)
}

# Create plot of coral size by year, locality, species ---------------------------
create_coral_size_plot <- function(data_filtered, input, caption) {
    group_name <- input$coral_size_xaxis_toggle
    ggplot(data_filtered, aes(x = !!sym(group_name), y = Size, fill = Metric)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(caption = caption, y = "Coral Size (cm)") +
        scale_fill_manual(
            name = "Size Metric",
            values = palette,
            labels = c(
                "Max_Width" = "Max Width",
                "Max_Height" = "Max Height",
                "Max_Length" = "Max Length"
            )
        ) +
        stat_summary(aes(fill = Metric), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 500, by = 25), sec.axis = dup_axis(name = ""))
}

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
            scale_fill_manual(name = group_name, values = palette)
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
            scale_fill_manual(name = "Locality", values = palette) +
            scale_color_manual(values = palette)
    } else {
        base_plot +
            aes(fill = Year) +
            stat_summary(aes(fill = Year), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_fill_manual(name = "Year", values = palette) +
            scale_color_manual(values = palette)
    }
}

# Create plot of benthic composition ---------------------------
create_benthic_comp_plot <- function(data_filtered, input, caption) {
    group_name <- input$benthic_comp_xaxis_toggle
    cat_name <- input$benthic_comp_cat_toggle
    ggplot(data_filtered, aes(x = !!sym(group_name), y = Benthic_Cover, fill = !!sym(cat_name))) +
        geom_col() +
        theme_classic() +
        gg_theme +
        labs(y = "Percent Benthic Cover", caption = caption) +
        scale_fill_manual(name = group_name, values = palette) +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
}
