# Pull commercial landings for all 3 Rpath models, July 2024
#
# original file was MAB only, modified to do all 3
# original file was base years, this gets full time series
# revenue included for portfolio analysis
#
# original file: https://github.com/Nyelab/MAB-Rpath/blob/master/MAB_commercial_landings.R
# modified by SKG July 2024
#
# scripts from
# Sarah Weisberg
#
# https://github.com/SarahJWeisberg/GOM-Rpath/blob/main/data/commercial_landings_gom_80_19.RData
# https://github.com/SarahJWeisberg/GOM-Rpath/blob/main/R/commercial_landings.R
# https://github.com/SarahJWeisberg/GOM-Rpath/blob/main/R/landings_conversion.R
#
# Max Grezlik
#
# GB catch inputs: https://github.com/NOAA-EDAB/GBRpath/blob/03a233ffea48dab96a52ab3534503e5d6eee8ab9/data/GB_landings.RData
# GB catch pull: https://github.com/NOAA-EDAB/GBRpath/blob/03a233ffea48dab96a52ab3534503e5d6eee8ab9/data-raw/R/GBRpath_catch_pull.R
#


#Pull commercial data
#This require you to be behind NEFSC firewalls
#See Sean Lucey for access
library(here); library(data.table); library(comlandr)

#Connect to NEFSC server
#channel <- dbutils::connect_to_database(server = "sole", uid = "slucey")

path.yrs <- 1980:1985

#comland <- comlandr::get_comland_data(channel, filterByYear = path.yrs, useForeign = F)

##call
#comlandr::get_comland_data(channel = channel, filterByYear = NA,
# filterByArea = NA, useLanded = TRUE, removeParts = TRUE,
# useHerringMaine = TRUE, useForeign = TRUE, refYear = NA,
# refMonth = NA, disagSkatesHakes = TRUE, aggArea = FALSE,
# userAreas = comlandr::mskeyAreas, areaDescription = "EPU",
# propDescription = "MeanProp", applyProp = FALSE, aggGear = FALSE,
# userGears = comlandr::mskeyGears, fleetDescription = "Fleet",
# unkVar = c("MONTH", "NEGEAR", "AREA"), knStrata = c("HY",
#                                                     "QY", "MONTH", "NEGEAR", "TONCL2", "AREA"))

comland <- readRDS("~/Documents/Work/MAFMCindicators/Code/indicators-project-data/data-raw/comlandr/ignore_rawpull/sarah.rds")

#Assigned area to MAB
#Will be using NAFO Stat Areas - 526, 537, 539, 600, 612 - 616, 621, 622, 625,
# 626, 631, 632
#Several stat areas are completely within the MAB EPU
full.areas <- c(539, 600, 612:616, 621, 622, 625, 626, 631, 632)

landings <- comland$comland[AREA %in% full.areas, ]

# Try without this proportioning first
# Try with

# #Areas 526 and 537 straddle Georges Bank.  The proprotion of catch inside
# #and outside was calculated from the MS Keyrun project for Georges Bank.  We will use
# #the proportion outside of Georges Bank for those Stat Areas.  The rest will be
# #100% MAB
load(here::here('data-raw/comlandr/AllSpeciesProportions.rda'))
proportions <- AllSpeciesProportions
proportions <- proportions[AREA %in% c(526, 537) & InOut == 'out', ]

mab.split.land <- comlandr:::aggregate_area(comland, proportions, areaDescription = 'InOut',
                                            useForeign = F, applyProp = T,
                                 propDescription = 'MeanProp')

mab.split.land$comland[, InOut := NULL]
mab.split.land$comland[, AREA := 526537]

#Merge split landings with other landings
landings <- rbindlist(list(landings, mab.split.land$comland), use.names = T)

#Assign gears to fleets
#Generate NEGEAR2 codes from NEGEAR
landings[NEGEAR < 100, NEGEAR3 := paste0(0, NEGEAR)]
landings[NEGEAR >= 100, NEGEAR3 := NEGEAR]
landings[, NEGEAR2 := as.numeric(substr(NEGEAR3, 1, 2))]

landings[NEGEAR2 %in% c(5, 16, 32, 35, 36), FLEET := 'LG Mesh']
landings[NEGEAR2 == 5 & MESHCAT == 'SM', FLEET := 'SM Mesh']
landings[NEGEAR2 %in% c(1, 2, 8, 10, 50, 52, 14, 26), FLEET := 'Fixed Gear']
landings[NEGEAR2 %in% c(12, 17, 37), FLEET := 'Pelagic']
landings[NEGEAR2 %in% c(18, 15, 19, 20, 21, 23, 30, 33, 53), FLEET := 'Trap']
landings[NEGEAR2 == 13, FLEET := 'Scallop Dredge']
landings[NEGEAR2 == 40, FLEET := 'Clam Dredge']
landings[NEGEAR2 %in% c(22, 25, 38, 41), FLEET := 'Other Dredge']
landings[NEGEAR2 %in% c(3, 4, 6, 11), FLEET := 'HMS']
landings[is.na(FLEET), FLEET := 'Other']
landings[, FLEET := as.factor(FLEET)]

# filter to Rpath years here
landings8085 <- landings |>
  dplyr::filter(YEAR %in% c(1980:1985))

#Calculate mean for Rpath
sum.land <- landings8085[, sum(SPPLIVMT), by = c('YEAR', 'NESPP3', 'FLEET')]
mean.land <- sum.land[, mean(V1), by = c('NESPP3', 'FLEET')]
data.table::setnames(mean.land, 'V1', 'SPPLIVMT')

save(mean.land, file = here::here('data-raw/comlandr/mean_landings_mab_80_85_2026pull.RData'))
