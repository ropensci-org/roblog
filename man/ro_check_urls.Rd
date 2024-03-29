% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ro_check_urls.R
\name{ro_check_urls}
\alias{ro_check_urls}
\title{Check URLs in Markdown post}
\usage{
ro_check_urls(path = NULL)
}
\arguments{
\item{path}{Path to the Markdown post (not source Rmd!) --
if \code{NULL}, and in RStudio, roblog will default to the md resulting from the active Rmd.}
}
\description{
Check URLs in Markdown post
}
\examples{
\dontrun{
path <- system.file(file.path("examples", "bad-no-alt.md"),
  package = "roblog"
)
ro_check_urls(path)
}
}
