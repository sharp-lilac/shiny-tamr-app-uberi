## plot_functions.R

# Load packages ---------------------------
library(ggplot2)

# Create plot of coral cover by year ---------------------------
create_coral_cover_year_plot <- function(data_filtered, input, caption) {
    base_plot <- ggplot(data_filtered, aes(x = Year, y = Percent_Coral)) +
        geom_boxplot(color = "black", position = position_dodge(width = 0.75), outlier.shape = 4, outlier.size = 4) +
        stat_summary(fun = mean, geom = "point", shape = 18, size = 3, fill = "#3B4252", position = position_dodge(width = 0.75)) +
        labs(caption = caption, x = "Percent Coral Cover") +
        theme_classic() +
        gg_theme +
        scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
    if (input$coral_cover_year_consolidate_locality) {
        base_plot
    } else {
        base_plot +
            aes(fill = Locality) +
            scale_fill_manual(name = "Locality", values = palette, guide = guide_legend(nrow = 2))
    }
}
