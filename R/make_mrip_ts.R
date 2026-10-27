#' Create MRIP time series of catch
#'
#' Use `read_mrip_csv` to bring in species datasets, then combine them
#' into something sensible
#'
#'@param path Path to csv file output from MRIP query tool
#'@param header_pattern Optional; first line of data names, e.g. "^Estimate"
#'@param n_meta Optional; integer number of lines prior to the first line of data




scuprec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_SCUP_catch_series.csv"))

bsbrec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_BLACK_SEA_BASS_catch_series.csv"))

flukerec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_SUMMER_FLOUNDER_catch_series.csv"))

bluerec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_BLUEFISH_catch_series.csv"))

mackrec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_ATLANTIC_MACKEREL_catch_series.csv"))
