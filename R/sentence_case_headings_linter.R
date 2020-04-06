sentence_case_headings_linter <- function(post_xml, srcfile) {

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

  if (length(bad)) {
    lapply(
      headings_nodes[headings != good_headings],
      make_heading_lint,
      srcfile
    )
  } else {
    return(NULL)
  }

}
