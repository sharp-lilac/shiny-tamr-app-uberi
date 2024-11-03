## data_prepare.R

# Load packages ---------------------------
library(tidyverse)

# Source Objects ---------------------------
source("data_load.R")

# Prepare Benthic Data ---------------------------
transect_point_counts <- df_master_benthic %>%
    group_by(Uniq_Transect) %>%
    summarize(Total_Count_Transect = n())
df_benthic <- df_master_benthic %>%
    mutate(Year = as.factor(Year)) %>%
    left_join(df_ref_organisms, by = "Organism") %>%
    left_join(df_ref_sites, by = "Site") %>%
    left_join(transect_point_counts, by = "Uniq_Transect")

# Prepare Fish Data ---------------------------


# Prepare Coral Data ---------------------------
