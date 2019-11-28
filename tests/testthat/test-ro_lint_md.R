test_that("ro_lint_md says all good when no issue", {
  path <- system.file(file.path("examples", "allgood.md"),
                       package = "roblog")
  testthat::expect_message(ro_lint_md(path), "All good")
})

test_that("ro_lint_md find ropensci issues", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
                       package = "roblog")
  testthat::expect_message(ro_lint_md(path), "lower camelCase")
})

test_that("ro_lint_md find alt issues", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
                      package = "roblog")
  testthat::expect_message(ro_lint_md(path), "Alternative")
  path <- system.file(file.path("examples", "bad-no-alt2.md"),
                      package = "roblog")
  testthat::expect_message(ro_lint_md(path), "Alternative")
})

