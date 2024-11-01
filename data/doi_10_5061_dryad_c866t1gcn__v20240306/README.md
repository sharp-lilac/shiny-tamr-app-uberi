# Coral Reef Benthic and Fish Monitoring Data from Turneffe Atoll, Belize, 2010-2023

[Access this dataset on Dryad](10.5061/dryad.c866t1gcn)

Our dataset encompasses coral reef field data collected from Turneffe Atoll Marine Reserve, Belize, spanning the years 2010 to 2023. Using four distinct survey methods---benthic point intercept, benthic belt transect invertebrate, coral community characterization, and reef fish belt transect---the data were gathered along transects at various localities around the atoll, with individual sites targeting specific reef structures, including backreef, deep forereef, and shallow forereef. Data were validated with custom validation rules created in R Statistical Software.

## Description of the data and file structure

Nine total data files are included in this dataset. Four files contain survey data, and five files contain supplementary information. Metadata for each file are provided below, including an explanation of each measured parameter, and in some cases, units of measurement and formatting rules. A tenth file, which contains an R script, provides the full code used to evaluate whether each measurement properly adheres to the rules of each column.

Within the dataset, MISSING values are used to represent unknown or unavailable values. Some parameters were only measured in certain years, and some data were lost or unreadable, resulting in these missing values. NA values are used when a parameter is not applicable in certain cases, such as algae height not being applicable to a coral organism.

**File #1: Reef Benthic PIM Survey**

DataFileName = 'Master_Benthic_PIM_2010-2023.csv'\
ProjectYears = 2010-2018, 2021, 2023\
CollectionProtocol = Point-intercept method from MBRS Manual, pg. 27^1^, and AGRRA benthic protocol^2,3^

Each row of this file represents a single point along a unique transect.

| **Parameter**  | **Units** | **Description**                                                                    | **Rules**                                                                                 |
| :------------- | :-------- | :--------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------- |
| Year           | None      | Year data were collected                                                           | Valid year (2010-2018, 2021 or 2023) in format YYYY                                       |
| Date           | None      | Date data were collected                                                           | Format YYYY-MM-DD with the same year as Year                                              |
| Site           | None      | Site where data were collected                                                     | From list of valid sites in Sites Turneffe data                                           |
| Transect       | None      | Transect at which data were collected at that Site during that Year                | Integer from 1-6                                                                          |
| Uniq\_Transect | None      | Unique transect at which the data were collected                                   | Format year.B.site.transect, where year is Year, site Site, and transect Transect         |
| Protocol       | None      | Protocol data were collected under                                                 | MBRS for Year 2010-2018, or AGRRA for Year 2021-2023                                      |
| Start\_Time    | None      | Time at which data collection begins at that Site during that Year                 | Format must be 24 hour HH:MM                                                              |
| Start\_Depth   | m         | Depth at start of the Transect                                                     | Integer from 1-60                                                                         |
| End\_Depth     | m         | Depth at end of the Transect                                                       | Integer from 1-60                                                                         |
| Temp           | °C        | Bottom temperature at Site during that Year                                        | Integer from 25-35                                                                        |
| Point          | m         | Point along the transect at which data were collected                              | Point must be a multiple of 0.25 for 2010-2018, multiple of 0.1 for 2021-2023             |
| Organism       | None      | Organism found directly below transect tape at that specific Point                 | Must be a an Organism from Organisms Benthic data                                         |
| Algae\_Height  | cm        | Height of algae Organism                                                           | Integer from 0-300 if the Organism of that row has Height = Yes in Organisms Benthic data |
| Bleaching      | None      | Bleaching status of coral Organism; P for pale, BL for bleached, UB for unbleached | P, BL, or UB if the Organism of that row has Bleaching = Yes in Organisms Benthic data    |
| ND\_A          | None      | Whether an Organism is alive or newly dead; A for alive, ND for newly dead         | ND or A if the Organism of that row has ND\_A = Yes in Organisms Benthic data             |
| Cloud\_Cover   | None      | Cloud cover at time of sampling                                                    | Integer from 0-8, where 0 is least cover and 8 is most                                    |
| Collector      | None      | Collector code that corresponds to field data collector of Observations            | From list of valid collector codes in Collectors Turneffe data                            |
| Notes          | None      | Any additional notes                                                               | Any string of text                                                                        |

