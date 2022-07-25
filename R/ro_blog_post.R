#' Create a new rOpenSci author file
#'
#' @description Create a new author file, in RStudio.
#'
#' @export
#'
#' @details Call it via the add-in or directly or get the [templates online](https://ropensci-org.github.io/blog-guidance/templatemd.html).
#'
#' In any case, an internet connection is required as templates are downloaded
#' fresh from their source
#'
#' `ro_blog_post_author()` creates Markdown files,
#'  RStudio might warn you against saving them as ".md" but ignore that.

#' @rdname blog-posts
#' @export
ro_blog_post_author <- function() {
  txt <- get_tmpl("author-file-template.md")
  author_name <- whoami::fullname(fallback = "Your Name")
  github_username <- whoami::gh_username(fallback = "GitHub username")
  orcid_id <- Sys.getenv("ORCID_ID", "your orcid ID")
  rstudioapi::documentNew(
    txt,
    type = "rmarkdown"
  )
}
