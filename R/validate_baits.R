get_line_and_baits <- function(ig_posicion) {
  lines_baits <- get_line_and_atrayente(ig_posicion)
  check_baits(lines_baits)
  lines_baits |>
    unique()
}

check_baits <- function(ig_posicion) {
  lines_baits <- get_line_and_atrayente(ig_posicion)
  if (!is_there_an_unique_bait_per_line(lines_baits)) {
    stop(glue::glue("🚨 We have more than one bait per line"))
  }
}

is_there_an_unique_bait_per_line <- function(lines_baits) {
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
