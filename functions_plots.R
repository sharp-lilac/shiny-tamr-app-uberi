## functions_plots.R

# Load packages ---------------------------
library(ggplot2)
library(ggpubr)
library(grid)
library(lubridate)

# Create function to compute outliers ---------------------------
get_outliers <- function(values) {
    stats <- boxplot.stats(values)
    return(stats$out)
}

# Create function to generate grouped echart boxplot ---------------------------
# Credit to @munoztd0 (GitHub) for function
e_boxplot_group <- function(e, serie, name = NULL, outliers = TRUE, ...) {
    if (missing(serie)) {
        stop("must pass serie", call. = FALSE)
    }

    # Prepare group names
    group_names <- if (!is.null(name)) name else names(e$x$data)

    # Reset series
    e$x$opts$series <- list()

    # Prepare categories from all data groups
    categories <- unique(unlist(lapply(e$x$data, function(data) data[[e$x$mapping$x]])))

    # Iterate through groups
    for (i in seq_along(e$x$data)) {
        current_data <- e$x$data[[i]]

        # Calculate boxplot stats for each category
        category_boxplots <- lapply(categories, function(cat) {
            if (cat %in% current_data[[e$x$mapping$x]]) {
                cat_data <- current_data[current_data[[e$x$mapping$x]] == cat, ]
                boxplot.stats(cat_data[[serie]])$stats
            } else {
                # Return an empty boxplot for missing categories
                rep(NA, 5)
            }
        })

        # Add series for the group
        series_item <- list(
            name = group_names[i],
            type = "boxplot",
            data = category_boxplots
        )
        e$x$opts$series[[i]] <- series_item
    }

    # Set x-axis categories
    e$x$opts$xAxis[[1]]$data <- categories
    e$x$opts$xAxis[[1]]$type <- "category"

    # Add legend
    e$x$opts$legend$data <- as.list(group_names)
    e$x$opts$legend$show <- TRUE
    e
}



# Create plot of coral health by year, locality, species ---------------------------
create_coral_health_plot <- function(data_filtered, input) {
    group_name <- input$coral_health_group_toggle
    plot1 <- ggplot(data_filtered, aes(x = !!sym(group_name), y = Dead, fill = !!sym(group_name))) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        theme(legend.position = "none") +
        labs(y = "% Coral Structure Dead") +
        stat_summary(fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = "")) +
        ylim(min = 0, max = 100) +
        scale_fill_manual(values = palette) +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
    plot2 <- ggplot(data_filtered, aes(x = Dead)) +
        geom_density(aes(color = !!sym(group_name)), size = 1) +
        theme_classic() +
        gg_theme +
        labs(y = "Proportion", x = "% Coral Structure Dead") +
        scale_x_continuous(breaks = seq(0, 100, by = 10)) +
        xlim(min = 0, max = 100) +
        scale_color_manual(values = palette) +
        guides(color = guide_legend(nrow = 4, byrow = TRUE))
    ggarrange(plot1, plot2, nrow = 2, heights = c(0.75, 1))
}

# Create plot of coral disease/bleaching by year, locality, species ---------------------------
create_coral_disease_plot <- function(data_filtered_1, data_filtered_2, data_filtered_3, data_filtered_4, input) {
    create_plot <- function(data, x_var, y_var, x_label, y_label, fill_var) {
        ggplot(data, aes_string(x = x_var, y = y_var, fill = fill_var)) +
            geom_col() +
            theme_classic() +
            gg_theme +
            theme(axis.text.x = element_text(face = "bold", angle = 90, vjust = 1, hjust = 1, size = 14)) +
            labs(x = "", y = y_label) +
            scale_fill_manual(values = palette, name = "") +
            theme(legend.position = "none") +
            scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = "")) +
            guides(fill = guide_legend(nrow = 4, byrow = TRUE))
    }
    plot1 <- create_plot(data_filtered_1, "Bleaching.x", "Percent", "Bleaching Status", "Percent of Corals", "Bleaching.x")
    plot2 <- create_plot(data_filtered_2, "Bleaching.x", "Percent", "Bleaching Status", "Percent of Bleached Corals", "Bleaching.x")
    plot3 <- create_plot(data_filtered_3, "Name", "Percent", "Disease", "Percent of Corals", "Name")
    plot4 <- create_plot(data_filtered_4, "Name", "Percent", "Disease", "Percent of Diseased Coral", "Name") + theme(plot.margin = margin(b = 80))
    plot_group1 <- ggarrange(plot1, plot2, nrow = 1)
    plot_group2 <- ggarrange(plot3, plot4, nrow = 1)
    ggarrange(plot_group1, plot_group2, nrow = 2)
}

# Create plot of coral size by year, locality, species ---------------------------
create_coral_size_plot <- function(data_filtered, input) {
    group_name <- input$coral_size_xaxis_toggle
    ggplot(data_filtered, aes(x = !!sym(group_name), y = Size, fill = Metric)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Coral Size (cm)") +
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
        scale_y_continuous(breaks = seq(0, 500, by = 25), sec.axis = dup_axis(name = "")) +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
}

# Create plot of coral cover by year ---------------------------
create_coral_cover_year_plot <- function(data_filtered, input) {
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
        labs(y = "Percent Coral Cover", x = input$coral_cover_year_xaxis_toggle) +
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
            scale_fill_manual(name = group_name, values = palette) +
            guides(fill = guide_legend(nrow = 4, byrow = TRUE))
    }
}

