
<!-- README.md is generated from README.Rmd. Please edit that file -->

# roblog

The goal of roblog is to provide helpers for authors of blog posts and
tech notes on rOpenSci blog.

## Installation

``` r
remotes::install_github("ropenscilabs/roblog")
```

## (R) Markdown templates

If you want to execute code, use the R Markdown template. If not, use a
Markdown template.

The helpers will create an untitled file with the template. Do not
forget to save it.

### R Markdown template

Either

  - Use the RStudio addin

  - Select the template via File \> New File \> R Markdown \> From
    Template

  - Run `roblog::ro_blog_post_rmd()`

### Markdown template

Either

  - Use the RStudio addin

  - Run `roblog::ro_blog_post_md()`

## Lint

`ro_lint_md()` to be run on the path to your blog post (rendered, not
the Rmd) to identify some potential problems and enforce: the use of
complete alternative descriptions for image, of relative links to
rOpenSci website, of Hugo shortcodes for tweets, of lower camelCase for
rOpenSci name.

``` r
path1 <- system.file(file.path("examples", "bad-no-alt.md"),
                                         package = "roblog")
roblog::ro_lint_md(path1)
#> * Alternative image description missing or too short for:
#> {{< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200" alt = "too short">}},
#> {{< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200">}}.
#> 
#> * Please write rOpenSci in lower camelCase, not: Ropensci, ropensci.
#> 
#> * Use Hugo shortcodes to embed tweets, not Twitter html:
#>  <blockquote class="twitter-tweet"><p lang="en" dir="ltr">Finally... hello subtools 1.0! 🥳 Read, write and manipulate subtitles in <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a>. Substantially re-written to integrate with tidytext by <a href="https://twitter.com/juliasilge?ref_src=twsrc%5Etfw">@juliasilge</a> and <a href="https://twitter.com/drob?ref_src=twsrc%5Etfw">@drob</a> <a href="https://t.co/QmCWGk9NOX">https://t.co/QmCWGk9NOX</a> cc <a href="https://twitter.com/ma_salmon?ref_src=twsrc%5Etfw">@ma_salmon</a> <a href="https://t.co/7576oktL7k">pic.twitter.com/7576oktL7k</a></p>&mdash; Francois Keck (@FrancoisKeck) <a href="https://twitter.com/FrancoisKeck/status/1200040510540386304?ref_src=twsrc%5Etfw">November 28, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
#> ,
#> <blockquote class="twitter-tweet"><p lang="en" dir="ltr">When I try to become acquainted with a new (to me) <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> package, I prefer to read ___________</p>&mdash; Jonathan Carroll (@carroll_jono) <a href="https://twitter.com/carroll_jono/status/969442252610191361?ref_src=twsrc%5Etfw">March 2, 2018</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
#> 
#>        should be {{< tweet "1200040510540386304">}},
#> {{< tweet "969442252610191361">}}
#> 
#> A bit more work is needed on this amazing post draft!

path2 <- system.file(file.path("examples", "bad-no-alt2.md"),
                                         package = "roblog")
roblog::ro_lint_md(path2)
#> * Alternative image description missing or too short for:
#>  /img/blog-images/2018-05-03-onboarding-is-work/unnamed-chunk-2-1.png,
#> /img/blog-images/2018-05-03-onboarding-is-work/unnamed-chunk-6-1.png,
#> /img/blog-images/2018-05-03-onboarding-is-work/scatterplot-size-vs-reviewing-time-1.png
#> 
#> * Please replace absolute links with relative links: https://ropensci.org/blog should become /blog.
#> 
#> A bit more work is needed on this luminous post draft!

path3 <- system.file(file.path("examples", "allgood.md"),
                                         package = "roblog")
roblog::ro_lint_md(path3)
#> All good, ole! :-)
```

## How to prepare your pull request

You’ll need to fork <https://github.com/ropensci/roweb2> and create a
branch. You can either use your usual workflow for that, or use
[`usethis`
helpers](https://usethis.r-lib.org/articles/articles/pr-functions.html),
see below.

  - Create the fork and check it out locally:

<!-- end list -->

``` r
usethis::create_from_github("ropensci/roweb2")
```

  - Create a branch

<!-- end list -->

``` r
usethis::pr_init(branch = "mypost")
```

  - Work locally (adding your post)

  - Open the PR

<!-- end list -->

``` r
usethis::pr_push()
```

  - Get feedback and use it

  - Get changes from GitHub to local (e.g. Stef made a suggestion in the
    PR review and you accepted it)

<!-- end list -->

``` r
usethis::pr_pull()
```

  - Get local changes to GitHub (e.g. you updated a paragraph and
    improved a figure from your laptop)

<!-- end list -->

``` r
usethis::pr_push
```
