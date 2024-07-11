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
})
