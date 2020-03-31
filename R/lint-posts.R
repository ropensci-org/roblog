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

  if (!file.exists(path)) {
    stop(glue::glue("The file {path} does not exist, did you make a typo?"))
  }

  text <- try(readLines(path), silent = TRUE)

  if (inherits(text, "try-error")) {
    stop(glue::glue("The file {path} could not be read."))
  }

  post_xml <- get_xml(text)

  source_file <- srcfile(path)
  source_file$lines <- readLines(path)
  source_file$to_add <- get_yaml_end(source_file$lines) - 1

  issues <- c(rolint_alt_shortcode(text),
              rolint_title(path),
              rolint_headings(post_xml, source_file),
              rolint_click_here(post_xml),
              rolint_figure_shortcode(post_xml),
              rolint_ropensci(post_xml),
              rolint_tweet(post_xml),
              rolint_absolute_links(post_xml))

  if (length(issues) > 0) {
    encourage <- praise::praise("this ${adjective} post draft")
    msg <- glue::glue_collapse(
      c(paste("*", issues),
        glue::glue("A bit more work is needed on {encourage}!")), sep = "\n\n")
  } else {
    good <- praise::praise("${exclamation}")
    msg <- glue::glue("All good, {good}! :-)")
  }

  message(msg)
  invisible(msg)

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
rolint_tweet <- function(post_xml) {
  nodes <- xml2::xml_children(post_xml)
  prob <- xml2::xml_text(
    nodes[grepl('<blockquote class="twitter-tweet">', xml2::xml_text(nodes))])
  status <- stringr::str_extract(prob, "status\\/[0-9]*") %>%
    stringr::str_remove("status\\/")
  status <- paste0('{{< tweet "', status, '">}}')
  if(length(prob) > 0) {
    return(glue::glue(
      "Use Hugo shortcodes to embed tweets, not Twitter html:\n <code>{glue::glue_collapse(prob, sep = ',\n')}</code>
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

rolint_title <- function(path) {
  title <- yaml::yaml.load(readLines(path)[1:10])$title

  good_title <- snakecase::to_title_case(title)

  if (title != good_title) {
    glue::glue('Use Title Case for the title i.e. "{good_title}". (Ignore this note if the words are e.g. package names)')
  } else {
    return(NULL)
  }

}

rolint_headings <- function(post_xml, srcfile) {

  headings_nodes <- xml2::xml_find_all(
    post_xml,
    "//heading"
    )

  headings <- xml2::xml_text(headings_nodes)

  good_headings <- snakecase::to_sentence_case(headings)

  bad <- headings_nodes[headings != good_headings]

  make_heading_lint <- function(heading_node, srcfile) {
    lintr::Lint(
        filename = srcfile$filename,
        line_number = get_line(heading_node) + srcfile$to_add,
        column_number = get_col(heading_node),
        type = "style",
        message = glue::glue(
          'Use Sentence case for headings i.e. "{snakecase::to_sentence_case(xml2::xml_text(heading_node))}"'
          ),
        line = srcfile$lines[get_line(heading_node) + srcfile$to_add],
        linter = "sentence_case_headings_linter"
    )
  }
  browser()
  lints <- lapply(
    headings_nodes[headings != good_headings],
  )

  if (any(headings != good_headings)) {
    good <- glue::glue('"{good_headings[headings != good_headings]}"')
    glue::glue('Use Sentence case for headings i.e. {toString(good)}. (Ignore this note if the words are proper nouns)')
  } else {
    return(NULL)
  }
}

rolint_figure_shortcode <- function(post_xml) {

  post_xml %>%
    xml2::xml_find_all("//image") -> images

  if (length(images) == 0) {
    return(NULL)
  }

  dest <- xml2::xml_attr(images, "destination")

  glue::glue('Use Hugo shortcodes for images cf https://blogguide.ropensci.org/technical.html#addimage',
             .open = "[",
             .close = "]")

}

rolint_click_here <- function(post_xml) {

  post_xml %>%
    xml2::xml_find_all("//link") %>%
    xml2::xml_text() -> link_text

  if (any(trimws(tolower(link_text)) %in% c("click here", "here"))) {
    return('Do not use "click here" or "here" as text for links cf https://webaccess.berkeley.edu/ask-pecan/click-here')
  } else {
    return(NULL)
  }
}
