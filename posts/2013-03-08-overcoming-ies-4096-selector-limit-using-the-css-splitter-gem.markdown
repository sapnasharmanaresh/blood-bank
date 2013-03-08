---
title: Overcoming IE's 4096 selector limit using the CssSplitter gem
slug: overcoming-ies-4096-selector-limit-using-the-css-splitter-gem
author: jakob_hilden
published: false
published_at: 2013-03-08
tags:
  keyword: css, IE, rails, zweitag, zweilove, oss, css, stylesheets, frontend, gems
---

There has been an annoying CSS limit slumbering in IE for many years that is now increasingly encountered by more and more web developers.  Previous IE versions (below version 10) have a limit on the number of parseable **selectors within one single stylesheet**.  Especially in the Rails world this number has increased lately, due to the introduction of [Sass](http://sass-lang.com/) (**--> more selectors**) and the [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) (--> **bigger stylesheets**).  This blogpost gives a little bit of background on the issue and introduces the [CssSplitter](https://github.com/zweilove/css_splitter) gem, which we developed to help Rails developers split up their overweight stylesheets for IE compatibility.

### The background:  How did you stylesheet become so big?

I think both the asset pipeline and Sass have brought us many, many advantages and in my opinion really taken CSS development to a whole new level. However, they also introduced a couple of new challenges. For the asset pipeline it's pretty obvious that it has an increasing effect on the overall size of stylesheets, by offering a very simple way of concatinating styles from several files into single stylesheets.  For Sass the influence on the number selectors of compiled CSS is a lot more subtle. Basically the major culprits are Sass features like nesting and `@extend`, as shown in this simple code example:

```css
.context-a, .context-b
  border: 1px

  .some-class
    color: red

  .another-class
    color: blue

.yet-another-class
  @extend .some-class
  color: green
```

From briefly and naively looking at the Sass code it looks like there would be 5 different selectors, while the actual [output](http://sassmeister.com/gist/5021188) has **9 selectors**.  Go figure what kind of impact it can have on the large scale if you nest in such a way (which I would consider an anti-pattern) and make a lot of use of `@extend` (without using [placeholder selectors](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#placeholder_selectors_)).  Btw: you can read more about `@extend` placeholder selectors in [another blogpost](http://railslove.com/blog/2012/11/09/taking-sass-to-the-next-level-with-smurf-and-extend).

In addition to the introduction of the asset pipeline & Sass web applications have also not really shrunken over the last couple of year, so bigger web applications obviously result in bigger stylesheets as well.

### The problem

So, with all of the factors above combined, your own web app will probably hit IE's magic **4096 selector limit** sooner than later. What will actually happen when a user with an affected version of IE (= versions 9 and below) receives your oversize stylesheet is the following:  Until the 4095th selector the CSS will be parsed and applied to the HTML regularly, but **all** the selectors beyond the 4095th will simply be ignored silently.  Since the styles towards the end of a stylesheet are often the more specific only applying to very specific parts of the app, this phenomenon can actually go unnoticed for quite a while.

Microsoft has written a [blogpost](http://blogs.msdn.com/b/ieinternals/archive/2011/05/14/internet-explorer-stylesheet-rule-selector-import-sheet-limit-maximum.aspx) that briefly explains the technical reasons behind this seemingly arbritray limit and also some other IE CSS limits, which are fortunately quite unlikely to be reached anytime soon.  You can also find a simple online [test case](http://marc.baffl.co.uk/browser_bugs/css-selector-limit/index.html) by Marc Pacheco, to determine whether your particular browser is affected by the selector limit.

We have experienced this IE limit in 2 major projects last year and we also had to find out that it's no fun to manually split up Sass stylesheets which are distributed over many partials with a certain amount of interdependence between each others (through variables, mixins, and @extendes classes).  You will most likely end up having to do some double maintainance or have duplicated output in your split stylesheets.

### The solution:  CssSplitter

Fortunately, after some manual splitting, we came across the work of [Christian Peters](https://twitter.com/duddledan) and [Thomas Hollstegge](https://twitter.com/Tho85) form our friends at [Zweitag](http://www.zweitag.de/) in form of this [gist](https://gist.github.com/2398394).  We took their code and packaged it up as a [gem](https://github.com/zweilove/css_splitter), which dramatically simplifies the process of splitting up an oversized stylesheet for Rails apps using the asset pipeline (Rails version `3.1+`).

The way it works is that the gem registers a `Sprockets::Engine` which takes care of automatically splitting up your stylesheets, that have been prepared accordingly, when they pass throught the asset pipeline.  The preparation that you need to do is to create an empty "container file" with the file extension `.split2`, which will hold all the styles beyond the 4095th.  In addition you need to include those split up stylesheets in those versions of IE that are affected through conditation comments (`<!--[if lte IE 9]>`).  The gem provides a little helper `split_stylesheet_link_tag` to assist you with that.  The result is that the full stylesheet with all selectors will be served to all browsers, while the affected IE versions will also get a second stylesheet that includes all the selectors beyond the 4096 ignorance line.  For detailed instructions on using the gem simply refer to the [README](https://github.com/zweilove/css_splitter).

### Conclusion

Since we will probably need to keep supporting at least IE 8 & 9 (due to Windows XP) for a little while longer, we hope that our gem can ease the pain a little bit for other developer encountering the same problem in the meantime.

However, the integration of the gem could probably still be a bit more easy and there is currently still an open edge case [bug](https://github.com/zweilove/css_splitter/issues/9) involving `@media` queries.  For those issues, and everything else, we are completely open for any form of contribution, questions or feedback.
