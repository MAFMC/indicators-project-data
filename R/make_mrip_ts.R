#' Create MRIP time series of catch
#'
#' Use `read_mrip_csv` to bring in species datasets, then combine them
#' into something sensible and put in the data folder
#'
#'@param file_path list of filenames to be read in
#'
#'@returns a dataframe with columns
#'\itemize{
#'  \item{\code{species}, common name from MRIP}
#'  \item{\code{year}, year}
#'  \item{\code{area}, geographic area}
#'  \item{\code{var}, variable}
#'  \item{\code{value}, value of the variable}
#'  \item{\code{units}, units of the variable}
#'
#'@
#'
#'@examples
#'  obj <- read_mrip_csv(here::here("mrip_bluefish.csv"))
#'
#'@export




scuprec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_SCUP_catch_series.csv"))

bsbrec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_BLACK_SEA_BASS_catch_series.csv"))

flukerec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_SUMMER_FLOUNDER_catch_series.csv"))

bluerec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_BLUEFISH_catch_series.csv"))

mackrec <- read_mrip_csv(here::here("data-raw/MRIP/mrip_ATLANTIC_MACKEREL_catch_series.csv"))
