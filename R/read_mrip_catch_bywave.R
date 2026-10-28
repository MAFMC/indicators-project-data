# read in the catch by wave estimate files from MRIP
# they have commas in the numbers so use readr::read_csv but make species code character
# are they really all 2 kg more than the other estimates???
# no 1989 is 3 lg less
# disappointing these sums dont exactly match the other two methods
#
# path <- here::here("data-raw/MRIP/ignore_zips/mrip_catch_bywave_2025.csv")
# test <- read_mrip_catch_bywave(path = path)

read_mrip_catch_bywave <- function(path) {

  readr::read_csv(path,
                  col_types = list(
                    STATUS = readr::col_character(),
                    ALT_FLAG = readr::col_double(),
                    YEAR = readr::col_double(),
                    WAVE = readr::col_double(),
                    SUB_REG = readr::col_double(),
                    SUB_REG_F = readr::col_character(),
                    ST = readr::col_double(),
                    ST_F = readr::col_character(),
                    MODE_FX = readr::col_double(),
                    MODE_FX_F = readr::col_character(),
                    AREA_X = readr::col_double(),
                    AREA_X_F = readr::col_character(),
                    SP_CODE = readr::col_character(), #col_double(),
                    COMMON = readr::col_character(),
                    ESTCLAIM = readr::col_number(),
                    ESTCLVAR = readr::col_number(),
                    LOWER_ESTCLAIM = readr::col_number(),
                    UPPER_ESTCLAIM = readr::col_number(),
                    PSE_A = readr::col_double(),
                    MRIP_STD_ESTCLAIM = readr::col_character(),
                    STAT_SIG_ESTCLAIM = readr::col_character(),
                    ESTHARV = readr::col_number(),
                    ESTHVAR = readr::col_number(),
                    LOWER_ESTHARV = readr::col_number(),
                    UPPER_ESTHARV = readr::col_number(),
                    PSE_B1 = readr::col_double(),
                    MRIP_STD_ESTHARV = readr::col_character(),
                    STAT_SIG_ESTHARV = readr::col_character(),
                    LANDING = readr::col_number(),
                    LAND_VAR = readr::col_number(),
                    LOWER_LANDING = readr::col_number(),
                    UPPER_LANDING = readr::col_number(),
                    PSE_L = readr::col_double(),
                    MRIP_STD_LANDING = readr::col_character(),
                    STAT_SIG_LANDING = readr::col_character(),
                    ESTREL = readr::col_number(),
                    ESTRLVAR = readr::col_number(),
                    LOWER_ESTREL = readr::col_number(),
                    UPPER_ESTREL = readr::col_number(),
                    PSE_B2 = readr::col_double(),
                    MRIP_STD_ESTREL = readr::col_character(),
                    STAT_SIG_ESTREL = readr::col_character(),
                    TOT_CAT = readr::col_number(),
                    TOT_VAR = readr::col_number(),
                    LOWER_TOT_CAT = readr::col_number(),
                    UPPER_TOT_CAT = readr::col_number(),
                    PSE_TC = readr::col_double(),
                    MRIP_STD_TOT_CAT = readr::col_character(),
                    STAT_SIG_TOT_CAT = readr::col_character(),
                    LBS_AB1 = readr::col_number(),
                    VAR_LBS = readr::col_number(),
                    LOWER_LBS_AB1 = readr::col_number(),
                    UPPER_LBS_AB1 = readr::col_number(),
                    PSE_WL = readr::col_double(),
                    MRIP_STD_LBS_AB1 = readr::col_character(),
                    STAT_SIG_LBS_AB1 = readr::col_character(),
                    WGT_AB1 = readr::col_number(),
                    VAR_WAB1 = readr::col_number(),
                    LOWER_WGT_AB1 = readr::col_number(),
                    UPPER_WGT_AB1 = readr::col_number(),
                    PSE_WK = readr::col_double(),
                    MRIP_STD_WGT_AB1 = readr::col_character(),
                    STAT_SIG_WGT_AB1 = readr::col_character(),
                    TOT_LEN = readr::col_number(),
                    VARTOTLEN = readr::col_number(),
                    LOWER_TOT_LEN = readr::col_number(),
                    UPPER_TOT_LEN = readr::col_number(),
                    PSE_TL = readr::col_double(),
                    MRIP_STD_TOT_LEN = readr::col_character(),
                    STAT_SIG_TOT_LEN = readr::col_character(),
                    MISS_FISH = readr::col_number()
                  )
  )
}


csvlist <- list.files(here::here("data-raw/MRIP/ignore_zips/mrip_catch_bywave_csvs"), full.names = TRUE)

allbywave <- purrr::map_dfr(csvlist, read_mrip_catch_bywave)

saveRDS(allbywave, here::here("data-raw/MRIP/allbywave19812025.rds"))

