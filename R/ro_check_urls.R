#' Check URLs in Markdown post
#'
#' @param path Path to the Markdown post (not source Rmd!) --
#'  if `NULL`, and in RStudio, roblog will default to the md resulting from the active Rmd.
#'
#' @export
#'
#' @examples \dontrun{
#' path <- system.file(file.path("examples", "bad-no-alt.md"),
#'   package = "roblog"
#' )
#' ro_check_urls(path)
#' }
ro_check_urls <- function(path = NULL) {
  if (is.null(path) && rstudioapi::isAvailable()) {
    path <- rstudioapi::documentPath() %>%
      fs::path_ext_set("md")
  }

  text <- try(readLines(path), silent = TRUE)

  if (inherits(text, "try-error")) {
    stop(glue::glue("The file {path} could not be read."))
  }

  post_xml <- get_xml(text)

  urls <- post_xml %>%
    xml2::xml_find_all("//link") %>%
    xml2::xml_attr("destination")

  urls <- urls[grepl("http", urls)]

  df <- tibble::tibble(
    url = urls,
    ok = purrr::map_lgl(urls, crul::ok, verb = "get")
  )
  notok <- df$url[!df$ok]

  http_not_https <- urls[grepl("http\\:", urls)]
  df2 <- tibble::tibble(
    url = http_not_https,
    ok = purrr::map_lgl(sub("http", "https", http_not_https), crul::ok, verb = "get")
  )
  replaceable <- df2$url[df2$ok]

  if ((length(notok) > 0)) {
    usethis::ui_todo(glue::glue("Possibly broken URLs: {glue::glue_collapse(notok, sep = ', ')}."))
  }

  if ((length(replaceable) > 0)) {
    usethis::ui_todo(glue::glue("Replace http with https for: {glue::glue_collapse(replaceable, sep = ', ')}."))
  }

  if ((length(notok) == 0) && (length(replaceable) == 0)) {
    usethis::ui_done("URLs ok!")
  }
}
