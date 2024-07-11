describe("Check baits", {
  ig_posicion <- readr::read_csv("/workdir/tests/data/IG_POSICION_TRAMPAS_03SEP2023.csv", show_col_types = FALSE)
  correct_ig_posicion <- tibble::tibble(Linea = rep("Linea 146", 3), Atrayente = rep("Cebada con cebo", 3))
  it("get_line_and_baits", {
    obtained <- get_line_and_baits(correct_ig_posicion)
    obtained_rows <- nrow(obtained)
    expected_rows <- 1
    expect_equal(obtained_rows, expected_rows)
    expect_error(get_line_and_baits(ig_posicion), "🚨 We have more than one bait per line")
  })
  it("Add last date: Tidy version for bait in each line", {
    skip("🥇 Gold test for tidy bait table: We need to change for ID instead of Line")
    correct_ig_posicion_with_dates <- readr::read_csv("/workdir/tests/data/input_add_last_date.csv")
    obtained <- add_last_date(correct_ig_posicion_with_dates)
    obtained_columns <- colnames(obtained)
    expected_columns <- c("Date", "ID", "Atrayente")
    expect_equal(obtained_columns, expected_columns)
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
