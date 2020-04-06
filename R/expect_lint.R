expect_lint <- function(content, checks, ..., file = NULL) {
  if (is.null(file)) {
    file <- tempfile()
    on.exit(unlink(file))
    writeLines(content, con = file, sep = "\n")
  }

  lints <- lint(file, ...)
  n_lints <- length(lints)
  lint_str <- if (n_lints) {paste0(c("", lints), collapse="\n")} else {""}

  wrong_number_fmt  <- "got %d lints instead of %d%s"
  if (is.null(checks)) {
    msg <- sprintf(wrong_number_fmt, n_lints, length(checks), lint_str)
    return(testthat::expect(n_lints %==% 0L, msg))
  }

  if (!is.list(checks) | !is.null(names(checks))) { # vector or named list
    checks <- list(checks)
  }
  checks[] <- lapply(checks, fix_names, "message")

  if (n_lints != length(checks)) {
    msg <- sprintf(wrong_number_fmt, n_lints, length(checks), lint_str)
    return(testthat::expect(FALSE, msg))
  }

  local({
    itr <- 0L #nolint
    lint_fields <- names(formals(Lint))
    Map(function(lint, check) {
      itr <<- itr + 1L
      lapply(names(check), function(field) {
        if (!field %in% lint_fields) {
          stop(sprintf(
            "check #%d had an invalid field: \"%s\"\nValid fields are: %s\n",
            itr, field, toString(lint_fields)))
        }
        check <- check[[field]]
        value <- lint[[field]]
        msg <- sprintf("check #%d: %s %s did not match %s",
                       itr, field, deparse(value), deparse(check))
        # deparse ensures that NULL, list(), etc are handled gracefully
        exp <- if (field == "message") {
          re_matches(value, check)
        } else {
          isTRUE(all.equal(value, check))
        }
        if (!is.logical(exp)) {
          stop("Invalid regex result, did you mistakenly have a capture group in the regex? Be sure to escape parenthesis with `[]`", call. = FALSE)
        }
        testthat::expect(exp, msg)
      })
    },
    lints,
    checks)
  })

  invisible(NULL)
}
