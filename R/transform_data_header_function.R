#' @import data.table
#' @import lubridate
#' @import stringr

#' @export
transform_data_header <- function(csv_data) {
  dates <- names(csv_data)
  tmp_date <- c()
  real_date <- c()
  for (i in 1:length(dates)) {
    tmp_date <- append(tmp_date, paste("Fecha", i, sep = "_"))
    real_date <- append(real_date, dates[i])
  }
  dates_table <- data.frame(
    "tmp_date" = tmp_date,
    "real_date" = real_date
  )
  return(dates_table)
}

#' @export
fix_date_format_in_column_names <- function(input) {
  ind <- get_indices(input)
  table_column_names <- get_fixed_date_column_names(input)
  input_column_names <- colnames(input)
  input_column_names[ind[["first_date_column"]]:ind[["last_date_column"]]] <- table_column_names
  colnames(input) <- input_column_names
  return(input)
}

transform_date_format <- function(wrong_format_date, date_format = "%Y-%m-%d") {
  date <- as.Date(wrong_format_date, date_format) %>% format("%d/%b/%Y")
  date <- str_replace(date, "Jan", "Ene")
  date <- str_replace(date, "Apr", "Abr")
  date <- str_replace(date, "Aug", "Ago")
  date <- str_replace(date, "Dec", "Dic")
  return(date)
}

get_indices <- function(table_with_wrong_column_names) {
  ind <- list("first_date_column" = 5, "last_date_column" = ncol(table_with_wrong_column_names))
  return(ind)
}

get_fixed_date_column_names <- function(table_with_wrong_column_names) {
  ind <- get_indices(table_with_wrong_column_names)
  date_table <- table_with_wrong_column_names[, ind[["first_date_column"]]:ind[["last_date_column"]]]
  wrong_date_columnames <- colnames(date_table)
  correct_date_columnames <- transform_date_format(wrong_date_columnames)
  return(correct_date_columnames)
}
