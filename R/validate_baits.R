get_line_and_atrayente <- function(ig_posicion) {
  ig_posicion |>
    dplyr::select("Linea", "Atrayente")
}
