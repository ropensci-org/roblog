test_that("ro_check_urls works", {
  path <- system.file(
    file.path("examples", "bad-no-alt.md"),
    package = "roblog"
  )
  testthat::expect_snapshot(ro_check_urls(path))
})
