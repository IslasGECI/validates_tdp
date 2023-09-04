describe("Check baits", {
  ig_posicion <- readr::read_csv("/workdir/tests/data/IG_POSICION_TRAMPAS_03SEP2023.csv", show_col_types = FALSE)
  correct_ig_posicion <- tibble::tibble(Linea = rep("Linea 146", 3), Atrayente = rep("Cebada con cebo", 3))
  it("get_line_and_baits", {
    obtained <- get_line_and_baits(correct_ig_posicion)
    obtained_rows <- nrow(obtained)
    expected_rows <- 1
    expect_equal(obtained_rows, expected_rows)
  })
  it("check baits", {
    expect_error(check_baits(ig_posicion), "🚨 We have more than one bait per line")
  })
  it("Select columns of interest", {
    obtained <- get_line_and_atrayente(ig_posicion)
    expected_columns <- c("Linea", "Atrayente")
    obtained_columns <- colnames(obtained)
    expect_equal(obtained_columns, expected_columns)
  })
  it("one bait per line", {
    obtained <- is_there_an_unique_bait_per_line(correct_ig_posicion)
    expect_true(obtained)
    wrong_ig_posicion <- tibble::tibble(Linea = rep("Linea 146", 3), Atrayente = c("Cebada con cebo", "Cebada con cebo", "cebo"))
    obtained <- is_there_an_unique_bait_per_line(wrong_ig_posicion)
    expect_false(obtained)
  })
})
