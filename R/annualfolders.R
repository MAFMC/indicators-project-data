# rearrange the downloaded MRIP files into folders for MRIP.catch to use
# First draft from Claude Sonnet 5.5
# Turned into a function by Sarah G

annualfolders <- function(src_dir, dest_dir){

# Set the folder containing the files
#src_dir <- "path/to/your/folder"

# List all CSV files matching the pattern word_YYYYN.csv
files <- list.files(src_dir, pattern = "^.+_\\d{4}\\d+\\.csv$", full.names = FALSE)

# Extract the 4-digit year from each filename
years <- sub("^.+_(\\d{4})\\d+\\.csv$", "\\1", files)

for (i in seq_along(files)) {
  new_dir <- file.path(dest_dir, paste0("int", years[i]))

  # Create the destination folder if it doesn't exist
  if (!dir.exists(new_dir)) dir.create(new_dir)

  # Move the file, keeping its original name
  file.copy(
    from = file.path(src_dir, files[i]),
    to   = file.path(new_dir, files[i])
  )
}
}

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_2015_2019_csv")
dest_dir <- here::here("data-raw/MRIP/ignore_zips")

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_2010_2014_csv")

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_2005_2009_csv")

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_2000_2004_csv")

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_1995_1999_csv")

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_1990_1994_csv")

src_dir <- here::here("data-raw/MRIP/ignore_zips/ps_1981_1989_csv")

annualfolders(src_dir = src_dir, dest_dir = dest_dir)
