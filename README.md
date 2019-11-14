# roblog

The goal of roblog is to provide helpers for authors of blog posts and tech notes on rOpenSci blog.

## Installation

``` r
remotes::install_github("ropenscilabs/roblog")
```

# Current functionality

## (R) Markdown templates

If you want to execute code, use the R Markdown template. If not, use a Markdown template.

The helpers will create an untitled file with the template. Do not forget to save it.

### R Markdown template

Either

* Use the RStudio addin

* Select the template via File > New File > R Markdown > From Template

* Run `roblog::ro_blog_post_rmd()`

### Markdown template

Either

* Use the RStudio addin

* Run `roblog::ro_blog_post_md()`
