#' Create a new rOpenSci (R) Markdown Blog Post
#'
#' @description Create a new rOpenSci Blog Post,
#' either R Markdown (`ro_blog_post_rmd()`) or Markdown (`ro_blog_post_md()`),
#'  or an author file, in RStudio.
#'
#' @export
#'
#' @details Call them via the add-in or directly or get the [templates online](https://ropensci-org.github.io/blog-guidance/templatemd.html).
#'
#' In any case, an internet connection is required as templates are downloaded
#' fresh from their source
#'
#' `ro_blog_post_md()` and `ro_blog_post_author()` create Markdown files,
#'  RStudio might warn you against saving them as ".md" but ignore that.
#'
#' @rdname blog-posts
ro_blog_post_rmd <- function() {
  txt <- get_tmpl("post-template.Rmd")
  rstudioapi::documentNew(
    txt,
    type = "rmarkdown")
}
#' @rdname blog-posts
#' @export
ro_blog_post_md <- function() {
  txt <- get_tmpl("post-template.md")
  rstudioapi::documentNew(
    txt,
    type = "rmarkdown")
}

#' @rdname blog-posts
#' @export
ro_blog_post_author <- function() {
  txt <- get_tmpl("author-file-template.md")
  rstudioapi::documentNew(
    txt,
    type = "rmarkdown")
}
