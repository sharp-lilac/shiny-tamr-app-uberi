## data_load.R

# Define NA vector ---------------------------
nas <- c("", " ", "NA", "U", "NA ")

# Load data ---------------------------
df_master_benthic <- read.csv("data/dryad/Master_Benthic_PIM_2010-2023.csv", na.strings = nas)
df_master_coral <- read.csv("data/dryad/Master_Coral_Community_2010-2021.csv", na.strings = nas)
df_master_fish <- read.csv("data/dryad/Master_Fish_Survey_2010-2023.csv", na.strings = nas)
df_ref_disease <- read.csv("data/dryad/Ref_Diseases_Coral.csv", na.strings = nas)
df_ref_fish <- read.csv("data/dryad/Ref_Fish_Species.csv", na.strings = nas)
df_ref_collec <- read.csv("data/dryad/Ref_Collectors_Turneffe.csv", na.strings = nas)
df_ref_organisms <- read.csv("data/dryad/Ref_Organisms_Benthic.csv", na.strings = nas)
df_ref_sites <- read.csv("data/dryad/Ref_Sites_Turneffe.csv", na.strings = nas)
df_ref_biomass <- read.csv("data/reference/fish_biomass_specification.csv", na.strings = nas)
