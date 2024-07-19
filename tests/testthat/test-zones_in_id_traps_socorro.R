describe("ID is consisitent with zone", {
  correct_socorro_id_traps_path <- "/workdir/tests/data/correct_id_zone_morphometry_socorro.csv"
  correct_traps <- readr::read_csv(correct_socorro_id_traps_path, show_col_types = FALSE)
  wrong_socorro_id_traps_path <- "/workdir/tests/data/wrong_id_zone_morphometry_socorro.csv"
  it("Check ID's and zones consistency in Guadalupe", {
    expect_no_error(check_trap_ids_and_zones_socorro(correct_socorro_id_traps_path))
    expect_error(check_trap_ids_and_zones_socorro(wrong_socorro_id_traps_path), "🚨 Rows 3, 4, and 7 have different zones in ID")
  })
  it("ID is consistent", {
    id_column <- "ID_camara_trampa"
    obtained <- is_id_consistent_with_zone(correct_traps, id_column)
    expect_true(obtained)
  })
  it("Get zone number from id", {
    id_column_name <- "ID_guadalupe"
    camaras_trampa <- tibble::tibble(ID_guadalupe = c("XX-01-XXXX-XX", "XX-03-XXXX-XX", "XX-08-XXXX-XX"))
    obtained <- get_zones_from_id(camaras_trampa, id_column_name)
    expected <- c(1, 3, 8)
    expect_equal(obtained, expected)

    id_column_name <- "ID_socorro"
    camaras_trampa <- tibble::tibble(ID_socorro = c("XX-10-XXXX-XX", "XX-30-XXXX-XX", "XX-08-XXXX-XX"))
    obtained <- get_zones_from_id(camaras_trampa, id_column_name)
    expected <- c(10, 30, 8)
    expect_equal(obtained, expected)
  })
})
