library(tidyverse)

describe("Check column ID_punt", {
  it("split column ID_punto", {
    id_punto <- "K9-MA-005-MD"
    obtained <- split_id(id_punto)
    obtained_length <- length(obtained)
    expected_length <- 4
    expect_equal(obtained_length, expected_length)

    expected <- c("K9", "MA", "005", "MD")
    expect_equal(obtained, expected)

    id_punto <- NA
    obtained <- split_id(id_punto)
    expected <- rep(NA, 4)
    expect_equal(obtained, expected)
  })
  error_data <- read_csv("../data/registros_rastros_k9_guadalupe.csv", show_col_types = FALSE)
  clean_data <- read_csv("../data/registros_rastros_k9_clean_id.csv", show_col_types = FALSE)
  it("check trace", {
    expect_no_error(check_trace_from_id(clean_data))
    expect_error(check_trace_from_id(error_data), "🚨 Rows 5, 7 and 14 have different traces")
  })
  it("Wrapp function to recieve path", {
    k9_traces_path <- "../data/registros_rastros_k9_guadalupe.csv"
    k9_clean_traces_path <- "../data/registros_rastros_k9_clean_id.csv"
    expect_no_error(check_traces(k9_clean_traces_path))
    expect_error(check_traces(k9_traces_path), "🚨 Rows 5, 7 and 14 have different traces")
  })
})
