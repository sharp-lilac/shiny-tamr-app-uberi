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
df_ref_sites <- vroom::vroom("data/dryad/Ref_Sites_Turneffe.csv", na = nas)

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
    mutate(Biomass_Category = case_when(
        Family == "Acanthuridae" ~ "H",
        Family == "Scaridae" ~ "H",
        Family == "Epinephelidae" ~ "C",
        Family == "Lutjanidae" ~ "C"
    )) %>%
    mutate(Length = case_when(
        Size_Class == "0_05" ~ 2.5,
        Size_Class == "05_10" ~ 7.5,
        Size_Class == "10_20" ~ 15.5,
        Size_Class == "20_30" ~ 25.5,
        Size_Class == "30_40" ~ 35.5,
        Size_Class == "40" ~ 45.5
    )) %>%
    mutate(Biomass = Observations * (LWRa * (Length^LWRb))) %>%
    left_join(df_ref_sites, by = "Site")
# Create fish size dataframe
df_master_fish_size <- df_master_fish_clean %>%
    filter(!is.na(Length) & Observations != 0) %>%
    select(Year, Locality, Uniq_Transect, Start_Time, Fish.x, Fish_Scientific, Fish_Family, Length, Observations)
# Create fish biomass dataframe
complete_grid_fish <- expand_grid(
    Uniq_Transect = unique(df_master_fish_clean$Uniq_Transect),
    Biomass_Category = unique(df_master_fish_clean$Biomass_Category)
)
df_master_fish_biomass <- df_master_fish_clean %>%
    filter(Biomass_Category == "H" | Biomass_Category == "C") %>%
    group_by(Year, Biomass_Category, Uniq_Transect, Site, Locality) %>%
    summarize(Biomass_Transect = sum(Biomass)) %>%
    full_join(complete_grid_fish, by = c("Uniq_Transect", "Biomass_Category")) %>%
    mutate(Biomass_Transect = replace_na(Biomass_Transect, 0)) %>%
    mutate(Biomass_g_per_100m2_Transect = 100 * Biomass_Transect / 60) %>% # calculate biomass density for transect
    filter(!is.na(Biomass_Category)) %>%
    left_join(df_ref_sites, by = "Site")
# Create fish count and richness dataframe
df_master_fish_count <- df_master_fish_clean %>%
    group_by(Year, Locality, Site, Uniq_Transect, Start_Time) %>%
    summarize(
        Count = sum(Observations),
        Richness = length(unique(Fish_Scientific[Observations > 0]))
    )
df_master_fish_count_site <- df_master_fish_clean %>%
    group_by(Year, Locality, Site) %>%
    summarize(
        Transects = n_distinct(Uniq_Transect),
        Count = sum(Observations),
        Richness = length(unique(Fish_Scientific[Observations > 0]))
    )

# Write new data to repository for access ---------------------------
write.csv(df_master_fish_biomass, "data/dryad/restructured/Master_Fish_Biomass.csv")
write.csv(df_master_fish_size, "data/dryad/restructured/Master_Fish_Size.csv")
write.csv(df_master_fish_count, "data/dryad/restructured/Master_Fish_Count.csv")
write.csv(df_master_fish_count_site, "data/dryad/restructured/Master_Fish_Count_Site.csv")
