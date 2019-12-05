#' Create a new rOpenSci (R) Markdown Blog Post
#'
#' @description Create a new rOpenSci Blog Post,
#' either R Markdown (`ro_blog_post_rmd()`) or Markdown (`ro_blog_post_md()`),
#'  or an author file, in RStudio.
#'
#' @export
#'
#' @details Call them via the add-in or directly.
#'
#' `ro_blog_post_md()` and `ro_blog_post_author()` create Markdown files,
#'  RStudio might warn you against saving them as ".md" but ignore that.
#'
#' @rdname blog-posts
ro_blog_post_rmd <- function() {
  rstudioapi::documentNew(glue::glue_collapse(
    readLines(
      system.file(file.path("rmarkdown",
                            "templates",
                            "ropensci-blog-post",
                            "skeleton"), "skeleton.Rmd",
                  package="roblog")),
    sep = "\n"),
                          type = "rmarkdown")
}
#' @rdname blog-posts
#' @export
ro_blog_post_md <- function() {
  rstudioapi::documentNew(glue::glue_collapse(
    readLines(
      system.file("templates", "markdown-post.md",
                  package="roblog")),
    sep = "\n"),
    type = "rmarkdown")
}

#' @rdname blog-posts
#' @export
ro_blog_post_author <- function() {
  rstudioapi::documentNew(glue::glue_collapse(
    readLines(
      system.file("templates", "author-name.md",
                  package="roblog")),
    sep = "\n"),
    type = "rmarkdown")
}
