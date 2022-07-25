test_that("ro_lint_md says all good when no issue", {
  path <- system.file(file.path("examples", "allgood.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})

test_that("ro_lint_md find alt issues", {
  path <- system.file(file.path("examples", "bad-no-alt.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})

test_that("ro_lint_md find embedded tweets issues", {
  path <- system.file(file.path("examples", "twitter-embed.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})

test_that("ro_lint_md finds absolute links", {
  path <- system.file(file.path("examples", "absolute-links.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})

test_that("ro_lint_md finds figures not using shortcodes", {
  path <- system.file(file.path("examples", "figureissue.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})


test_that("ro_lint_md finds click here links", {
  path <- system.file(file.path("examples", "clickhereissue.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})


test_that("ro_lint_md with multiple problems", {
  path <- system.file(file.path("examples", "multi-bad.md"),
    package = "roblog"
  )
  withr::local_seed(42)
  expect_snapshot(ro_lint_md(path))
})
