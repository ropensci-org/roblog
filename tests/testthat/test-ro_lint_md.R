test_that("ro_lint_md says all good when no issue", {
  path <- system.file(file.path("examples", "allgood.md"),
    package = "roblog"
  )
  testthat::expect_message(ro_lint_md(path), "All good")
})

test_that("ro_lint_md find alt issues", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
    package = "roblog"
  )
  testthat::expect_message(ro_lint_md(path), "Alternative")
})

test_that("ro_lint_md find embedded tweets issues", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
    package = "roblog"
  )
  testthat::expect_message(ro_lint_md(path), "not Twitter html")
})

test_that("ro_lint_md finds absolute links", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
    package = "roblog"
  )
  testthat::expect_message(ro_lint_md(path), "relative links")
})

test_that("ro_lint_md finds figures not using shortcodes", {
  path <- system.file(file.path("examples", "figureissue.md"),
    package = "roblog"
  )
  testthat::expect_message(ro_lint_md(path), "Hugo shortcode")
})


test_that("ro_lint_md finds click here links", {
  path <- system.file(file.path("examples", "clickhereissue.md"),
    package = "roblog"
  )
  testthat::expect_message(ro_lint_md(path), "click here")
})
