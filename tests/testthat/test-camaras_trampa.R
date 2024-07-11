library("tidyverse")

camaras_trampa <- read_csv("/workdir/tests/data/camaras_trampa_gatos_isla_guadalupe_revision_campo.csv", show_col_types = FALSE)

is_id_consistent_with_zone <- function() {
  zones_from_id <- strtoi(str_match(camaras_trampa$ID_camara_trampa, "-0([1-8])-")[, 2])
  is_each_id_consistent_with_zone <- zones_from_id == camaras_trampa$Zona
  return(all(is_each_id_consistent_with_zone))
}

describe("ID is consisitent with zone", {
  it("ID is consistent", {
    expect_true(is_id_consistent_with_zone())
  })
})
