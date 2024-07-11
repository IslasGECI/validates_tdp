is_id_consistent_with_zone <- function(camaras_trampa, id_column_name) {
  zones_from_id <- strtoi(str_match(camaras_trampa[[id_column_name]], "-0([1-8])-")[, 2])
  is_each_id_consistent_with_zone <- zones_from_id == camaras_trampa$Zona
  return(all(is_each_id_consistent_with_zone))
}
