## data_load.R

# Load packages ---------------------------
library(vroom)

# Define NA vector ---------------------------
nas <- c("", " ", "NA", "U", "NA ", "MISSING")

# Load data ---------------------------
df_master_benthic <- vroom::vroom("data/dryad/Master_Benthic_PIM_2010-2023.csv", na = nas, show_col_types = FALSE)
df_master_coral <- vroom::vroom("data/dryad/Master_Coral_Community_2010-2021.csv", col_types = cols(Temp = col_double()), na = nas, show_col_types = FALSE)
df_master_fish_biomass <- vroom::vroom("data/dryad/restructured/Master_Fish_Biomass.csv", na = nas, show_col_types = FALSE)
df_master_fish_size <- vroom::vroom("data/dryad/restructured/Master_Fish_Size.csv", col_types = cols(Start_Time = col_character()), na = nas, show_col_types = FALSE)
df_master_fish_count <- vroom::vroom("data/dryad/restructured/Master_Fish_Count.csv", col_types = cols(Start_Time = col_character()), na = nas, show_col_types = FALSE)
df_master_fish_count_site <- vroom::vroom("data/dryad/restructured/Master_Fish_Count_Site.csv", na = nas, show_col_types = FALSE)
df_ref_disease <- vroom::vroom("data/dryad/Ref_Diseases_Coral.csv", na = nas, show_col_types = FALSE)
df_ref_collec <- vroom::vroom("data/dryad/Ref_Collectors_Turneffe.csv", na = nas, show_col_types = FALSE)
df_ref_organisms <- vroom::vroom("data/dryad/Ref_Organisms_Benthic.csv", na = nas, show_col_types = FALSE)
df_ref_sites <- vroom::vroom("data/dryad/Ref_Sites_Turneffe.csv", na = nas, show_col_types = FALSE)
reef_localities_surveyed_table <- vroom::vroom("data/Reef_Localities_Surveyed.csv", na = nas, show_col_types = FALSE)
