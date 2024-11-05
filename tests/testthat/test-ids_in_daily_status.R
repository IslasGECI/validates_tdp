describe("All IDs defined in list are in daily status", {
  correct_daily_status_path <- "/workdir/tests/data/correct_daily_status.csv"
  traps_list_path <- "/workdir/tests/data/traps_ids.csv"

  it("Check all ID's are in ids list", {
    expect_true(check_all_ids_in_list_are_in_daily_status(correct_daily_status_path, traps_list_path))
  })
})
