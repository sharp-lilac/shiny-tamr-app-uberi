## data_load.R

# Load packages ---------------------------
library(vroom) # for fast data loading

# Define NA vector ---------------------------
nas <- c("", " ", "NA", "U", "NA ")

# Load data ---------------------------
df_master_benthic <- vroom::vroom("data/dryad/Master_Benthic_PIM_2010-2023.csv", na = nas)
df_master_coral <- vroom::vroom("data/dryad/Master_Coral_Community_2010-2021.csv", na = nas)
df_master_fish <- vroom::vroom("data/dryad/Master_Fish_Survey_2010-2023.csv", na = nas)
df_ref_disease <- vroom::vroom("data/dryad/Ref_Diseases_Coral.csv", na = nas)
# df_ref_fish <- vroom::vroom("data/dryad/Ref_Fish_Species.csv", na = nas)
df_ref_collec <- vroom::vroom("data/dryad/Ref_Collectors_Turneffe.csv", na = nas)
df_ref_organisms <- vroom::vroom("data/dryad/Ref_Organisms_Benthic.csv", na = nas)
df_ref_sites <- vroom::vroom("data/dryad/Ref_Sites_Turneffe.csv", na = nas)
df_ref_biomass <- vroom::vroom("data/reference/fish_biomass_specification.csv", na = nas)
