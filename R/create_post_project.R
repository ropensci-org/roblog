#' Create a RStudio project with a blog post template
#'
#' @param dir where to create the project
#' @param slug Slug describing the blog post, e.g
#' "thanking-reviewers-in-metadata". Use hyphens, not space.
#' @param date yyyy-mm-dd
#' @param type Either 'Rmd' or 'md'
#' @param category Either 'blog' or 'technotes'
#'
#' @return It opens a new project.
#' @export
#'
#' @examples
#' \dontrun{
#' create_post_project(tempdir(),
#'                     "test", "2018-10-15",
#'                     type = "Rmd",
#'                     category = "blog")
#' create_post_project(tempdir(),
#'                     "test2", "2018-10-15",
#'                     type = "md",
#'                     category = "technotes")
#' }
create_post_project <- function(dir = tempdir(),
                                slug, date, type = "Rmd",
                                category = "blog"){
  dir.create(file.path(dir, slug))

  file.copy(system.file(file.path("templates",
                                  "post.Rproj"),
                        package = "roblog"),
            file.path(dir, slug, paste0(slug,".Rproj")))

  if(!type %in% c("Rmd", "md")){
    stop("type has to be either 'Rmd' or 'md'")
  }

  if(!category %in% c("blog", "technotes")){
    stop("category has to be either 'blog' or 'technotes'")
  }

  post_path <- file.path(dir, slug, glue::glue("{slug}-{date}.Rmd"))


  file.copy(system.file("rmarkdown", "templates",
                        category, "skeleton",
                        "skeleton.Rmd",
                        package = "roblog"),
            post_path)

  post_template <- readLines(post_path)
  post_template[grepl("slug\\:", post_template)][1] <- paste("slug:", slug)


  writeLines(post_template, post_path)
  rmarkdown::render(post_path)

  if(type != "Rmd"){
    file.remove(post_path)
  }

  readme_template <- readLines(system.file("templates/post_readme.md",
                                           package = "rodev"))
  if(type == "Rmd"){
    readme_template[3] <- glue::glue(
      "See [the blog post source here]({slug}-{date}.Rmd) and its rendered version [here]({slug}-{date}.md).") # nolint
  } else{
    readme_template[3] <- glue::glue("See the blog post [here]({slug}-{date}.md)")
  }


  writeLines(readme_template, file.path(dir, slug, "README.md"))

  if(rstudioapi::isAvailable()){
    message(paste("Opening"), file.path(dir, slug))
    rstudioapi::openProject(file.path(dir, slug), newSession = TRUE)
  }else{
    message(paste("Project files created in"),
            file.path(dir, slug))
  }
}
