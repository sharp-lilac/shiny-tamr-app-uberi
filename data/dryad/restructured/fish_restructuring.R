## fish_restructuring.R

# Load packages ---------------------------
library(vroom)
library(tidyverse)

# Define NA vector ---------------------------
nas <- c("", " ", "NA", "U", "NA ")

# Load raw data to be restructured ---------------------------
df_master_fish <- vroom::vroom("data/dryad/Master_Fish_Survey_2010-2023.csv", na = nas)
df_ref_fish <- vroom::vroom("data/dryad/Ref_Fish_Species.csv", na = nas)
df_ref_biomass <- vroom::vroom("data/reference/fish_biomass_specification.csv", na = nas)

# Restructure fish data ---------------------------
df_ref_biomass_clean <- df_ref_biomass %>%
    mutate(
        Family = word(Name, 1),
        Binomial = ifelse(str_detect(Name, " "), word(Name, 2, 3), NA_character_)
    )
df_master_fish_clean <- df_master_fish %>%
    mutate(Year = as.factor(Year)) %>%
    left_join(df_ref_fish, by = c("Fish_Scientific")) %>%
    mutate(Family = Fish_Family, Binomial = Fish_Scientific) %>%
    left_join(df_ref_biomass_clean, by = c("Family", "Binomial")) %>%
    mutate(Biomass_Category = case_when( # assign biomass categories for key fish families
        Family == "Acanthuridae" ~ "H",
        Family == "Scaridae" ~ "H",
        Family == "Epinephelidae" ~ "C",
        Family == "Lutjanidae" ~ "C"
    )) %>%
    mutate(Length = case_when(
        Size_Class == "0_05" ~ 2.5, # assign fish length values based on size class
        Size_Class == "05_10" ~ 7.5,
        Size_Class == "10_20" ~ 15.5,
        Size_Class == "20_30" ~ 25.5,
        Size_Class == "30_40" ~ 35.5,
        Size_Class == "40" ~ 45.5
    )) %>%
    mutate(Biomass = Observations * (LWRa * (Length^LWRb))) # calculate biomass for observation
complete_grid_fish <- expand_grid(
    Uniq_Transect = unique(df_master_fish_clean$Uniq_Transect),
    Biomass_Category = unique(df_master_fish_clean$Biomass_Category)
)
df_master_fish_biomass <- df_master_fish_clean %>%
    filter(Biomass_Category == "H" | Biomass_Category == "C") %>%
    group_by(Year, Biomass_Category, Uniq_Transect, Site) %>%
    summarize(Biomass_Transect = sum(Biomass)) %>%
    full_join(complete_grid_fish, by = c("Uniq_Transect", "Biomass_Category")) %>%
    mutate(Biomass_Transect = replace_na(Biomass_Transect, 0)) %>%
    mutate(Biomass_g_per_100m2_Transect = 100 * Biomass_Transect / 60) %>% # calculate biomass density for transect
    filter(!is.na(Biomass_Category))

# Write new data to repository for access ---------------------------
write.csv(df_master_fish_biomass, "data/dryad/restructured/Master_Fish_Biomass.csv")
