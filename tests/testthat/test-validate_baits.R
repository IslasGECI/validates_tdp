describe("Check baits", {
  ig_posicion <- readr::read_csv("/workdir/tests/data/IG_POSICION_TRAMPAS_03SEP2023.csv", show_col_types = FALSE)
  it("Select columns of interest", {
    obtained <- get_line_and_atrayente(ig_posicion)
    expected_columns <- c("Linea", "Atrayente")
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_columns)
  })
  it("one bait per line", {
    correct_ig_posicion <- tibble::tibble(Linea = rep("Linea 146", 3), Atrayente = rep("Cebada con cebo", 3))
    obtained <- is_there_an_unique_bait_per_line(correct_ig_posicion)
    expect_true(obtained)
    wrong_ig_posicion <- tibble::tibble(Linea = rep("Linea 146", 3), Atrayente = c("Cebada con cebo", "Cebada con cebo", "cebo"))
    obtained <- is_there_an_unique_bait_per_line(wrong_ig_posicion)
    expect_false(obtained)
  })
})
