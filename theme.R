## theme.R

# Load packages ---------------------------
library(fresh)
library(ggplot2)

# Define shiny dashboard theme ---------------------------
dash_theme <- create_theme(
    adminlte_color(light_blue = "#a07aa5", aqua = "#A8D8E8", green = "#B8D0A8", purple = "#7DAAC9"),
    adminlte_sidebar(width = "200px", dark_bg = "#3B4252", dark_hover_bg = "#7b667e", dark_color = "#ECEFF4"),
    adminlte_global(content_bg = "#ECEFF4", box_bg = "#D8DEE9", info_box_bg = "#B8D0A8")
)

# Define ggplot2 theme ---------------------------
gg_theme <- theme(
    legend.position = "bottom",
    legend.box = "horizontal",
    axis.text.x = element_text(face = "bold", angle = 45, vjust = 1, hjust = 1, size = 14),
    axis.text.y = element_text(face = "bold", size = 14),
    axis.title.x = element_text(size = 20, margin = margin(30, 0, 0, 0)),
    axis.title.y = element_text(size = 20, margin = margin(0, 30, 0, 0)),
    plot.title = element_text(size = 22, hjust = 0.5, margin = margin(0, 0, 30, 0)),
    strip.text = element_text(size = 20),
    legend.text = element_text(size = 14, vjust = 0.5),
    legend.title = element_text(face = "bold", size = 14, vjust = 0.5),
    legend.key.height = unit(1, "cm"),
    legend.key.width = unit(1, "cm"),
    legend.margin = margin(t = 20, b = 60),
    panel.background = element_rect(fill = "#f5f5f5ff", color = "#e8eaecff", size = 2),
    plot.background = element_rect(fill = "#ecf0f5ff", color = NA),
    legend.background = element_rect(fill = "#ecf0f5ff", color = NA),
    legend.box.background = element_rect(fill = "#ecf0f5ff", color = NA),
    plot.caption = element_text(hjust = 0, size = 14, margin = margin(t = 20)),
    panel.grid.major.y = element_line(color = "grey85", size = 0.5)
)

# Define color palette ---------------------------
palette <- c(
    "#5E81AC", "#A3BE8C", "#88C0D0", "#B48EAD", "#4C566A", "#b69efa",
    "#5aacf8", "#e7a042", "#b4d368", "#00989eff", "#CC79A7", "#7E3793",
    "#33A02C", "#FB9A99", "#ecec7f", "#b6107f", "#9933FF", "#999933",
    "#FFCCFF", "#336600", "#999999", "#990000", "#f5f5f5ff", "#6be2a7",
    "#E22828", "coral", "#eeeec2", "violet", "#a5652a", "#d6fdfd",
    "#fcfc00", "#b69efa", "#ffecc8", "#3b3ba5"
)
