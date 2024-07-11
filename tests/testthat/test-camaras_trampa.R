library("tidyverse")

camaras_trampa <- read_csv("/workdir/tests/data/camaras_trampa_gatos_isla_guadalupe_revision_campo.csv", show_col_types = FALSE)

describe("ID is consisitent with zone", {
  it("ID is consistent", {
    obtained <- is_id_consistent_with_zone(camaras_trampa)
    expect_true(obtained)
  })
})
