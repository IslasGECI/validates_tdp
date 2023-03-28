transect_path <- "../data/conejos_clarion.csv"
transects_data <- read_csv(transect_path, show_col_types = FALSE)
coordinates_path <- "../data/coordenadas_transectos_conejos_clarion_2018-2021.csv"
coordinates_data <- read_csv(coordinates_path, show_col_types = FALSE)

coordinates_path_tecolotes <- "../data/transectos_isla_clarion.csv"
transect_path_tecolotes <- "../data/tecolotes_clarion.csv"
describe("Write joined tables", {
  it("Write joined table for conejos (default)", {
    output_path <- "../data/joined_table.csv"
    testtools::delete_output_file(output_path)
    id_start <- 678
    write_transect_and_coordinates_table(output_path, id_start, transect_path, coordinates_path)
    expect_true(testtools::exist_output_file(output_path))
  })
  it("Write joined table for Tecolotes", {
    output_path <- "../data/joined_tecolote_table.csv"
    testtools::delete_output_file(output_path)
    id_start <- 678
    species <- "Tecolotes"
    write_transect_and_coordinates_table(output_path, id_start, transect_path_tecolotes, coordinates_path_tecolotes, species)
    expect_true(testtools::exist_output_file(output_path))
  })
})
describe(
  "Join tables",
  {
    obtained <- join_coordinates_and_transects(transects_data, coordinates_data)
    it("Check rabbit table structure", {
      obtained_columns <- colnames(obtained)
      expected_columns <- c(
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
      )
      expect_equal(obtained_columns, expected_columns)
    })
    it("Check tecolotes table structure", {
      species <- "Tecolotes"
      transects_data_tecolotes <- read_csv(transect_path_tecolotes, show_col_types = FALSE)
      coordinates_data_tecolotes <- read_csv(coordinates_path_tecolotes, show_col_types = FALSE)
      obtained <- join_coordinates_and_transects(transects_data_tecolotes, coordinates_data_tecolotes, species = species)
      obtained_columns <- colnames(obtained)
      expected_columns <- c(
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
      expect_equal(obtained_columns, expected_columns)
    })
    it("Check bird table contents", {
      species <- "Aves"
      transect_path_birds <- "../data/aves_2022.csv"
      transect_data_birds <- read_csv(transect_path_birds, show_col_types = FALSE)
      expected_transect_points <- transect_data_birds[["Punto no."]]
      coordinates_data_birds <- read_csv(coordinates_path_tecolotes, show_col_types = FALSE)
      obtained <- join_coordinates_and_transects(transect_data_birds, coordinates_data_birds, species = species)
      obtained_transect_points <- obtained$Punto_del_transecto
      expect_equal(obtained_transect_points, expected_transect_points)
    })
    it("Check season column", {
      obtained_season <- obtained$Temporada
      expected_season <- c(2012, 2019, 2021, rep(2022, 12))
      expect_equal(obtained_season, expected_season)
    })
    it("Check transect column", {
      obtained_transect <- obtained$Transecto
      expected_transect <- c(
        "Conejos_01",
        rep("Conejos_03", 2),
        rep("Conejos_04", 2),
        rep("Conejos_05", 3),
        rep("Conejos_04", 2),
        "Conejos_05",
        "Conejos_06",
        rep("Conejos_07", 2),
        "Conejos_11"
      )
      expect_equal(obtained_transect, expected_transect)
    })
  }
)

describe("Prepare cooridinates data", {
  expected_rabbits_columns <- c(
    "Nombre_transecto",
    "Area_isla",
    "Longitud"
  )
  it("Proccess rabbit data", {
    obtained <- process_coordinates_data(coordinates_data)
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_rabbits_columns)
  })
  it("Proccess tecolotes data", {
    expected_tecolotes_columns <- c(
      "Nombre_transecto",
      "Area_isla",
      "Longitud",
      "Punto_del_transecto"
    )
    coordinates_data <- read_csv(coordinates_path_tecolotes, show_col_types = FALSE)
    species <- "Tecolotes"
    obtained <- process_coordinates_data(coordinates_data, species)
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_tecolotes_columns)
  })
})

describe("Assign id", {
  it("assign_id", {
    obtained_ids <- assign_id(transects_data)
    expected_ids <- 1:15
    expect_equal(obtained_ids, expected_ids)
  })
  it("assign_id with starting_id", {
    starting_id <- 7
    obtained_ids <- assign_id(transects_data, starting_id)
    expected_ids <- starting_id:21
    expect_equal(obtained_ids, expected_ids)
  })
})
describe("Rename transectos", {
  it("rename rabbit transect", {
    raw_column <- tibble::tibble("Transecto no." = c(1, 3, 5, 12))
    obtained_column <- rename_transects(raw_column)
    expected_column <- c("Conejos_01", "Conejos_03", "Conejos_05", "Conejos_12")
    expect_equal(obtained_column, expected_column)
  })
  it("rename tecolotes transect", {
    raw_column <- tibble::tibble("Transecto no." = c(1, 3, 5, 12))
    species <- "Tecolotes"
    obtained_column <- rename_transects(raw_column, species = species)
    expected_column <- c("Tecolotes_01", "Tecolotes_03", "Tecolotes_05", "Tecolotes_12")
    expect_equal(obtained_column, expected_column)
  })
})
