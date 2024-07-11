split_id <- function(id_punto) {
  if (is.na(id_punto)) {
    return(rep(NA, 4))
  }
  stringr::str_split(id_punto, "-")[[1]]
}

check_trace_from_id <- function(dataframe) {
  splited_ids <- sapply(dataframe$ID_punto, split_id, simplify = FALSE, USE.NAMES = FALSE)
  trace_from_id <- sapply(splited_ids, `[[`, 4)
  traces <- dataframe$Tipo_de_rastro
  no_equal_indexes <- which(trace_from_id != traces)
  message_for_traces <- "have different traces"
  stop_with_message(no_equal_indexes, message_for_traces)
}

#' @export
check_traces <- function(k9_traces_path = "data/esfuerzos_k9_gatos_guadalupe/registros_rastros_de_gatos_k9_guadalupe.csv") {
  data_traces <- readr::read_csv(k9_traces_path, show_col_types = FALSE)
  check_trace_from_id(data_traces)
}
