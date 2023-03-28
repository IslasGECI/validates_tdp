#' @import dplyr

#' @export
write_transect_and_coordinates_table <- function(output_path, id_start, transect_path, coordinates_path, species = "Conejos") {
  transects_data <- read_csv(transect_path, show_col_types = FALSE)
  coordinates_data <- read_csv(coordinates_path, show_col_types = FALSE)
  joined_data <- join_coordinates_and_transects(transects_data, coordinates_data, id_start, species)
  write_csv(joined_data, output_path)
}

join_coordinates_and_transects <- function(transects_data, coordinates_data, id_start = 1, species = "Conejos") {
  native_fauna_columns <- c(
    "Id",
    "Fecha",
    "Hora_inicio",
    "Hora_final",
    "Especie",
    "Grupo",
    "Transecto",
    "Punto_del_transecto",
    "Cantidad_individuos",
    "Distancia",
    "Individuos_fuera_de_monitoreo",
    "Cantidad_aves_sobrevolando",
    "Tipo_de_vegetacion",
    "Porcentaje_nubosidad",
    "Velocidad_viento",
    "Temperatura",
    "Humedad",
    "Observaciones"
  )
  columns_for_species <- list(
    "Conejos" = c(
      "Id",
      "Temporada",
      "Fecha",
      "Hora_inicio",
      "Hora_final",
      "Isla",
      "Especie",
      "Fase",
      "Transecto",
      "Area_isla",
      "Cantidad_individuos",
      "Longitud",
      "Distancia",
      "Tipo_de_vegetacion",
      "Porcentaje_nubosidad",
      "Velocidad_viento",
      "Temperatura",
      "Humedad",
      "Observaciones"
    ),
    "Tecolotes" = native_fauna_columns,
    "Reptiles" = native_fauna_columns,
    "Aves" = native_fauna_columns
  )
  transects_data <- process_transect_data(transects_data, id_start, species)
  coordinates_data <- process_coordinates_data(coordinates_data, species)
  if (species == "Aves") {
    return(left_join(transects_data, coordinates_data, by = c("Transecto" = "Nombre_transecto", "Punto_del_transecto" = "Punto_del_transecto"), multiple = "first") |>
      select(columns_for_species[[species]]))
  }
  return(left_join(transects_data, coordinates_data, by = c("Transecto" = "Nombre_transecto"), multiple = "first") |>
    select(columns_for_species[[species]]))
}

process_transect_data <- function(transects_data, id_start, species) {
  groups <- list("Conejos" = "Conejos", "Reptiles" = "Reptil", "Tecolotes" = "Tecolote", "Aves" = "Ave")
  if (species == "Aves") {
    return(process_bird_transect(transects_data, id_start, species, groups))
  }
  return(process_native_except_bird_transect(transects_data, id_start, species, groups))
}

process_native_except_bird_transect <- function(transects_data, id_start, species, groups) {
  transects_data |>
    mutate(Temporada = as.numeric(substring(Fecha, nchar(Fecha) - 3, nchar(Fecha)))) |>
    mutate(Id = assign_id(transects_data, id_start)) |>
    mutate(Fase = "Conteo/Diagnostico") |>
    mutate(Fecha = transform_date_format(Fecha, "%d/%m/%Y")) |>
    mutate(Transecto = rename_transects(transects_data, species)) |>
    mutate(Grupo = groups[[species]]) |>
    rename(c(Cantidad_individuos = `# individuos`, Distancia = `Distancia (m)`, Tipo_de_vegetacion = `Tipo de Vegetación`)) |>
    mutate(Individuos_fuera_de_monitoreo = "NA") |>
    mutate(Cantidad_aves_sobrevolando = "NA")
}

process_bird_transect <- function(transects_data, id_start, species, groups) {
  transects_data |>
    mutate(Temporada = as.numeric(substring(Fecha, nchar(Fecha) - 3, nchar(Fecha)))) |>
    mutate(Id = assign_id(transects_data, id_start)) |>
    mutate(Fase = "Conteo/Diagnostico") |>
    mutate(Fecha = transform_date_format(Fecha, "%d/%m/%Y")) |>
    mutate(Transecto = rename_transects(transects_data, species)) |>
    mutate(Grupo = groups[[species]]) |>
    rename(`Punto_del_transecto` = `Punto no.`) |>
    rename(c(Cantidad_individuos = `# individuos`, Distancia = `Distancia (m)`, Tipo_de_vegetacion = `Tipo de Vegetación`)) |>
    mutate(Individuos_fuera_de_monitoreo = "NA") |>
    mutate(Cantidad_aves_sobrevolando = "NA")
}

process_coordinates_data <- function(coordinates_data, species = "Conejos") {
  rabbits_columns <- c("Nombre_transecto", "Area_isla", "Longitud")
  native_fauna_columns <- c(rabbits_columns, "Punto_del_transecto")
  used_columns <- list(
    "Conejos" = rabbits_columns,
    "Tecolotes" = native_fauna_columns,
    "Reptiles" = native_fauna_columns,
    "Aves" = native_fauna_columns
  )
  coordinates_data |>
    rename(Longitud = Longitud_transecto) |>
    select(all_of(used_columns[[species]]))
}

rename_transects <- function(transects_data, species = "Conejos") {
  apply(transects_data["Transecto no."], 2, paste_transect, species = species)[, 1]
}

paste_transect <- function(transect_number, species) {
  paste0(glue::glue("{species}_"), stringr::str_pad(as.character(transect_number), 2, pad = "0"))
}

assign_id <- function(transects_data, starting_id = 1) {
  (starting_id):(nrow(transects_data) + starting_id - 1)
}
