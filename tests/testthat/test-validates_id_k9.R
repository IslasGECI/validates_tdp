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
  it("Wrapp function to recieve path", {
    k9_traces_error_path <- "../data/registros_rastros_k9_guadalupe.csv"
    k9_traces_clean_path <- "../data/registros_rastros_k9_clean_id.csv"
    expect_no_error(check_traces(k9_traces_clean_path))
    expect_error(check_traces(k9_traces_error_path), "🚨 Rows 5, 7, and 14 have different traces")
  })
})
