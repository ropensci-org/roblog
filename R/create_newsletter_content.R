#' Create newsletter content for Sendgrid
#'
#' @return Text copied to clipboard to be pasted into Sendgrid
#' @export
#'
create_newsletter_content <- function() {
  feed <- xml2::read_xml("https://ropensci.org/rbloggers/index.xml")
  posts <- xml2::xml_find_all(feed, "//item")
  post_xml <- posts[grepl("rOpenSci News Digest",
    purrr::map_chr(posts, \(x) xml2::xml_text(xml2::xml_find_first(x, "title")))
    )][[1]]

  post <- post_xml %>%
    xml2::xml_find_first("description") %>%
    as.character() %>%
    textutils::HTMLdecode() %>%
    xml2::read_html()

  # find post URL
  url <- xml2::xml_find_first(post_xml, ".//guid") %>%
    xml2::xml_text()

  # URLS
  urls <- xml2::xml_find_all(post, "//a")
  xml2::xml_attr(urls, "clicktracking") <- "off"

  # Images
  imgs <- xml2::xml_find_all(post, "//img")
  xml2::xml_attr(imgs, "src") <- sprintf("%s%s", url, xml2::xml_attr(imgs, "src"))
  xml2::xml_attr(imgs, "style") <- "max-width: 100%;"

  # p in li (too big otherwise)
  big_lis <- xml2::xml_find_all(post, "//li[not(p)]")
  wrap_li <- function(li) {
    xml2::xml_name(li) <- "p"
    xml2::xml_add_parent(li, "li")
  }

  purrr::walk(big_lis, wrap_li)

  # Get text
  post <- xml2::xml_find_first(post, "//body/description") %>% xml2::xml_contents()
  clipr::write_clip(as.character(post))
}
