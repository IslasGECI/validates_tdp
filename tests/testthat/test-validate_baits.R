describe("Check baits", {
  ig_posicion <- readr::read_csv("tests/data/IG_POSICION_TRAMPAS_03SEP2023.csv", show_col_types = FALSE)
  it("Select columns of interest", {
    obtained <- get_line_and_atrayente(ig_posicion)
    expected_columns <- c("Linea", "Atrayente")
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_columns)
  })
  it("one bait per line", {

  })
})