**File #2: Reef Benthic Invertebrates Survey**

DataFileName = 'Master_Benthic_Inverts_2021-2023.csv'\
ProjectYears = 2010-2015, 2017, 2018, 2021, 2023\
CollectionProtocol = Fish method including *Diadema* urchin counts from MBRS Manual, pg. 30^1^, and AGRRA benthic protocol^3^

This file is structured so that each unique transect is allocated a row for each of the six surveyed benthic invertebrate types. If a specific invertebrate is absent on a given transect, it is assigned an observation number, Num, of 0. If the invertebrate type was not being observed during a particular year, it is denoted with a Num of MISSING.

| **Parameter**  | **Units** | **Description**                                                                                                     | **Rules**                                                                                                 |
| :------------- | :-------- | :------------------------------------------------------------------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------- |
| Year           | None      | Year data were collected                                                                                            | Valid year (2010-2015, 2017, 2018, 2021 or 2023) in format YYYY                                           |
| Date           | None      | Date data were collected                                                                                            | Format YYYY-MM-DD with the same year as Year                                                              |
| Site           | None      | Site where data were collected                                                                                      | From list of valid sites in Sites Turneffe data                                                           |
| Transect       | None      | Transect at which data were collected at that Site during that Year                                                 | Integer from 1-8                                                                                          |
| Uniq\_Transect | None      | Unique transect at which the data were collected, matching either the fish (F) transect or benthic PIM (B) transect | Format year.B.site.transect or year.F.site.transect, where year is Year, site Site, and transect Transect |
| Protocol       | None      | Protocol data were collected under                                                                                  | MBRS for Year 2010-2018, or AGRRA for Year 2021-2023                                                      |
| Start\_Time    | None      | Time at which data collection begins at that Site during that Year                                                  | Format must be 24 hour HH:MM                                                                              |
| Temp           | °C        | Bottom temperature at Site during that Year                                                                         | Integer from 25-35                                                                                        |
| Species        | None      | Species of invertebrate that may be found on the transect                                                           | DiademaJuv, Diadema (adult *D. antillarum* ), OtherUrchins, Lobster, Conch, or Cucumbers                  |
| Num            | None      | Number of that Species found on the transect                                                                        | Integer from 0-100                                                                                        |
| Collector      | None      | Collector code that corresponds to field data collector of Observations                                             | From list of valid collector codes in Collectors Turneffe data                                            |
| Notes          | None      | Any additional notes                                                                                                | Any string of text                                                                                        |

**File #3: Coral Community Characterization**

DataFileName = 'Master_Coral_Community_2010-2021.csv'\
ProjectYears = 2010-2018, 2021\
CollectionProtocol = Coral method from MBRS Manual, pg. 27^1^, and AGRRA coral protocol^4^

This file is organized so that each row represents a single observed coral organism.

