check_id_and_zones_guadalupe <- function(cameras_path) {
  cameras_data <- readr::read_csv(cameras_path, show_col_types = FALSE)
  id_column_name <- "ID_camara_trampa"
  zones_from_id <- get_zones_from_id(cameras_data, id_column_name)
  no_equal_indexes <- which(zones_from_id != cameras_data$Zona)
  is_different <- length(no_equal_indexes) > 0
  if (is_different) {
    different_rows <- glue::glue_collapse(no_equal_indexes, ", ", last = ", and ")
    stop(glue::glue("🚨 Rows {different_rows} have different zones in ID"))
  }
}

is_id_consistent_with_zone <- function(camaras_trampa, id_column_name) {
  zones_from_id <- get_zones_from_id(camaras_trampa, id_column_name)
  is_each_id_consistent_with_zone <- zones_from_id == camaras_trampa$Zona
  return(all(is_each_id_consistent_with_zone))
}

get_zones_from_id <- function(camaras_trampa, id_column_name) {
  strtoi(stringr::str_match(camaras_trampa[[id_column_name]], "-0([1-8])-")[, 2])
}
