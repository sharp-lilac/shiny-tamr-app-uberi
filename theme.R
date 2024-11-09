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
    panel.background = element_rect(fill = "#f5f5f5ff", color = "#e8eaecff", linewidth = 2),
    plot.background = element_rect(fill = "#ecf0f5ff", color = NA),
    legend.background = element_rect(fill = "#ecf0f5ff", color = NA),
    legend.box.background = element_rect(fill = "#ecf0f5ff", color = NA),
    plot.caption = element_text(hjust = 0, size = 14, margin = margin(t = 10)),
    panel.grid.major.y = element_line(color = "grey85", size = 0.5)
)

# Define color palette ---------------------------
palette <- c(
    "#5a7494", "#b4c781", "#88C0D0", "#B48EAD", "#4C566A", "#b69efa",
    "#ce4fa4", "#e7a042", "#FB9A99", "#0d8086", "#79cc92", "#7E3793",
    "#33A02C", "#c35e68", "#eaea9a", "#9933FF", "#999933",
    "#FFCCFF", "#336600", "#999999", "#990000", "#f5f5f5ff",
    "#E22828", "coral", "#eeeec2", "violet", "#a5652a", "#d6fdfd",
    "#fcfc00", "#b69efa", "#ffecc8", "#3b3ba5"
)
