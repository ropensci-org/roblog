get_yaml_end <- function(text) {
  which(grepl("\\-\\-\\-", text))[2]
}

get_xml <- function(text) {
  text <- text[get_yaml_end(text):length(text)]

  text  %>%
    glue::glue_collapse(sep = "\n") %>%
    commonmark::markdown_xml(hardbreaks = TRUE, sourcepos = TRUE) %>%
    xml2::read_xml() %>%
    xml2::xml_ns_strip()

}

get_line <- function(node) {
  line_number <- as.numeric(
    gsub(
    "\\:.*", "",
    xml2::xml_attr(node, "sourcepos")
    )
  )

}


get_col <- function(node) {

  as.numeric(
    gsub(
      "\\-.*", "",
      gsub(
        ".*\\:", "",
        xml2::xml_attr(node, "sourcepos")
      )
    )
  )

}
