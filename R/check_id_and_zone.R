#' @export
check_cameras_id_and_zones_guadalupe <- function(cameras_path) {
  cameras_data <- readr::read_csv(cameras_path, show_col_types = FALSE)
  config <- list(
    id_column_name = "ID_camara_trampa",
    variable = "Zona",
    message_for_id_and_zones = "have different zones in ID"
  )
  stop_if_variable_in_id_and_variable_column_are_wrong(cameras_data, config)
}

stop_if_variable_in_id_and_variable_column_are_wrong <- function(cameras_data, config) {
  no_equal_indexes <- get_wrong_row_id_and_variable_column(cameras_data, config$id_column_name, config$variable)
  stop_with_message(no_equal_indexes, config$message_for_id_and_zones)
}

get_wrong_row_id_and_variable_column <- function(cameras_data, id_column_name, variable) {
  get_variables_from_id <- list("Zona" = get_zones_from_id, "Tipo_de_rastro" = get_trace_from_id)
  zones_from_id <- get_variables_from_id[[variable]](cameras_data, id_column_name)
  zonas <- cameras_data[[variable]]
  which(zones_from_id != zonas)
}
stop_with_message <- function(no_equal_indexes, message_string) {
  is_different <- length(no_equal_indexes) > 0
  if (is_different) {
    different_rows <- glue::glue_collapse(no_equal_indexes, ", ", last = ", and ")
    stop(glue::glue("🚨 Rows {different_rows} {message_string}"))
  }
}

is_id_consistent_with_zone <- function(camaras_trampa, id_column_name) {
  zones_from_id <- get_zones_from_id(camaras_trampa, id_column_name)
  is_each_id_consistent_with_zone <- zones_from_id == camaras_trampa$Zona
  return(all(is_each_id_consistent_with_zone))
}

get_zones_from_id <- function(camaras_trampa, id_column_name) {
  matchs <- stringr::str_match(camaras_trampa[[id_column_name]], "-(0([1-8])|([1-7])0)-")
  print(matchs)
  return(as.integer(matchs[, 2]))
}