# Create plot of coral cover by species ---------------------------
create_coral_cover_species_plot <- function(data_filtered, input) {
    base_plot <- ggplot(data_filtered, aes(x = reorder(Organism, -Percent, FUN = mean), y = Percent)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        labs(y = "Percent Cover", x = "Coral Species Code") +
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
            scale_color_manual(values = palette) +
            guides(fill = guide_legend(nrow = 4, byrow = TRUE)) +
            guides(color = guide_legend(nrow = 4, byrow = TRUE))
    } else {
        base_plot +
            aes(fill = Year) +
            stat_summary(aes(fill = Year), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
            scale_fill_manual(name = "Year", values = palette) +
            scale_color_manual(values = palette) +
            guides(fill = guide_legend(nrow = 4, byrow = TRUE)) +
            guides(color = guide_legend(nrow = 4, byrow = TRUE))
    }
}

# Create plot of benthic composition ---------------------------
create_benthic_comp_plot <- function(data_filtered, input) {
    group_name <- input$benthic_comp_xaxis_toggle
    cat_name <- input$benthic_comp_cat_toggle
    ggplot(data_filtered, aes(x = !!sym(group_name), y = Benthic_Cover, fill = !!sym(cat_name))) +
        geom_col() +
        theme_classic() +
        gg_theme +
        labs(y = "Percent Benthic Cover") +
        scale_fill_manual(name = "", values = palette) +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = "")) +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
}

# Create plot of fish size ---------------------------
create_fish_size_plot <- function(data_filtered, input) {
    axis_name <- input$fish_size_xaxis_toggle
    axis_label <- reverse_fish_choices[input$fish_size_xaxis_toggle]
    means_name <- input$fish_size_means_toggle
    means_label <- reverse_fish_choices[input$fish_size_means_toggle]
    ggplot(data_filtered, aes(x = as.factor(!!sym(axis_name)), y = Length)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Fish Length (cm)", x = axis_label) +
        scale_fill_manual(name = means_label, values = palette) +
        stat_summary(aes(fill = !!sym(means_name)), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = "")) +
        geom_hline(yintercept = 7.5, linetype = "dashed") +
        geom_hline(yintercept = 2.5, linetype = "dashed") +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
}

# Create plot of fish biomass ---------------------------
create_fish_biomass_plot <- function(data_filtered_1, data_filtered_2, input) {
    axis_name <- input$fish_biomass_xaxis_toggle
    group_name <- input$fish_biomass_group_toggle
    reef_name <- input$fish_biomass_reef_toggle
    plot1 <- ggplot(data_filtered_1, aes(x = as.factor(!!sym(axis_name)), y = Biomass_g_per_100m2_Transect, fill = as.factor(!!sym(group_name)))) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Commercial Fish Biomass (g/100m2)", x = axis_name) +
        scale_fill_manual(values = palette) +
        stat_summary(aes(fill = as.factor(!!sym(group_name))), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 30000, by = 5000), sec.axis = dup_axis(name = "")) +
        theme(legend.position = "none")
    plot2 <- ggplot(data_filtered_2, aes(x = as.factor(!!sym(axis_name)), y = Biomass_g_per_100m2_Transect, fill = as.factor(!!sym(group_name)))) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Herbivorous Fish Biomass (g/100m2)", x = axis_name) +
        scale_fill_manual(name = group_name, values = palette) +
        stat_summary(aes(fill = as.factor(!!sym(group_name))), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 30000, by = 5000), sec.axis = dup_axis(name = "")) +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
    ggarrange(plot1, plot2, nrow = 2, heights = c(0.75, 1))
}

# Create plot of fish count (transect-level) ---------------------------
create_fish_count_plot <- function(data_filtered, input) {
    axis_name <- input$fish_count_xaxis_toggle
    axis_label <- reverse_fish_choices[input$fish_count_xaxis_toggle]
    means_name <- input$fish_count_means_toggle
    plot1 <- ggplot(data_filtered, aes(x = as.factor(!!sym(axis_name)), y = Count)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Number Fish / Transect", x = "") +
        scale_fill_manual(name = means_name, values = palette) +
        stat_summary(aes(fill = !!sym(means_name)), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 500, by = 50), sec.axis = dup_axis(name = "")) +
        theme(legend.position = "none")
    plot2 <- ggplot(data_filtered, aes(x = as.factor(!!sym(axis_name)), y = Richness)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Fish Species / Transect", x = axis_label) +
        scale_fill_manual(name = means_name, values = palette) +
        stat_summary(aes(fill = !!sym(means_name)), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 30, by = 5), sec.axis = dup_axis(name = "")) +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
    ggarrange(plot1, plot2, nrow = 2, heights = c(0.75, 1))
}

# Create plot of fish count (site-level) ---------------------------
create_fish_count_site_plot <- function(data_filtered, input) {
    axis_name <- input$fish_count_site_xaxis_toggle
    means_name <- input$fish_count_site_means_toggle
    plot1 <- ggplot(data_filtered, aes(x = !!sym(axis_name), y = Count)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Number Fish / Site", x = "") +
        scale_fill_manual(name = means_name, values = palette) +
        stat_summary(aes(fill = !!sym(means_name)), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 2000, by = 100), sec.axis = dup_axis(name = "")) +
        theme(legend.position = "none")
    plot2 <- ggplot(data_filtered, aes(x = !!sym(axis_name), y = Richness)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        theme_classic() +
        gg_theme +
        labs(y = "Fish Species / Site", x = axis_name) +
        scale_fill_manual(name = means_name, values = palette) +
        stat_summary(aes(fill = !!sym(means_name)), fun = mean, geom = "point", shape = 23, size = 3, position = position_dodge(width = 0.75)) +
        scale_y_continuous(breaks = seq(0, 50, by = 5), sec.axis = dup_axis(name = "")) +
        coord_cartesian(ylim = c(0, 50)) +
        guides(fill = guide_legend(nrow = 4, byrow = TRUE))
    ggarrange(plot1, plot2, nrow = 2, heights = c(0.75, 1))
}
