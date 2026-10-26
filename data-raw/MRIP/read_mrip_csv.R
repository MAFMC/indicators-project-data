# Read in the MRIP data downloaded from their website query tool

# test <- readr::read_csv(here::here("data-raw/MRIP/test"))

# Code draft from Claude Sonnet 5.5, merged and corrected by Sarah G

read_mrip_csv <- function(path, header_pattern = NULL, n_meta = NULL) {
  lines <- readr::read_lines(path)

  # Figure out where the data header row is
  if (!is.null(n_meta)) {
    # Option 1: you know exactly how many metadata lines there are
    header_line <- n_meta + 1
  } else if (!is.null(header_pattern)) {
    # Option 2: find the header row by a regex (e.g. "^Date,|^ID,")
    header_line <- which(stringr::str_detect(lines, header_pattern))[1]
    if (is.na(header_line)) stop("header_pattern not found in file")
  } else {
    # Option 3: guess -- first line matching the most common comma count
    n_commas <- stringr::str_count(lines, ",")
    modal    <- as.integer(names(which.max(table(n_commas[n_commas > 0]))))
    header_line <- which(n_commas == modal)[1]
  }
  
  # the MRIP downloads start lines with \? which is not read in correctly
  # read_lines results in the character sequence \xb7 instead of ?
  # this code to get parameters now assumes that oddity
  
  #meta_lines <- stringr::str_trim(lines[seq_len(header_line - 1)])
  meta_lines <- stringi::stri_enc_toutf8(lines[seq_len(header_line - 1)])
  #meta_lines <- stringi::stri_enc_toascii(lines[seq_len(header_line - 1)])
  
  # Drop blanks and junk lines (e.g. a lone quote mark) with no letters or digits
  meta_lines <- meta_lines[stringr::str_detect(meta_lines, "[[:alnum:]]")]
  
  is_param <- stringr::str_starts(meta_lines, "\xb7")
  q_lines  <- stringr::str_remove(meta_lines[is_param], "^\xb7")
  has_kv   <- stringr::str_detect(q_lines, ":")
  
  # "?Key: Value" lines -> key/value tibble
  kv <- stringr::str_split_fixed(q_lines[has_kv], ":", 2)
  params <- tibble::tibble(
    key   = stringr::str_trim(kv[, 1]),
    value = stringr::str_trim(kv[, 2])
  )
  
  # "?WEIGHT OF FISH (KILOGRAMS)" -> what is being measured
  measure <- stringr::str_trim(q_lines[!has_kv])
  
  # Everything else is descriptive notes; strip HTML and the "Information:" heading
  notes <- meta_lines[!is_param] |>
    stringr::str_remove_all("<[^>]+>") |>
    stringr::str_squish()
  notes <- notes[!notes %in% c("Information:", "Marine Recreational Information Program Query Results", "Your Query Parameters:")]
  
  title <- meta_lines[1]
  
  # Read data from the lines themselves, avoiding any skip/blank-line quirks
  data <- readr::read_csv(
    I(lines[header_line:length(lines)]),
    show_col_types = FALSE
  )
  
  structure(
    list(
      data     = data,
      title    = title,
      params   = params,
      measure  = measure,
      notes    = notes,
      meta_raw = lines[seq_len(header_line - 1)],
      source   = normalizePath(path)
    ),
    class = "mrip_csv"
  )
}

print.mrip_csv <- function(x, ...) {
  cat("<mrip_csv>", x$title, "\n")
  cat("Source:", x$source, "\n")
  cat("Measure:", paste(x$measure, collapse = "; "), "\n\n")
  print(x$params)
  cat("\n", length(x$notes), " notes stored in $notes\n\n", sep = "")
  print(x$data)
  invisible(x)
}

# Usage
# obj <- read_mrip_csv("mrip_bluefish.csv")
# 
# obj$data      # tibble of the actual estimates
# obj$params    # Query, Year, Summary, Fishing Year, Geographic Area, Species, ...
# obj$measure   # "WEIGHT OF FISH (KILOGRAMS)"
# obj$notes     # character vector of the caveats (PSE, calibration, etc.)
# 
# # Pull a single parameter
# obj$params$value[obj$params$key == "Species"]

# path <- here::here("data-raw/MRIP/mrip_BLUEFISH_catch_series.csv")

#test <- read_mrip_csv(here::here("data-raw/MRIP/mrip_SCUP_catch_series.csv"))

