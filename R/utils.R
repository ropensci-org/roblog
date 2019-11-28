get_xml <- function(text) {

  text  %>%
    glue::glue_collapse(sep = "\n") %>%
    commonmark::markdown_xml(hardbreaks = TRUE) %>%
    xml2::read_xml() %>%
    xml2::xml_ns_strip()

}
