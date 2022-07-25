# from https://github.com/ropenscilabs/pkgreviewr/blob/7be5edb7da566c1c70be72339529e595adb1b7c5/R/render-templates.R#L63

get_tmpl <- function(template) {
  tmpl_txt <- gh::gh("/repos/:owner/:repo/contents/:path",
    owner = "ropensci-org",
    repo = "blog-guidance",
    path = glue::glue("templates/{template}")
  )

  tmpl_txt <- rawToChar(base64enc::base64decode(tmpl_txt$content))

  tmpl_txt
}
