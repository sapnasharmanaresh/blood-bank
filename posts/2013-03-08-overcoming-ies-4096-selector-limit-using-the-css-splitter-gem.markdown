---
title: Overcoming IE's 4096 selector limit using the CssSplitter gem
slug: overcoming-ies-4096-selector-limit-using-the-css-splitter-gem
author: jakob_hilden
published: true
featured_image: https://dl.dropbox.com/u/409736/static/css_splitter_blog_post_backg.png
published_at: 2013-03-08
tags:
  keyword: css, IE, rails, zweitag, zweilove, oss, css, stylesheets, frontend, gems
---

There has been an annoying CSS limit slumbering in IE for many years that is now increasingly encountered by more and more web developers.  The issue is, that previous IE versions (below version 10) have a **limit on the number of parseable selectors within one single stylesheet**.  Especially in the Rails world this number has considerably increased lately due to the introduction of [Sass](http://sass-lang.com/) (**--> more selectors**) and the [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) (**--> bigger stylesheets**).  This blogpost gives a little bit of background on the issue and introduces the [CssSplitter](https://github.com/zweilove/css_splitter) gem, which we developed to help Rails developers split up their overweight stylesheets for IE compatibility.

### The background:  How did our stylesheets become so big?

I think both the asset pipeline and Sass have brought us many, many advantages and in my opinion really taken CSS development to a whole new level. However, they also introduced a couple of new challenges. For the asset pipeline it's pretty obvious that it has an increasing effect on the overall size of stylesheets, by offering a very simple way of concatinating styles from several files into single stylesheets.  For Sass the influence on the number selectors of compiled CSS is a lot more subtle. Basically the major culprits are nesting and `@extend`, as shown in this simple code example:

```css
.context_a, .context_b
  border: 1px

  .some_class
    color: red

  .another_class
    color: blue

.yet_another_class
  @extend .some_class
  color: green
```

<aside>
  <p>It should be noted here that I would consider the Sass style above to be somewhat of an anti-pattern. As a rule of thumb one should try to avoid too much nesting (not beyond 3 levels) in general and definitely limit the classes on the lower levels.  Also I would recommend trying to use Sass's <a href="http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#placeholder_selectors_">placeholder selectors</a> when using <code>@extend</code>, which you can read about <a href="http://railslove.com/blog/2012/11/09/taking-sass-to-the-next-level-with-smurf-and-extend">here</a>.</p>
</aside>

From briefly and naively looking at the Sass code it looks like there would be 5 different selectors (`context_a, context_b, some_class, another_class, yet_another_class`). However, the actual has a total of **9 selectors**. Check out the [Sassmeister output](http://sassmeister.com/gist/5021188) for the details. I think you can imagine what kind of impact it can have on the large scale, if you nest in such a way (many selectors on lower levels of a nested structure) and do a lot of `@extend` on plain Sass classes.

In addition to the introduction of the asset pipeline and Sass web applications have also kept on growing over the last couple of years, and bigger web applications obviously result in bigger stylesheets as well.

### The problem

So, with all of the factors above combined, your own web app will probably hit IE's magic **4096 selector limit** sooner than later. What actually happens when a user with an affected version of IE (= versions 9 and below) receives your oversized stylesheet is the following:  Until the 4095th selector the CSS will be parsed and applied to the HTML regularly, but **all** the selectors beyond this 4095th selector limit will simply be ignored silently. Since the styles towards the end of a stylesheet are often the more specific ones, only applying to very specific parts of the app, this phenomenon can actually go unnoticed for quite a while.

Microsoft has written a [blogpost](http://blogs.msdn.com/b/ieinternals/archive/2011/05/14/internet-explorer-stylesheet-rule-selector-import-sheet-limit-maximum.aspx) that briefly explains the technical reasons behind this seemingly arbritray limit and also some other IE CSS limits, which are fortunately quite unlikely to be reached anytime soon (you can only `@import` 31 stylesheets).  You can also find a simple online [test case](http://marc.baffl.co.uk/browser_bugs/css-selector-limit/index.html) by Marc Pacheco, to determine whether your particular browser is affected by the selector limit.

We have experienced this IE limit in 2 major projects last year and we also had to find out that it's no fun to manually split up Sass stylesheets which are distributed over many partials with a certain amount of interdependence between each others (through variables, mixins, and `@extend`).  If you start down this road, you will most likely end up having to do some double maintainance or have duplicated output in your split stylesheets.

### The solution:  CssSplitter

Fortunately, after some manual splitting, we came across the work of [Christian Peters](https://twitter.com/duddledan) and [Thomas Hollstegge](https://twitter.com/Tho85) from our friends at [Zweitag](http://www.zweitag.de/) in form of this [gist](https://gist.github.com/2398394).  We took their code and packaged it up as a [gem](https://github.com/zweilove/css_splitter), which dramatically simplifies the process of splitting up an oversized stylesheet for Rails apps using the asset pipeline (Rails version `3.1+`).

The way it works is that the gem registers a `Sprockets::Engine` which takes care of automatically splitting up stylesheets when they pass through the asset pipeline. The only thing you need to do is identify which stylesheets should be split by creating an additional empty "container file" for them, with the file extension `.split2`.  These split2-files will end up holding all the styles beyond the 4095th selector.  In addition to this preparation you need to reference those split up stylesheets for the affected versions of IE using conditional comments (`<!--[if lte IE 9]>`).  The gem provides a little helper `split_stylesheet_link_tag` to assist you with this task.  The final result is that the full stylesheet with all selectors will be served to all browsers, while the affected IE versions will also get a second stylesheet that only includes all the selectors beyond the 4096 ignorance line.  For detailed instructions on using the gem simply refer to its [README](https://github.com/zweilove/css_splitter).

### Conclusion

Since we will probably need to keep supporting at least IE 8 & 9 (due to Windows XP) for a little while longer, we hope that our gem can ease the pain a little bit for all the other Rails developers encountering the same problem in the meantime.

However, it should be said that the integration of the gem could probably still be a bit easier and there is a remaining an open edge case [bug](https://github.com/zweilove/css_splitter/issues/9) involving `@media` queries.  For those issues, and everything else, we are completely open for any form of contribution, questions or feedback.
