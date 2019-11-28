shortcode_pattern_start <- function() {
  "\\{\\{[<\\%]"
}

shortcode_pattern_end <- function() {
  "[>\\%]\\}\\}"
}

#' Lint Markdown post for rOpenSci blog
#'
#' @param path Path to the Markdown post (not source Rmd!)
#'
#' @export
#'
#' @examples \dontrun{
#' path <- system.file(file.path("examples", "bad-no-alt.md"),
#'                     package = "roblog")
#' }
ro_lint_md <- function(path) {
  if (!file.exists(path)) {
    message(glue::glue("The file {path} could not be found."))
  }

  path %>%
    readLines() -> text

  text %>%
    commonmark::markdown_xml() %>%
    xml2::read_xml() -> post_xml

}


lint_alt <- function(path) {


}

no_alt <- function(text){
  text %>%
    rectangle_shortcodes() %>%
    dplyr::filter(name == "figure") %>%
    dplyr::group_by(shortcode) %>%
    dplyr::filter(!any(param_name == "alt")) -> df

  if (nrow(df)) {
    glue::glue_collapse(unique(df$shortcode), sep = ", ")
  }
}

rectangle_shortcodes <- function(text) {
  shortcodes <- text[grepl(paste0(".*", shortcode_pattern_start()),
                                  text)]
  purrr::map_df(shortcodes, rectangle_shortcode)
}

rectangle_shortcode <- function(line) {
  name <- trimws(
    gsub(shortcode_pattern_start(), "",
               regmatches(line, regexec(paste0(shortcode_pattern_start(),
                                               " [a-z]* "), line))))

  params <- gsub(paste0(shortcode_pattern_start(),
                        " [a-z]* "), "", line)
  params <- gsub(shortcode_pattern_end(), "", params)

  param_names <- stringr::str_extract_all(params,
                                          "[a-z]*.?\\=.?",
                                          simplify = TRUE)[1,]

  params_df <- purrr::map_df(param_names, get_option, params)

  if ( nrow(params_df) == 0) {
    return(tibble::tibble(name = name,
                          shortcode = line))
  }

  params_df$name <- name
  params_df$shortcode <- line
  params_df

}

get_option <- function(param_name, params) {
  stringr::str_extract(paste0(params, " "),
                       paste0(param_name, ".*? ")) %>%
    stringr::str_remove(param_name) %>%
    trimws() -> param_value

  tibble::tibble(param_name = trimws(gsub("\\=", "", param_name)),
                 param_value = param_value)
}
