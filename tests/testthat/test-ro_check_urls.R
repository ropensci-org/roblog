test_that("ro_check_urls works", {
  path <- system.file(
    file.path("examples", "links.md"),
    package = "roblog"
  )
  testthat::expect_snapshot(ro_check_urls(path))
  path <- system.file(
    file.path("examples", "clickhereissue.md"),
    package = "roblog"
  )
  testthat::expect_snapshot(ro_check_urls(path))
})


