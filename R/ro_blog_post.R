#' Create a new rOpenSci (R) Markdown Blog Post
#'
#' @description Create a new rOpenSci Blog Post,
#' either R Markdown (`ro_blog_post_rmd()`) or Markdown (`ro_blog_post_md()`)
#'
#' @export
#'
#' @details Call it via the add-in or directly.
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
ro_blog_post_md <- function() {
  rstudioapi::documentNew(glue::glue_collapse(
    readLines(
      system.file("templates", "markdown-post.md",
                  package="roblog")),
    sep = "\n"),
    type = "rmarkdown")
}
