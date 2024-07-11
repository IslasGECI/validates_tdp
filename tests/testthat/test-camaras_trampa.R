describe("ID is consisitent with zone", {
  correct_guadalupe_camaras_path <- "/workdir/tests/data/camaras_trampa_gatos_isla_guadalupe_revision_campo.csv"
  camaras_trampa <- readr::read_csv(correct_guadalupe_camaras_path, show_col_types = FALSE)
  it("Check ID's and zones consistency in Guadalupe", {
    expect_no_error(check_id_and_zones_guadalupe(correct_guadalupe_camaras_path))
  })
  it("ID is consistent", {
    id_column <- "ID_camara_trampa"
    obtained <- is_id_consistent_with_zone(camaras_trampa, id_column)
    expect_true(obtained)
  })
})
