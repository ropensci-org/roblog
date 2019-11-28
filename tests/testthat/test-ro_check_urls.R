test_that("ro_check_urls works", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
                      package = "roblog")
  testthat::expect_message(ro_check_urls(path), "Possibly broken URLs: https://masalmon.eu/40004, https://masalmon.eu/400040.")
})
