---
slug: "post-template"
title: Wonderful title
package_version: 0.1.0
authors:
  - Author Name
date: 2019-06-04
categories: blog
topicid:
tags:
  - Software Peer Review
  - R
  - community
# delete the line below
# if you have no preferred image
# for Twitter cards
twitterImg: img/blog-images/2019-06-04-post-template/name-of-image.png
---

Save this file under /content/blog/YEAR-MONTH-DAY-slug.md in the local copy of your roweb2 fork.

Beware! If you want to generate this post from R Markdown, use the R Markdown template instead!

  Everywhere in this template (YAML, paths to images), you should change "post-template" to the slug of your post, and "2019-06-04" to the publication date.

Introduction including outline of the post.

### First awesome section

I like Hugo[^1]. Yes, that is how you add a footnote.

#### First awesome subsection of the first awesome section

Here's how to use a Hugo shortcode to add an image.

{{< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200">}}

{{< figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200" alt = "too short">}}

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Finally... hello subtools 1.0! 🥳 Read, write and manipulate subtitles in <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a>. Substantially re-written to integrate with tidytext by <a href="https://twitter.com/juliasilge?ref_src=twsrc%5Etfw">@juliasilge</a> and <a href="https://twitter.com/drob?ref_src=twsrc%5Etfw">@drob</a> <a href="https://t.co/QmCWGk9NOX">https://t.co/QmCWGk9NOX</a> cc <a href="https://twitter.com/ma_salmon?ref_src=twsrc%5Etfw">@ma_salmon</a> <a href="https://t.co/7576oktL7k">pic.twitter.com/7576oktL7k</a></p>&mdash; Francois Keck (@FrancoisKeck) <a href="https://twitter.com/FrancoisKeck/status/1200040510540386304?ref_src=twsrc%5Etfw">November 28, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 


<blockquote class="twitter-tweet"><p lang="en" dir="ltr">When I try to become acquainted with a new (to me) <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> package, I prefer to read ___________</p>&mdash; Jonathan Carroll (@carroll_jono) <a href="https://twitter.com/carroll_jono/status/969442252610191361?ref_src=twsrc%5Etfw">March 2, 2018</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

<!--html_preserve--> {{% figure src = "/img/blog-images/2019-06-04-post-template/name-of-image.png" width = "200" % alt = "an actually good description!"%}}
<!--/html_preserve-->

Ropensci was very nice, cool ropensci.

#### Second awesome subsection

Here's how to use a Hugo shortcode to embed a tweet. We recommend the use of [Hugo shortcodes](https://gohugo.io/content-management/shortcodes/) to include tweets, Vimeo or Youtube videos, gists, etc.

{{< tweet 1138216112808529920 >}}

### Conclusion

Have fun writing your blog post!

  Here's how to add the footnote text for your reference above.

[^1]: Hugo! https://gohugo.io/
