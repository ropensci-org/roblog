# ro_lint_md says all good when no issue

    Code
      ro_lint_md(path)
    Message <rlang_message>
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no incorrectly embedded tweets.
      v Found no absolute links to rOpenSci website.

# ro_lint_md find alt issues

    Code
      ro_lint_md(path)
    Message <rlang_message>
      * Alternative (alt) text missing or too short for:
        {< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200" alt = "too short">},
        {< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200">}.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no incorrectly embedded tweets.
      v Found no absolute links to rOpenSci website.

# ro_lint_md find embedded tweets issues

    Code
      ro_lint_md(path)
    Message <rlang_message>
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      * Use Hugo shortcodes to embed tweets, not Twitter html:
         <code><blockquote class="twitter-tweet"><p lang="en" dir="ltr">Finally... hello subtools 1.0! 🥳 Read, write and manipulate subtitles in <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a>. Substantially re-written to integrate with tidytext by <a href="https://twitter.com/juliasilge?ref_src=twsrc%5Etfw">@juliasilge</a> and <a href="https://twitter.com/drob?ref_src=twsrc%5Etfw">@drob</a> <a href="https://t.co/QmCWGk9NOX">https://t.co/QmCWGk9NOX</a> cc <a href="https://twitter.com/ma_salmon?ref_src=twsrc%5Etfw">@ma_salmon</a> <a href="https://t.co/7576oktL7k">pic.twitter.com/7576oktL7k</a></p>&mdash; Francois Keck (@FrancoisKeck) <a href="https://twitter.com/FrancoisKeck/status/1200040510540386304?ref_src=twsrc%5Etfw">November 28, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
        ,
        <blockquote class="twitter-tweet"><p lang="en" dir="ltr">When I try to become acquainted with a new (to me) <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> package, I prefer to read ___________</p>&mdash; Jonathan Carroll (@carroll_jono) <a href="https://twitter.com/carroll_jono/status/969442252610191361?ref_src=twsrc%5Etfw">March 2, 2018</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
        </code>
               should be {< tweet "1200040510540386304">},
        {< tweet "969442252610191361">}
      v Found no absolute links to rOpenSci website.

# ro_lint_md finds absolute links

    Code
      ro_lint_md(path)
    Message <rlang_message>
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no incorrectly embedded tweets.
      * Please replace absolute links with relative links: https://ropensci.org/blog should become /blog.

# ro_lint_md finds figures not using shortcodes

    Code
      ro_lint_md(path)
    Message <rlang_message>
      v Detected no obvious problems with alternative (alt) text.
      v Found no 'click here' links.
      * Use Hugo shortcodes for images cf https://blogguide.ropensci.org/technical.html#addimage
      v Found no incorrectly embedded tweets.
      v Found no absolute links to rOpenSci website.

# ro_lint_md finds click here links

    Code
      ro_lint_md(path)
    Message <rlang_message>
      v Detected no obvious problems with alternative (alt) text.
      * Do not use "click here" or "here" as text for links cf https://webaccess.berkeley.edu/ask-pecan/click-here
      v Found no image not using the Hugo figure shortcode.
      v Found no incorrectly embedded tweets.
      v Found no absolute links to rOpenSci website.

# ro_lint_md with multiple problems

    Code
      ro_lint_md(path)
    Message <rlang_message>
      * Alternative (alt) text missing or too short for:
        {< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200" alt = "too short">},
        {< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200">}.
      v Found no 'click here' links.
      v Found no image not using the Hugo figure shortcode.
      v Found no incorrectly embedded tweets.
      * Please replace absolute links with relative links: https://ropensci.org/blog should become /blog.

