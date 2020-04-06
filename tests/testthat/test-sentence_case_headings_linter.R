test_that("multiplication works", {
  path <- system.file(file.path("examples", "sentencecaseissue.md"),
                      package = "roblog")
  lintr::expect_lint(checks = "Use Sentence case for headings",
                     linter = sentence_case_headings_linter,
                     file = path)
})
