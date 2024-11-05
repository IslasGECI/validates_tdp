check_all_ids_in_list_are_in_daily_status <- function(daily_status_path, traps_list_path) {
  daily_status <- readr::read_csv(daily_status_path)
  traps_list <- readr::read_csv(traps_list_path)
  are_all_ids <- .are_all_ids(traps_list, daily_status)
  should_stop(are_all_ids)
}

should_stop <- function(are_all_ids) {
  if (!are_all_ids$is_right) {
    stop()
  }
}


.are_all_ids <- function(traps_list, daily_status) {
  are_all_ids <- list(is_right = all(traps_list$ID %in% daily_status$ID_de_trampa))
  return(are_all_ids)
}