| **Parameter**   | **Units** | **Description**                                                                       | **Rules**                                                                         |
| :-------------- | :-------- | :------------------------------------------------------------------------------------ | :-------------------------------------------------------------------------------- |
| Year            | None      | Year data were collected                                                              | Valid year (2010-2018, or 2021) in format YYYY                                    |
| Date            | None      | Date data were collected                                                              | Format YYYY-MM-DD with the same year as Year                                      |
| Site            | None      | Site where data were collected                                                        | From list of valid sites in Sites Turneffe data                                   |
| Transect        | None      | Transect at which data were collected at that Site during that Year                   | Integer from 1-5                                                                  |
| Uniq\_Transect  | None      | Unique transect at which the data were collected                                      | Format year.C.site.transect, where year is Year, site Site, and transect Transect |
| Protocol        | None      | Protocol data were collected under                                                    | MBRS for Year 2010-2018, or AGRRA for Year 2021                                   |
| Start\_Time     | None      | Time at which data collection begins at that Site during that Year                    | Format must be 24 hour HH:MM                                                      |
| Start\_Depth    | m         | Depth at start of the Transect                                                        | Integer from 1-60                                                                 |
| End\_Depth      | m         | Depth at end of the Transect                                                          | Integer from 1-60                                                                 |
| Temp            | °C        | Bottom temperature at Site during that Year                                           | Integer from 25-35                                                                |
| Organism        | None      | Organism found directly below transect tape at that specific Point                    | Must be an Organism from Organisms Benthic data                                   |
| Isolates        | None      | FR for fragment, CL for clump, or number soft tissue isolates if colony/solitary      | Must be FR, CL, or integer from 0-20                                              |
| Depth\_Top      | m         | Water depth at the highest point of the coral                                         | Numeric from 0.1-50                                                               |
| Max\_Diam       | cm        | Maximum projected diameter (live and dead areas) in plan view of the coral            | Integer from 1-500                                                                |
| Max\_Length     | cm        | Maximum length perpendicular to the axis of growth of the coral                       | Integer from 1-500                                                                |
| Max\_Width      | cm        | Maximum width at right angles to the maximum length of the coral                      | Integer from 1-500                                                                |
| Max\_Height     | cm        | Maximum height parallel to the axis of growth of the coral                            | Numeric from 0.1-1, or integer from 1-500                                         |
| OD              | Percent   | Percent of the coral that has old mortality                                           | Integer from 0-100                                                                |
| TD              | Percent   | Percent of the coral that has transitional mortality                                  | Integer from 0-100                                                                |
| RD              | Percent   | Percent of the coral that has recent mortality                                        | Integer from 0-100                                                                |
| Disease         | None      | Code for a disease observed on the coral                                              | Must be a Disease code from Disease Coral data                                    |
| Percent\_Pale   | Percent   | Percent of the coral that is pale                                                     | Integer from 0-100                                                                |
| Percent\_Bleach | Percent   | Percent of the coral that is bleaching                                                | Integer from 0-100                                                                |
| Bleaching       | None      | Discoloration; P for pale, PB for partly bleached, BL for bleached, UB for unbleached | Must be P, BL, PB, or UB                                                          |
| Collector       | None      | Collector code that corresponds to field data collector of Observations               | From list of valid collector codes in Collectors Turneffe data                    |
| Notes           | None      | Any additional notes                                                                  | Any string of text                                                                |

**File #4: Reef Fish Survey**

DataFileName = 'Master_Fish_Survey_2010-2023.csv'\
ProjectYears = 2010-2015, 2017, 2018, 2021, 2023\
CollectionProtocol = Fish belt transect method from MBRS Manual, pg. 30^1^, and AGRRA fish belt transect protocol^5^

The data in this file is systematically arranged, wherein each unique transect is allocated a designated row for every combination of fish species and size class under investigation that year. To illustrate, if a specific transect is targeted that year for the observation of lionfish in the 0-5cm size range, and none are identified during the survey, the corresponding row is retained with the observation count denoted as '0.' Detailed listings of the targeted fish species and associated years can be referenced in the Fish Species reference sheet.

| **Parameter**    | **Units** | **Description**                                                              | **Rules**                                                                         |
| :--------------- | :-------- | :--------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- |
| Year             | None      | Year data were collected                                                     | Valid year (2010-2015, 2017, 2018, 2021 or 2023) in format YYYY                   |
| Date             | None      | Date data were collected                                                     | Format YYYY-MM-DD with the same year as Year                                      |
| Site             | None      | Site where data were collected                                               | From list of valid sites in Sites Turneffe data                                   |
| Transect         | None      | Transect at which data were collected at that Site during that Year          | Integer from 1-12                                                                 |
| Uniq\_Transect   | None      | Unique transect at which the data were collected                             | Format year.F.site.transect, where year is Year, site Site, and transect Transect |
| Protocol         | None      | Protocol data were collected under                                           | MBRS for Year 2010-2018, or AGRRA for Year 2021-2023                              |
| Start\_Time      | None      | Time at which data collection begins at that Site during that Year           | Format must be 24 hour HH:MM                                                      |
| Start\_Depth     | m         | Depth at start of the Transect                                               | Integer from 1-60                                                                 |
| End\_Depth       | m         | Depth at end of the Transect                                                 | Integer from 1-60                                                                 |
| Max\_Relief      | cm        | Terrain height variation in 1m radius circles at 5m intervals along Transect | Integer series, each integer a multiple of 5cm, integers separated by periods     |
| Temp             | °C        | Bottom temperature at Site during that Year                                  | Integer from 25-35                                                                |
| Fish             | None      | Common name of fish                                                          | Must be a fish surveyed that Year, according to Fish Species data                 |
| Fish\_Scientific | None      | Scientific name of fish                                                      | Must be latin binomial for that Fish, according to Fish Species data              |
| Size\_Class      | cm        | Fish size grouping                                                           | Either 0\_05, 05\_10, 10\_20, 20\_30, 30\_40, or 40                               |
| Observations     | None      | Number Fish observed of that Size\_Class at that Uniq\_Transect              | Integer from 0-500                                                                |
| Cloud\_Cover     | None      | Cloud cover at time of sampling                                              | Integer from 0-8, where 0 is least cover and 8 is most                            |
| Sea\_Conditions  | None      | Sea conditions at time of sampling, either Calm, Moderate, or Choppy         | Either Calm, Moderate, or Choppy                                                  |
| Collector        | None      | Collector code that corresponds to field data collector of Observations      | From list of valid collector codes in Collectors Turneffe data                    |
| Notes            | None      | Any additional notes                                                         | Any string of text                                                                |

