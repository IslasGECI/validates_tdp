library(testthat)
library(tidyverse)


file_tests <- "/workdir/tests/data_tests/IG_POSICION_TRAMPAS_30AGO2020.csv"
data_tests <- fread(file_tests, drop = c(1:4))

output_tests <- data.frame(
  "tmp_date" = c(
    "Fecha_1", "Fecha_2", "Fecha_3", "Fecha_4", "Fecha_5", "Fecha_6", "Fecha_7"
  ),
  "real_date" = c(
    "24/Ago/2020", "25/Ago/2020", "26/Ago/2020", "27/Ago/2020", "28/Ago/2020", "29/Ago/2020", "30/Ago/2020"
  )
)

test_that("Adquiere fechas desde encabezado de base de datos", {
  expect_equal(transform_data_header(data_tests), output_tests)
})

test_that("Prueba cambio de formato en fecha", {
  expected_date <- "01/May/2022"
  obtained_date <- transform_date_format("2022-05-01")
  expect_equal(expected_date, obtained_date)
  expected_date <- "02/May/2022"
  obtained_date <- transform_date_format("2022-05-02")
  expect_equal(expected_date, obtained_date)
  expected_date <- "06/Ene/2022"
  obtained_date <- transform_date_format("2022-01-06")
  expect_equal(expected_date, obtained_date)
  expected_date <- "06/Abr/2022"
  obtained_date <- transform_date_format("2022-04-06")
  expect_equal(expected_date, obtained_date)

  raw_dates <- c("2022-05-01", "2022-05-02", "2022-01-06")
  obtained_dates <- transform_date_format(raw_dates)
  expected_dates <- c("01/May/2022", "02/May/2022", "06/Ene/2022")
  expect_equal(expected_dates, obtained_dates)

  raw_dates <- c("01/05/2022", "05/05/2022", "06/01/2022")
  date_format <- "%d/%m/%Y"
  obtained_dates <- transform_date_format(raw_dates, date_format)
  expected_dates <- c("01/May/2022", "05/May/2022", "06/Ene/2022")
  expect_equal(expected_dates, obtained_dates)
})


test_that("Concatena columnas con y sin fecha", {
  setwd("/workdir")
  filename <- "tests/data_tests/wrong_dates.csv"
  table_with_wrong_column_names <- read_csv(filename, show_col_types = FALSE)
  table_with_corret_column_names <- fix_date_format_in_column_names(table_with_wrong_column_names)
  obtained_columnames <- colnames(table_with_corret_column_names)
  expected_columnames <- c("ID", "# Trampa", "Zona", "Responsable", "01/May/2022", "02/May/2022", "03/May/2022", "04/May/2022", "05/May/2022", "06/May/2022", "07/May/2022")
  expect_equal(expected_columnames, obtained_columnames)
})
