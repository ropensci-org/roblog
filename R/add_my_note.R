#' Helper to create/update a post fork
#'
#' @description Helper to create or update the branch of
#'  your roweb2 fork containing your blog post/tech note,
#'  from which you'll make a PR to ropensci/roweb2.
#'
#' @param post_dir Directory where your post lives
#' @param roweb2_clone_path Directory that's your local roweb2 clone
#' @param slug Slug of your post, it should correspond to the slug
#'  in the post filename.
#' @param date Date of your post, it should correspond to the date
#'  in the post filename.
#' @param message Commit message. Fine if not very informative,
#' since we'll squash and merge.
#' @param push Whether to push. See Details.
#'
#' @details
#' Only use \code{push=TRUE} if you know you can push using \code{git2r}.
#' How does one know? Well if you've been able to use \code{usethis::use_github}.
#' At the moment, chose \code{FALSE} if you use Windows!
#'
#' @examples
#' \dontrun{
#' post_dir <- "C:/Users/Maelle/Documents/ropensci/orcid_note"
#' slug <- "orcid"
#' date <- "2018-10-08"
#' roweb2_clone_path <- "C:/Users/Maelle/Documents/ropensci/roweb2"
#' add_my_note(post_dir = post_dir,
#'             roweb2_clone_path = roweb2_clone_path,
#'             slug = slug, date = date,
#'            message = "work on my post")
#' }
add_my_note <- function(post_dir, roweb2_clone_path,
                        slug, date,
                        message = "work on my post",
                        push = FALSE){

  # create post base name
  post <- paste(date, slug, sep = "-")

  # init repo and checkout to a branch named like the slug
  # it is checked out from the local master
  # and created if not already created
  r <- git2r::init(roweb2_clone_path)
  git2r::checkout(r, branch = "master")
  git2r::checkout(r, branch = slug, create = TRUE)

  # copy post and git add it
  post_path <- file.path(roweb2_clone_path, "content", "technotes",
                         paste0(post, ".md"))
  file.copy(file.path(post_dir, paste0(post, ".md")),
            post_path, overwrite = TRUE)
  git2r::add(r, path = post_path)

  # images stuff if there are images
  # note this workflow means the images have to be saved
  # in such a folder even if not created from R Markdown...
  if(fs::dir_exists(paste0(post_dir, "/", post, "_files",
                           "\\/figure-markdown_github\\/"))){

    # in the post create new image paths
    post_content <- readLines(post_path)
    post_content <- gsub(paste0(post, "_files",
                                "\\/figure-markdown_github\\/"),
                         paste0("/img/blog-images/",
                                date, "-", slug,
                                "/"),
                         post_content)

    writeLines(post_content, post_path)
    # create an image dir in roweb2
    img_dir <- file.path(getwd(),paste0("themes/ropensci/static/img/blog-images/",
                                        date, "-", slug,
                                        "/"))

    if(dir.exists(img_dir)){
      fs::dir_delete(img_dir)
    }

    fs::dir_create(img_dir)

    # copy all images
    file.copy(fs::dir_ls(file.path(post_dir, paste(post, "files", sep = "_"),
                                   "figure-markdown_github/")),
              img_dir)
    # git add the dir
    git2r::add(r, path = img_dir)
  }

  # git commit
  git2r::commit(r, message = message, all = TRUE)

  # push!
  # one day this will be default
  if (push){
    git2r::push(r, "origin", slug,
                credentials = git2r::cred_ssh_key())
  }


}
