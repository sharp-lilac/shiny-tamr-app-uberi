## plot_functions.R

# Load packages ---------------------------
library(ggplot2)

# Create plot of coral cover by year ---------------------------
create_coral_cover_year_plot <- function(data_filtered, input, caption) {
    if (input$coral_cover_year_consolidate_locality) {
        ggplot(data_filtered, aes(x = Year, y = Percent_Coral)) +
            geom_boxplot(
                color = "black", fill = palette[1],
                position = position_dodge(width = 0.75),
                outlier.shape = 4, outlier.size = 4
            ) +
            stat_summary(fun = mean, geom = "point", shape = 18, size = 3, fill = "#3B4252") +
            ylab("Percent Coral Cover") +
            labs(caption = caption) +
            theme_classic() +
            gg_theme +
            scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
    } else {
        ggplot(data_filtered, aes(x = Year, y = Percent_Coral, fill = Locality)) +
            geom_boxplot(
                color = "black", position = position_dodge(width = 0.75),
                outlier.shape = 4, outlier.size = 4
            ) +
            stat_summary(
                fun = mean, geom = "point", shape = 18, size = 3, fill = "#3B4252",
                aes(group = Locality),
                position = position_dodge(width = 0.75)
            ) +
            ylab("Percent Coral Cover") +
            labs(caption = caption) +
            theme_classic() +
            gg_theme +
            scale_fill_manual(name = "Locality", values = palette, guide = guide_legend(nrow = 2)) +
            scale_y_continuous(breaks = seq(0, 100, by = 10), sec.axis = dup_axis(name = ""))
    }
}
