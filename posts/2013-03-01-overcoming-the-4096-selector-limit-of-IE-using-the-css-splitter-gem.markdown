---
title: Overcoming the 4096 selector limit of IE using the CssSplitter gem
slug: overcoming-the-4096-selector-limit-of-IE-using-the-css-splitter-gem
author: jakob_hilden
published: false
published_at: 2013-03-01
tags:
  keyword: css, IE, rails, zweitag, zweilove, oss, css, stylesheets, frontend, gems
---

Using Sass to preprocess your stylesheets has brought us many, many advantages and really taken CSS development to a whole new level.  However, there are also a couple of new challenges.  For example, due to Sass's nesting capabilities the number of selectors and rules in stylesheets have dramatically increased in many cases.

For example, with some simple Sass code like this

```css
.context-a, .context-b

  .some-class

  .another-class
```

http://sassmeister.com/gist/5021188

You can easily create 6 selectors

This, in connection with web apps (an therefor their stylesheets) getting bigger and bigger, can easly lead to reaching the **4096 selector rules limit** of IE versions 9 and below.  Due to lack of farsightedness, those versions of Internet Explorer will simply ignore all styles beyond the 4095th selector rule within a single stylesheet.  The limits have been blogged about by Microsoft here and there is a test case to check whether a browser is affected.


We have experienced this problem in 2 major projects last year and after manually splitting up our stylesheets in the beginning (which is a real pain if you rely on mixins and variables defined in various files) we found the work of [Christian Peters]() and [Thomas Hollstegge]() form our friends at [Zweiltag]() in form of this [gist]().

We took their work and released it as this gem [zweilove/css_splitter](https://github.com/zweilove/css_splitter), which dramatically simplifies the process of splitting up a too big stylesheet for Rails apps using the asset pipeline (rails version `3.1+`).  It registers a `Sprockets::Engine` that takes care of splitting up stylesheets that have been prepared accordingly.  For detailed instructions please refer to the [README]()

Since at least IE 8 & 9 will probably keep us busy for a little while longer, we hope that the gem can help other developers encountering the same problem.

The integration of the gem could probably still be a good bit more easy and there is currently still a potential edge case involving @media queries.  For those issues we are completely open for any form of contributions.






  