**File #5: Collectors**

DataFileName = 'Ref_Collectors_Turneffe.csv'\
ProjectYears = 2010-2018, 2021, 2023

| **Parameter:** | **Description:**                                                                                                           |
| :------------- | :------------------------------------------------------------------------------------------------------------------------- |
| Collector      | The code which references a specific collector, including the first 2 letters of given name and first 2 letters of surname |
| Name           | The full name, if available, of the collector to which the code refers                                                     |

**File #6: Coral Diseases**

DataFileName = 'Ref_Diseases_Coral.csv'\
ProjectYears = 2010-2018, 2021, 2023

| **Parameter:** | **Description:**                                                                           |
| :------------- | :----------------------------------------------------------------------------------------- |
| Disease        | A code representing a specific kind of disease for coral                                   |
| Name           | Name of the disease for that code                                                          |
| Notes          | Any notes about the disease code or disease by the data collector(s), compiler, or analyst |

**File #7: Fish Species**

DataFileName = 'Ref_Fish_Species.csv'\
ProjectYears = 2010-2018, 2021, 2023

| **Parameter:**   | **Description:**                                                                                                                                                                                                                 |
| :--------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Fish             | The common English name of a fish species                                                                                                                                                                                        |
| Fish\_Scientific | The scientific name of that fish species                                                                                                                                                                                         |
| Fish\_Family     | The taxonomic family within which the fish species belongs                                                                                                                                                                       |
| Status\_2023     | The status of the fish taxonomic species as of 2023. Status collected from the WoRMS database, [WoRMS](http%20s%20://www.marinespecies.org/index.php). Whether it is Accepted or Unaccepted as a taxonomic name for the species. |
| Aphia\_ID        | The ID given to the fish species on the WoRMS database; used to tie species to specific literature and attributes, [WoRMS](htt%20p%20s://www.marinespecies.org/index.php)                                                        |
| GBIF\_ID         | The ID given to the fish species on the GBIF database; used to tie species to occurrence/distribution datasets worldwide, [GBIF](https://www.gbif.org/)                                                                          |
| List\_2010       | Whether the fish species was included in the list during 2010 surveying                                                                                                                                                          |
| List\_2011       | Whether the fish species was included in the list during 2011 surveying                                                                                                                                                          |
| … (cont.)        | … (cont.)                                                                                                                                                                                                                        |
| List\_2023       | Whether the fish species was included in the list during 2023 surveying                                                                                                                                                          |
| Notes            | Any notes about the fish by the data collector(s), compiler, or analyst                                                                                                                                                          |

**File #8: Benthic Organism Codes**

DataFileName = 'Ref_Organisms_Benthic.csv'\
ProjectYears = 2010-2018, 2021, 2023

| **Parameter:** | **Description:**                                                                                                                                                                                 |
| :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Organism       | The code corresponding to a particular organism or non-living substrate in the benthic zone, at the point directly below the transect                                                            |
| Bucket         | A bucket category used to classify the organism codes so to standardize across years, collectors, and protocols                                                                                  |
| Bucket\_Name   | Description of organisms included in the bucket                                                                                                                                                  |
| Bucket2        | An alternative bucket category used to classify the organism codes so to standardize across years, collectors, and protocols                                                                     |
| Bucket2\_Name  | Description of organisms included in the alternative bucket                                                                                                                                      |
| AGRRA\_Bucket  | Bucket category used by AGRRA to classify the organism codes so to standardize across years, collectors, and protocols                                                                           |
| AGRRA\_Code    | The code typically used in AGRRA protocol for that organism. May be found in raw or unprocessed data sheets. Codes used may vary by collector and year, however.                                 |
| MBRS\_Code     | The code typically used in MBRS protocol for that organism. May be found in raw or unprocessed data sheets. Codes used may vary by collector and year, however.                                  |
| Org\_Name      | A description of the organism or non-living substrate                                                                                                                                            |
| Aphia\_ID      | The AphiaID from the WoRMS database for that Organism, if applicable; used to tie taxonomic groups to specific literature and attributes, [WoRMS](htt%20p%20s://www.marinespecies.org/index.php) |
| GBIF\_ID       | The ID given to the taxonomic group on the GBIF database; used to tie species to occurrence/distribution datasets worldwide, [GBIF](https://www.gbif.org/)                                       |
| IUCN\_ID       | The ID given to the taxonomic group on the IUCN database; used to tie species to redlist dataset , [IUCN](https://www.iucnredlist.org/en)                                                        |
| Height?        | Whether algae height should be recorded for this organism in benthic PIM methods                                                                                                                 |
| Bleaching      | Whether bleaching should be recorded for this organism in benthic PIM methods                                                                                                                    |
| ND\_A          | Whether ND\_A should be recorded for this organism in benthic PIM methods                                                                                                                        |

**File #9: Sites**

DataFileName = 'Ref_Sites_Turneffe.csv'\
ProjectYears = 2010-2018, 2021, 2023

| **Parameter:**   | **Description:**                                                                                                                                                                                |
| :--------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Site             | The site at which the data were collected, in a unique code format                                                                                                                              |
| Locality         | The locality to which the site belongs                                                                                                                                                          |
| Reef\_Zone       | The reef zone for that site, either Backreef, Deep\_Forereef , or Shallow\_Forereef. Backreef is leeward facing (<3m), Deep\_Forereef is windward (>10m), Shallow\_Forereef is windward (3-10m) |
| Management\_Zone | The management zone in which the site is found, either Atoll, SpecialManagement, or Conservation                                                                                                |
| Latitude         | The latitude coordinate at which the site is found, in decimal format                                                                                                                           |
| Longitude        | The longitude coordinate at which the site is found, in decimal format                                                                                                                          |
| Notes            | Any additional notes by the data collector(s), compiler, or analyst                                                                                                                             |

**File #10: Validation Script**

RScriptName = 'Validation.Rmd'

## References

1\. Almada-Villela, P. C., Sale, P. F., Gold-Bouchot, G. & Kjerfve, B. Manual of methods for the MBRS synoptic monitoring program: Selected methods for monitoring physical and biological parameters for use in the Mesoamerican region. [Link to Document](#0) (2003).

2\. Lang, J. C., Marks, K. W., Kramer, P. A., Kramer, P. R. & Ginsburg, R. N. AGRRA Benthos Protocol. Summary Instructions. [Link to Document](https://www.agrra.org/wp-content/uploads/2016/06/AGRRA-Benthos-Protocol.pdf) (2016).

3\. Atlantic and Gulf Rapid Reef Assessment. AGGRA Benthos Protocol. Summary Instructions, April 2021 Updated. [Link to Document](https://agrra.org/wp-content/uploads/2021/05/AGRRA-Benthos-Protocol-April_13_2021.pdf) (2021).

4\. Lang, J. C., Marks, K. W., Kramer, P. A., Kramer, P. R. & Ginsburg, R. N. AGGRA Detailed Fish Protocol. Instructions for Use, June 2016. [Link to Document](https://www.agrra.org/wp-content/uploads/2021/05/AGRRA-Fish-Protocol_June-2016.pdf) (2016).

5\. Atlantic and Gulf Rapid Reef Assessment. AGGRA Coral Protocol. Summary Instructions, April 2021. [Link to Document](https://agrra.org/wp-content/uploads/2021/05/AGRRA-Coral-Protocol-April_13_2021.pdf) (2021).