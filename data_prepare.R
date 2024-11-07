## data_prepare.R

# Load packages ---------------------------
library(tidyverse)
library(rlang)

# Source objects ---------------------------
source("data_load.R")

# Prepare data ---------------------------
# Benthic
df_master_benthic_clean <- df_master_benthic %>%
    mutate(Year = as.factor(Year)) %>%
    left_join(df_ref_organisms, by = "Organism") %>%
    left_join(df_ref_sites, by = "Site")
# Fish
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

# Prepare data subsets ---------------------------
df_benthic_percents <- df_master_benthic_clean %>%
    group_by(Uniq_Transect) %>%
    summarise(Total_Points = n()) %>%
    right_join(df_master_benthic_clean, by = "Uniq_Transect") %>%
    group_by(Year, Locality, Site, Uniq_Transect, Org_Name, Species, Organism, AGRRA_Bucket) %>%
    summarise(Count = n(), Total_Points = first(Total_Points)) %>%
    mutate(Percent = (Count / Total_Points) * 100)
df_benthic_percents_coral <- df_benthic_percents %>%
    group_by(Year, Locality, Site, Uniq_Transect) %>%
    summarize(Percent_Coral = sum(Percent[AGRRA_Bucket == "Coral"], na.rm = TRUE))

# Prepare key vectors ---------------------------
sites <- unique(df_master_benthic_clean$Site)
localities <- unique(df_master_benthic_clean$Locality)
years <- unique(df_master_benthic_clean$Year)
coral_species <- df_master_benthic_clean %>%
    filter(!is.na(Species) & !is.na(Organism)) %>%
    select(Species) %>%
    distinct() %>%
    arrange(Species)
