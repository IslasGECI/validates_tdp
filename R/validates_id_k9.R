split_id <- function(id_punto) {
  if (is.na(id_punto)) {
    return(rep(NA, 4))
  }
  stringr::str_split(id_punto, "-")[[1]]
}

stop_if_id_trace_and_trace_column_are_wrong <- function(dataframe) {
  id_column_name <- "ID_punto"
  variable <- "Tipo_de_rastro"
  no_equal_indexes <- get_wrong_row_id_and_variable_column(dataframe, id_column_name, variable)
  message_for_traces <- "have different traces"
  stop_with_message(no_equal_indexes, message_for_traces)
}

get_trace_from_id <- function(dataframe, id_column_name) {
  splited_ids <- sapply(dataframe[[id_column_name]], split_id, simplify = FALSE, USE.NAMES = FALSE)
  sapply(splited_ids, `[[`, 4)
}

#' @export
check_traces <- function(k9_traces_path = "data/esfuerzos_k9_gatos_guadalupe/registros_rastros_de_gatos_k9_guadalupe.csv") {
  data_traces <- readr::read_csv(k9_traces_path, show_col_types = FALSE)
  config <- list(
    id_column_name = "ID_punto",
    variable = "Tipo_de_rastro",
    message_for_id_and_zones = "have different traces"
  )
  stop_if_variable_in_id_and_variable_column_are_wrong(data_traces, config)
}
