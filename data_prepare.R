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
    group_by(Year, Locality, Site, Uniq_Transect, Org_Name, Species, Organism, AGRRA_Bucket, Bucket2_Name) %>%
    summarise(Count = n(), Total_Points = first(Total_Points)) %>%
    mutate(Percent = (Count / Total_Points) * 100)
df_benthic_percents_coral <- df_benthic_percents %>%
    group_by(Year, Locality, Site, Uniq_Transect) %>%
    summarize(Percent_Coral = sum(Percent[AGRRA_Bucket == "Coral"], na.rm = TRUE))
df_coral_size <- df_master_coral_clean %>%
    select(Year, Locality, Organism, Genus, Org_Name, Max_Length, Max_Width, Max_Height) %>%
    filter(!is.na(Genus)) %>%
    pivot_longer(cols = c(Max_Length, Max_Width, Max_Height), names_to = "Metric", values_to = "Size")
df_coral_health <- df_master_coral_clean %>%
    select(Year, Locality, Organism, Genus, Org_Name, OD, TD, RD) %>%
    mutate(Dead = case_when(is.na(TD) ~ OD + RD, TRUE ~ OD + TD + RD))

# Prepare key vectors ---------------------------
collectors_count <- length(unique(c(df_master_benthic$Collector, df_master_fish$Collector, df_master_coral$Collector)))
sites_count <- length(unique(c(df_master_benthic$Site, df_master_fish$Site, df_master_coral$Site)))
localities_count <- length(unique(c(df_master_benthic_clean$Locality)))
years_count <- length(unique(c(df_master_benthic$Year, df_master_fish$Year, df_master_coral$Year)))
sites <- unique(df_master_benthic_clean$Site)
localities <- sort(unique(df_master_benthic_clean$Locality))
years <- unique(df_master_benthic_clean$Year)
coral_species <- df_master_benthic_clean %>%
    filter(!is.na(Species) & !is.na(Organism)) %>%
    select(Species) %>%
    distinct() %>%
    arrange(Species)
coral_genera <- sort(unique(df_coral_size$Genus))
