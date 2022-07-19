#' Check URLs in Markdown post
#'
#' @param path Path to the Markdown post (not source Rmd!) --
#'  if `NULL`, and in RStudio, roblog will default to the md resulting from the active Rmd.
#'
#' @export
#'
#' @examples \dontrun{
#' path <- system.file(file.path("examples", "bad-no-alt.md"),
#'                     package = "roblog")
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

  df <- tibble::tibble(url = urls,
                 ok = purrr::map_lgl(urls, crul::ok,
                                     verb = "get"))
  notok <- df$url[!df$ok]

  if (length(notok) == 0) {
    message("URLs ok!")
  } else {
    message(glue::glue("Possibly broken URLs: {glue::glue_collapse(notok, sep = ', ')}."))
  }

}
