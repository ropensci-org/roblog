#' @importFrom rlang .data

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
  text <- try(readLines(path), silent = TRUE)

  if (inherits(text, "try-error")) {
    stop(glue::glue("The file {path} could not be read."))
  }

  text  %>%
    glue::glue_collapse(sep = "\n") %>%
    commonmark::markdown_xml(hardbreaks = TRUE) %>%
    xml2::read_xml() %>%
    xml2::xml_ns_strip() -> post_xml

  issues <- c(rolint_alt_shortcode(text),
              rolint_alt_xml(post_xml),
              rolint_ropensci(post_xml),
              rolint_tweet(post_xml),
              rolint_absolute_links(post_xml))

  if (length(issues) > 0) {
    encourage <- praise::praise("this ${adjective} post draft")
    message(glue::glue_collapse(
      c(paste("*", issues),
        glue::glue("A bit more work is needed on {encourage}!")), sep = "\n\n"))
  } else {
    good <- praise::praise("${exclamation}")
    message(glue::glue("All good, {good}! :-)"))
  }

}

rolint_ropensci <- function(post_xml){
  text <- xml2::xml_text(xml2::xml_children(post_xml))
  text <- glue::glue_collapse(text, sep = " ")
  problems <- trimws(
    unlist(regmatches(text, gregexpr("ropensci[ \\.\\,\\;\\!\\?\\-\\:]",
                                               text, ignore.case = TRUE))))
  problems <- sub("\\.", "", problems)
  problems <- problems[problems != "rOpenSci"]

  if (length(problems) == 0) {
    return(NULL)
  } else {
    glue::glue("Please write rOpenSci in lower camelCase, not: {glue::glue_collapse(problems, sep = ', ')}.")
  }
}


rolint_alt_shortcode <- function(text){
  text %>%
    rectangle_shortcodes() -> sc

  if (!"shortcode" %in% names(sc)) {
    return(NULL)
  }

  sc %>%
    dplyr::filter(.data$name == "figure") %>%
    dplyr::group_by(.data$shortcode) -> df

  if(nrow(df) == 0) {
    return(NULL)
  }

  df %>%
    dplyr::filter(.data$param_name == "alt") %>%
    # https://stackoverflow.com/questions/8920145/count-the-number-of-all-words-in-a-string
    dplyr::mutate(param_value = gsub('\"', "", .data$param_value),
                  alt_length = lengths(gregexpr("\\W+", .data$param_value)) + 1) %>%
    dplyr::filter(.data$alt_length < 3) -> df1

  df %>%
    dplyr::filter(!any(.data$param_name == "alt")) -> df2

  df3 <- rbind(df1, df2)


  if (nrow(df3)) {
    glue::glue("Alternative image description missing or too short for:\n {glue::glue_collapse(unique(df3$shortcode), sep = ',\n ')}.")
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

rolint_alt_xml <- function(post_xml) {

  imgs <- xml2::xml_find_all(post_xml, "//image")
  alt_length <- lengths(gregexpr("\\W+", xml2::xml_text(imgs)))
  noalts <- xml2::xml_attr(imgs, "destination")[alt_length < 3]

  if(length(noalts) == 0) {
    return(NULL)
  } else {
    glue::glue("Alternative image description missing or too short for:\n {glue::glue_collapse(noalts, sep = ',\n')}")
  }

}

rolint_tweet <- function(post_xml) {
  nodes <- xml2::xml_children(post_xml)
  prob <- xml2::xml_text(
    nodes[grepl('<blockquote class="twitter-tweet">', xml2::xml_text(nodes))])
  status <- stringr::str_extract(prob, "status\\/[0-9]*") %>%
    stringr::str_remove("status\\/")
  status <- paste0('{{< tweet "', status, '">}}')
  if(length(prob) > 0) {
    return(glue::glue(
      "Use Hugo shortcodes to embed tweets, not Twitter html:\n {glue::glue_collapse(prob, sep = ',\n')}
       should be {glue::glue_collapse(status, sep = ',\n')}"))
  } else {
    return(NULL)
  }
}


rolint_absolute_links <- function(post_xml) {
  post_xml %>%
    xml2::xml_find_all("//link") %>%
    xml2::xml_attr("destination") -> links

  absolute_links <- links[grepl("//(www.)?ropensci\\.org\\/", links)]

  if (length(absolute_links)) {
    relative_links <- gsub(".*ropensci\\.org\\/", "/", absolute_links)

    absolute_links <- glue::glue_collapse(absolute_links, sep = ", ")
    relative_links <- glue::glue_collapse(relative_links, sep = ", ")

    glue::glue("Please replace absolute links with relative links: {absolute_links} should become {relative_links}.")
  } else {
    return(NULL)
  }

}
