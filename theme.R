## theme.R

# Load packages ---------------------------
library(fresh) # custom themes for dashboard

# Define shiny dashboard theme ---------------------------
dash_theme <- create_theme(
    adminlte_color(
        light_blue = "#5E81AC",
        aqua = "#88C0D0",
        green = "#A3BE8C",
        purple = "#B48EAD"
    ),
    adminlte_sidebar(
        width = "200px",
        dark_bg = "#4C566A",
        dark_hover_bg = "#88C0D0",
        dark_color = "#ECEFF4" # Light text for readability
    ),
    adminlte_global(
        content_bg = "#ECEFF4",
        box_bg = "#D8DEE9",
        info_box_bg = "#A3BE8C"
    )
)
