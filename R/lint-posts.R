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

  text  %>%
    glue::glue_collapse(sep = "\n") %>%
    commonmark::markdown_xml(hardbreaks = TRUE) %>%
    xml2::read_xml() -> post_xml

  issues <- c(rolint_alt(text),
              rolint_ropensci(text))

  if (length(issues) > 0) {
    cat(paste("*", issues), sep = "\n\n")
  } else {
    cat("All good! :-)")
  }

}

rolint_ropensci <- function(text){
  text <- glue::glue_collapse(text, sep = " ")
  problems <- trimws(
    unlist(regmatches(text, gregexpr("ropensci[ \\.\\,\\;\\!\\?\\-\\:]",
                                               text, ignore.case = TRUE))))
  problems <- problems[problems != "rOpenSci"]

  if (length(problems) == 0) {
    return(NULL)
  } else {
    glue::glue("Please write rOpenSci in lower camelCase, not: {glue::glue_collapse(problems, sep = ', ')}.")
  }
}


rolint_alt <- function(text){
  text %>%
    rectangle_shortcodes() -> sc

  if (!"shortcode" %in% names(sc)) {
    return(NULL)
  }

  sc %>%
    dplyr::filter(name == "figure") %>%
    dplyr::group_by(shortcode) -> df

  df %>%
    dplyr::filter(param_name == "alt") %>%
    # https://stackoverflow.com/questions/8920145/count-the-number-of-all-words-in-a-string
    dplyr::mutate(param_value = gsub('\"', "", param_value),
                  alt_length = lengths(gregexpr("\\W+", param_value)) + 1) %>%
    dplyr::filter(alt_length < 3) -> df1

  df %>%
    dplyr::filter(!any(param_name == "alt")) -> df2

  df3 <- rbind(df1, df2)


  if (nrow(df3)) {
    glue::glue("Alternative image description missing or too short for: {glue::glue_collapse(unique(df3$shortcode), sep = ',\n ')}.")
  } else {
    NULL
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

  if (grepl("alt", param_name)) {
    stringr::str_extract(paste0(params, " "),
                         paste0(param_name, '\\".*\\"? ')) %>%
      stringr::str_remove(param_name) %>%
      trimws() -> param_value
  } else {
    stringr::str_extract(paste0(params, " "),
                         paste0(param_name, ".*? ")) %>%
      stringr::str_remove(param_name) %>%
      trimws() -> param_value
  }



  tibble::tibble(param_name = trimws(gsub("\\=", "", param_name)),
                 param_value = param_value)
}
