# ro_lint_md says all good when no issue

    Code
      ro_lint_md(path)
    Message
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no absolute links to rOpenSci website.
      v Found no code style problem.

# ro_lint_md find alt issues

    Code
      ro_lint_md(path)
    Message
      * Alternative (alt) text missing for:
        {< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200">}.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no absolute links to rOpenSci website.
      v Found no code style problem.

# ro_lint_md finds absolute links

    Code
      ro_lint_md(path)
    Message
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      * Please replace absolute links with relative links: https://ropensci.org/blog should become /blog.
      v Found no code style problem.

# ro_lint_md finds figures not using shortcodes

    Code
      ro_lint_md(path)
    Message
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      * Use Hugo shortcodes for images cf https://blogguide.ropensci.org/technical.html#addimage
      v Found no absolute links to rOpenSci website.
      v Found no code style problem.

# ro_lint_md finds click here links

    Code
      ro_lint_md(path)
    Message
      v Detected no obvious problems with alternative (alt) text.
      * Do not use "click here" or "here" as text for links cf https://webaccess.berkeley.edu/ask-pecan/click-here
      v Found no image not using the Hugo figure shortcode.
      v Found no absolute links to rOpenSci website.
      v Found no code style problem.

# ro_lint_md for code

    Code
      ro_lint_md(path)
    Message
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no absolute links to rOpenSci website.
      * Use `library()` instead of `require()` in `require(blop)`, `require(lala)`.

# ro_lint_md for code no functions

    Code
      ro_lint_md(path)
    Message
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no absolute links to rOpenSci website.
      v Found no code style problem.

# ro_lint_md with multiple problems

    Code
      ro_lint_md(path)
    Message
      * Alternative (alt) text missing for:
        {< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200">}.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      * Please replace absolute links with relative links: https://ropensci.org/blog should become /blog.
      v Found no code style problem.

