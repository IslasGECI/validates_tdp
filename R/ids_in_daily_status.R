check_all_ids_in_list_are_in_daily_status <- function(daily_status_path, traps_list_path) {
  daily_status <- readr::read_csv(daily_status_path)
  traps_list <- readr::read_csv(traps_list_path)
  are_all_ids <- all(traps_list$ID %in% daily_status$ID_de_trampa)
  if (!are_all_ids) {
    stop()
  }
}
