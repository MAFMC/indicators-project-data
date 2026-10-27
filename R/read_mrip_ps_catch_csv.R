# if I try to read the original data and sum it to get the full dataset I will need to specify columns
# otherwise it will read the really long ID codes as numeric and convert then to sci notation
# which renders them meaningless
# change them to integers? nope

read_mrip_ps_catch_csv <- function(path) {

  readr::read_csv(path,
                  col_types = list(
                    COMMON = readr::col_character(),
                    STRAT_ID = readr::col_character(),
                    PSU_ID = readr::col_character(), #readr::col_integer(), #col_double(),
                    SP_CODE = readr::col_double(), #this one is ok as double, saved as full number
                    KOD = readr::col_character(),
                    YEAR = readr::col_double(),
                    ST = readr::col_double(),
                    ID_CODE = readr::col_character(), #readr::col_integer(), #col_double(),
                    WAVE = readr::col_double(),
                    SUB_REG = readr::col_double(),
                    MODE_FX = readr::col_double(),
                    AREA_X = readr::col_double(),
                    CLAIM = readr::col_double(),
                    RELEASE = readr::col_double(),
                    HARVEST = readr::col_double(),
                    CLAIM_UNADJ = readr::col_double(),
                    HARVEST_UNADJ = readr::col_double(),
                    RELEASE_UNADJ = readr::col_double(),
                    TOT_LEN_A = readr::col_double(),
                    WGT_A = readr::col_double(),
                    TOT_LEN_B1 = readr::col_double(),
                    WGT_B1 = readr::col_double(),
                    REGION = readr::col_double(),
                    TOT_CAT = readr::col_double(),
                    WGT_AB1 = readr::col_double(),
                    TOT_LEN = readr::col_double(),
                    LANDING = readr::col_double(),
                    VAR_ID = readr::col_character(),
                    ARX_METHOD = readr::col_logical(),
                    ALT_FLAG = readr::col_double(),
                    STRAT_INTERVAL = readr::col_logical(),
                    FL_REG = readr::col_double(),
                    WP_INT = readr::col_double(),
                    WP_CATCH = readr::col_double(),
                    MONTH = readr::col_character(),
                    DATE_PUBLISHED = readr::col_character()
                  )
  )

}
