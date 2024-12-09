## data_prepare.R

# Load packages ---------------------------
library(tidyverse)
library(rlang)

# Source objects ---------------------------
source("data_load.R")

# Prepare data ---------------------------
df_master_benthic_clean <- df_master_benthic %>%
    mutate(Year = as.factor(Year)) %>%
    left_join(df_ref_organisms, by = "Organism") %>%
    left_join(df_ref_sites, by = "Site")
df_master_coral_clean <- df_master_coral %>%
    mutate(
        Year = as.factor(Year),
        OD = as.numeric(OD),
        TD = as.numeric(TD),
        RD = as.numeric(RD),
        Percent_Pale = as.numeric(Percent_Pale),
        Percent_Bleach = as.numeric(Percent_Bleach),
        Max_Diam = as.numeric(Max_Diam),
        Max_Length = as.numeric(Max_Length),
        Max_Length = case_when(!is.na(Max_Diam) ~ Max_Diam, TRUE ~ Max_Length),
        Max_Width = as.numeric(Max_Width),
        Max_Height = as.numeric(Max_Height)
    ) %>%
    left_join(df_ref_organisms, by = "Organism") %>%
    left_join(df_ref_sites, by = "Site") %>%
    mutate(Genus = as.factor(Genus))

# Prepare data subsets ---------------------------
df_benthic_percents <- df_master_benthic_clean %>%
    group_by(Uniq_Transect) %>%
    summarise(Total_Points = n()) %>%
    right_join(df_master_benthic_clean, by = "Uniq_Transect") %>%
    group_by(Year, Locality, Site, Zone, Uniq_Transect, Org_Name, Species, Organism, AGRRA_Bucket, Bucket2_Name) %>%
    summarise(Count = n(), Total_Points = first(Total_Points), .groups = "keep") %>%
    mutate(Percent = (Count / Total_Points) * 100)
df_benthic_percents_coral <- df_benthic_percents %>%
    group_by(Year, Locality, Site, Uniq_Transect) %>%
    summarize(Percent_Coral = sum(Percent[AGRRA_Bucket == "Coral"], na.rm = TRUE), .groups = "keep")
df_coral_size <- df_master_coral_clean %>%
    select(Year, Locality, Organism, Genus, Org_Name, Max_Length, Max_Width, Max_Height) %>%
    filter(!is.na(Genus)) %>%
    pivot_longer(cols = c(Max_Length, Max_Width, Max_Height), names_to = "Metric", values_to = "Size")
df_coral_health <- df_master_coral_clean %>%
    select(Year, Locality, Organism, Genus, Org_Name, OD, TD, RD) %>%
    mutate(Dead = case_when(is.na(TD) ~ OD + RD, TRUE ~ OD + TD + RD))
df_coral_disease <- df_master_coral_clean %>%
    select(Year, Locality, Organism, Genus, Org_Name, Bleaching.x, Disease) %>%
    left_join(df_ref_disease, by = "Disease") %>%
    mutate(
        Bleaching.x = factor(Bleaching.x,
            levels = c("P", "PB", "BL", "UB", "MISSING"),
            labels = c("Pale", "Pale Bleached", "Bleached", "Unbleached", "Unknown")
        ),
        Name = case_when(
            Name == "Aspergillosis" ~ "Aspergillosis",
            Name == "Black Band Disease" ~ "Black Band",
            Name == "Blue Spots" ~ "Blue Spot",
            Name == "Dark Spots Disease" ~ "Dark Spot",
            Name == "Dark Spots Disease I" ~ "Dark Spot I",
            Name == "Dark Spots Disease II" ~ "Dark Spot II",
            Name == "Stony coral tissue loss disease" ~ "SCTLD",
            Name == "White Band Disease" ~ "White Band",
            Name == "White Plague Disease" ~ "White Plague",
            Name == "White Spot Patch Disease" ~ "White Spot Patch",
            Name == "Yellow Band Disease" ~ "Yellow Band",
            Name == "No disease" ~ "No Disease",
            TRUE ~ Name
        ),
        Name = factor(Name,
            levels = c(
                "Aspergillosis", "Black Band", "Blue Spot", "Dark Spot",
                "Dark Spot I", "Dark Spot II", "SCTLD",
                "White Band", "White Plague", "White Spot Patch",
                "Yellow Band", "No Disease"
            )
        )
    )


# Prepare key vectors ---------------------------
collectors_count <- length(unique(c(df_master_benthic$Collector, df_master_fish_count$Collector, df_master_coral$Collector)))
sites_count <- length(unique(c(df_master_benthic$Site, df_master_fish_biomass$Site, df_master_coral$Site)))
localities_count <- length(unique(c(df_master_benthic_clean$Locality)))
years_count <- length(unique(c(df_master_benthic$Year, df_master_fish_biomass$Year, df_master_coral$Year)))
sites <- unique(df_master_benthic_clean$Site)
localities <- sort(unique(df_master_benthic_clean$Locality))
years <- unique(df_master_benthic_clean$Year)
coral_species <- df_master_benthic_clean %>%
    filter(!is.na(Species) & !is.na(Organism)) %>%
    select(Species) %>%
    distinct() %>%
    arrange(Species)
coral_genera <- sort(unique(df_coral_size$Genus))
fish_families <- sort(unique(df_master_fish_size$Fish_Family))
fish_choices <- c("Locality" = "Locality", "Year" = "Year", "Fish Family" = "Fish_Family", "Time of Day" = "Start_Time")
reverse_fish_choices <- setNames(names(fish_choices), fish_choices)
