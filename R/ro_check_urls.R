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

  full_urls <- urls[!is.na(urltools::domain(urls))]
  localhost_urls <- full_urls[urltools::domain(full_urls) == "localhost"]

  if ((length(localhost_urls) > 0)) {
    usethis::ui_todo(glue::glue("Wrong URLs, remove localhost part to create a relative URL: {glue::glue_collapse(localhost_urls, sep = ', ')}."))
  }

  urls <- urls[!(urls %in% localhost_urls)]
  non_remote_urls <- urls[!grepl("^http", urls)]
  bad_urls <- non_remote_urls[!grepl("^/", non_remote_urls)]
  if ((length(bad_urls) > 0)) {
    usethis::ui_todo(glue::glue("Wrong URLs, slash missing: {glue::glue_collapse(bad_urls, sep = ', ')}."))
  }

  urls <- urls[!(urls %in% bad_urls)]

  ok_url <- function(url) {
    if (!grepl("^http", url)) {
      url <- sprintf("https://ropensci.org%s", url)
    }

    crul::ok(url, verb = "get")
  }

  df <- tibble::tibble(
    url = urls,
    ok = purrr::map_lgl(urls, ok_url)
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
