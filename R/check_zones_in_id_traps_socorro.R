#' @export
check_trap_ids_and_zones_socorro <- function(cameras_path) {
  cameras_data <- readr::read_csv(cameras_path, show_col_types = FALSE)
  config <- list(
    id_column_name = "ID_de_trampa",
    variable = "Zona",
    message_for_id_and_zones = "have different zones in ID"
  )
  stop_if_variable_in_id_and_variable_column_are_wrong(cameras_data, config)
}
