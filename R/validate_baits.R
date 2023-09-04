validate_unique_bait_per_line <- function(lines_baits) {
  number_of_lines <- lines_baits$Linea |>
    unique() |>
    length()
  number_of_unique_lines_and_baits <- lines_baits |>
    unique() |>
    nrow()
  number_of_lines == number_of_unique_lines_and_baits
}

get_line_and_atrayente <- function(ig_posicion) {
  ig_posicion |>
    dplyr::select("Linea", "Atrayente")
}
