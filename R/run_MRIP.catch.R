# try running MRIP scripts provided with full dataset
# need the catch and trip csvs for each year and wave in a subdirectory named intYYYY
# missing function svydesign, apparently in R survey
# https://cran.r-project.org/web/packages/survey/survey.pdf

library(survey)

test2025 <-  MRIP.catch(intdir=here::here("data-raw/MRIP/ignore_zips"),
                        common="BLUEFISH",
                        st=c(10, 24, 34, 36, 51), #Mid Atlantic
                        styr=2025,
                        endyr=2025,
                        dom=NULL) # not specifying gives standard output

# validated that the sum of the weight column in test2025 is equal to the
# 2025 `Harvest (A+B1) Total Weight (kg)` value from the web query for the Mid

#sum(test2025$weight)
#[1] 964042

#> bluerec$data$`Harvest (A+B1) Total Weight (kg)`
#[1] 34223591 28604765 32211370 21445076 20592733 29241757 31061126 13979692 15250319 10832534 10626982  7203117  4682021  3596590  4266276  4107550  3231220  5371371
#[19]  3999085  3519582  5200063  3481261  4477645  5797275  6730139  4771541  7221124  5948957  6038400  5507308  4566973  4646694  4830215  4031557  4940889  5418376
#[37]  5681970  1767835  2386539  1418315  2336968  1830323  2081063  2242440   964042


test2325 <-  MRIP.catch(intdir=here::here("data-raw/MRIP/ignore_zips"),
                        common="BLUEFISH",
                        st=c(10, 24, 34, 36, 51), #Mid Atlantic
                        styr=2023,
                        endyr=2025,
                        dom=NULL) # not specifying gives standard output

# test2325 |> dplyr::group_by(year) |> dplyr::summarise(harvwtkg = sum(weight))
#
# # A tibble: 3 × 2
# year  harvwtkg
# <chr>    <dbl>
# 1 2023  2081063.
# 2 2024  2242440.
# 3 2025   964042.
