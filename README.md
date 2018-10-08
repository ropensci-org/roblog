# roblog

The goal of roblog is to provide helpers for authors of blog posts and tech notes on rOpenSci blog.

## Installation

Not especially useful yet.

``` r
remotes::install_github("ropenscilabs/roblog")
```

# Current functionality

## R Markdown templates

Once the package is installed if using RStudio, when choosing to create a new R Markdown file from template, you'll be able to choose rOpenSci Tech Note or rOpenSci Blog Post as template.

## Create a post project

You can create an RStudio project using `create_post_project`. It'll contain your post source (Rmd or md), based on the template corresponding to the category ("blog" or "technotes"), a slug, and a publication date (you could change that later).

Create a post from an Rmd for the blog:

```r
create_post_project(tempdir(),
                    "test", "2018-10-15",
                    type = "Rmd",
                    category = "blog")
```

Create a tech note from a Markdown document:
                    
```r
create_post_project(tempdir(),
                    "test2", "2018-10-15",
                    type = "md",
                    category = "technotes")

```

## Fork helper

Based on my current workflow in which I have a separate folder/RStudio project per blog post, tech note or blog post series. 

* You need a local clone of ropensci/roweb2 living at `roweb2_clone_path` on your computer.

* You need to have a blog post or tech note living at `post_dir` (anywhere but not in `roweb2_clone_path`). It should be named "slug-yyyy-mm-dd.md". Ideally, it'll have been generated from one of the R Markdown templates mentioned in the previous subsection. If you don't need to knit, just save the templat as .md directly!

* At the moment the images in the blog post should live in `post_dir/yyyy-mm-dd_files/figures_markdown-github` which is where `knitr` automatically puts figures, but later I might other possible folders. 

* You work in `post_dir` when creating content.

* Your content (blog post or tech note, associated images) will be submitted to roweb2 via a PR from a branch on your fork. You don't need to know anything about where things live in roweb2, because `add_my_content()` will take care of everything for you! You'll run

```r
post_dir <- "C:/Users/Maelle/Documents/ropensci/orcid_note"
slug <- "orcid"
date <- "2018-10-08"
roweb2_clone_path <- "C:/Users/Maelle/Documents/ropensci/roweb2"
add_my_content(post_dir = post_dir,
            roweb2_clone_path = roweb2_clone_path,
            slug = slug, date = date,
           message = "work on my post")
```

At the moment it can't push for you unless you have your `git2r`&co setup worked out. So you'll still need to git push from `roweb2_clone_path`. 

Note that you didn't need to say whether your content was a tech note or blog post, because `add_my_note()` guessed that from the YAML "categories" field.
