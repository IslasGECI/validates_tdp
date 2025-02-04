#' @export
check_all_ids_in_list_are_in_daily_status <- function(daily_status_path, traps_list_path) {
  daily_status <- readr::read_csv(daily_status_path, show_col_types = FALSE)
  traps_list <- readr::read_csv(traps_list_path, show_col_types = FALSE)
  are_all_ids <- .are_all_ids_in_use(traps_list, daily_status)
  should_stop(are_all_ids)
}

should_stop <- function(are_all_ids) {
  if (!are_all_ids$is_right) {
    extra_ids <- glue::glue_collapse(are_all_ids$extra_ids, ", ", last = ", and ")
    message_extras <- glue::glue("🚨 ID not present in daily status table: {extra_ids}")
    stop(message_extras)
  }
}


.are_all_ids_in_use <- function(traps_list, daily_status) {
  condition <- traps_list$ID %in% daily_status$ID_de_trampa
  are_all_ids <- list(is_right = all(condition), extra_ids = .extract_extra_ids(traps_list, condition))
  return(are_all_ids)
}

.extract_extra_ids <- function(traps_list, condition) {
  traps_list |>
    filter(!condition) |>
    pull(ID)
}
