---
title: Taking Sass to the Next Level with SMURF and @extend
slug: taking-sass-to-the-next-level-with-smurf-and-extend
author: jakob_hilden
featured_image: https://dl.dropbox.com/u/409736/smurf_blog_background.png
published: true
published_at: 2012-11-09
tags:
  keyword: smacss, sass, railslove, rails, oss, css, smurf, stylesheets, frontend, modular, conventions
  person: paul_wittmann, stephan_pavlovic, tim_schneider
todo:
  - add SMURF image
  - add more examples with CSS output for @extend part
---

Back in March I attended a SMACSS workshop by Jonathan Snook ([@snookca](https://twitter.com/snookca)) and wrote a blogpost about ["The Future of Stylesheets"](/blog/2012/03/28/smacss-and-sass-the-future-of-stylesheets) with my first thoughts on implementing the [SMACSS](http://smacss.com) approach using the [Sass preprocessor language](http://sass-lang.com).  Well, the topic stayed on my mind ever since and we have been codifying the ideas presented in "The Future of Stylesheets" in the form of SMURF and gained some very valuable practical experience from using it in our first projects.

In this blogpost I would like to follow up on that other post by giving an overview about "**SMURF**", which stands for **S**calable, **M**odular, re**U**sable **R**ails **F**rontends and is our effort to implement the SMACSS approach using Sass (& Rails) in the first part. In the second part of the post I will talk about the lessons we learned along our way about the sensible usage of Sass's powerful but dangerous <code>@extend</code> functionality.

<br />

# I)  What is SMURF?

SMURF basically consists of two things:  firstly, a set of coding conventions for writing SMACSS-style CSS with Sass, and secondly a Ruby gem called ["Smurfville"](https://github.com/railslove/smurfville) which helps you generating _living styleguides_ based on your "SMURF-following" Sass code.  In this post we'll mostly talk about SMURF's coding conventions that are designed to lead to better, more modular frontend code.


## How to write better frontend code using SMACSS & Sass

When you start desiring to write better CSS frontend code, the first things you should actually learn about are general best practices such as [using only classes](http://smurf-presentation.herokuapp.com/#16), [shallow selectors](http://smacss.com/book/selectors), [avoiding element selectors](http://smacss.com/book/selectors), [limiting the depth of applicability](http://smacss.com/book/applicability) and [categorizing your styles](http://smacss.com/book/categorizing).  In my opinion SMACSS is doing a really brilliant job in explaining these approaches and I can warmly recommend the [SMACSS website](http://smacss.com) to any frontend developer.  In addition to that you can also read about these things in the first parts of my recent [talk](http://smurf-presentation.herokuapp.com/) at the [ArrrCamp](http://arrrrcamp.be) in Belgium.

However, in this blogpost I want to concentrate on "the next step", the concrete implementation of modular SMACSS/SMURF using Sass.

SMACSS introduces the concepts of modules, module components, states and submodules.  However, it doesn't really say too much about the actual coding conventions for these entities, therefore SMURF is trying to fill that gap by establishing some clear coding guidelines:


### Modules

Modules are the fundamental entities of your CSS and should be carefully designed for modular reuse.  To clearly distinguish them from layout styles (<code>.l-</code>), legacy code, libraries, and other non-modular CSS, modules are always prefixed with <code>.m-</code>.

Some very basic frontend code:

Sass:

```css
.l-single-centered-colum
  width: 400px
  margin: 0 auto

.m-box
  border: 1px solid black
```

HTML:

```html
<div class="l-single-centered-column m-box">
  <!-- ... box content ... -->
</div>
```

As we can see the layout style is **only** responsible for the width and positioning (= "layout") of the element, while the module defines its appearance in a reusable way.


### Module components

Module components are child elements of modules.  They are always prefixed with the full name of the module they belong to followed by <code>--</code>, in order to:  a) indicate their relationship, and  b) prevent the component's styles from applying outside of the module's scope.

Sass:

```css
.m-box
 .m-box--header
   background-color: grey

 .m-box--body
   padding: 10px
```

HTML:

```html
<div class="m-box">
  <h1 class="m-box--header">Headline</h1>

  <div class="m-box--body">
    ... box content ...

    <!-- some other markup -->
      <!-- deep down in the box -->
        <!-- in some other context -->
          <div class="header" />
  </div>
</div>
```

In this example you can see that, if we simply gave our component a generic classname, such as <code>.header</code>, its styles would also apply anywhere down the DOM tree, outside the immediate context of our module and create unintended consequences.  But by using the <code>.m-box--</code> prefix we have 100% control over its applicability, and get the additional benefit of knowing immediately which elements belong together in our stylesheet as well as in the markup.

This might seem very strict and verbose on first sight, but especially in a larger team setting it quickly becomes invaluable.

<aside>
  <p>One little comment on <strong>nesting Sass</strong></p>

  <p>After some back and forth I concluded that I prefer to nest/indent all the styles belonging to a module.  This is not technically necessary, because we are already using the module namespacing, but I still like the visual closure and hierachy that it gives my Sass code.  I think the slightly more complex selectors in the compiled CSS can be ignored and you simply need to be careful not to nest more than 2-3 levels down.</p>
</aside>


### States

They define states of a module (e.g. <code>.is-selected</code> or <code>.is-hidden</code>) that can change dynamically (e.g. through JS) and are prefixed with <code>.is-</code> just as defined in SMACSS.  Even though they can follow the <code>.is-</code> naming scheme, pseudo elements such as <code>:hover</code>, <code>:focus</code> or @media queries are also considered states.


### Submodules

Submodules are versions/variants of an existing module.  They inherit all the attributes of their parent module and describe a different version of them for certain contexts (e.g. <code>.m-box\_sidebar</code>, meaning <code>.m-box</code> styled for the sidebar) or use cases (e.g. <code>.m-box\_attention</code>, being a especially attention grabbing box variant).   When you're new to SMACSS/SMURF it can be hard to tell submodules apart from module components.  The difference is that module components are subelements of a module, whereas submodules are variants of that module.  Submodules are the primary use case for Sass <code>@extend</code> as I will further discuss below.


### Module modifiers

Because creating a new submodule for every different context or use case proved to be overkill and submodules are very awkward to combine (<code>m-box\_attention_sidebar</code>??, <code>m-box\_attention m-box_sidebar</code>??), SMURF introduces a new entity called **module modifiers**.  They are something in between states and submodules.  They are defined the same way as states – as an additional class on the root module (e.g. <code>&.modifier</code>), but – just like a submodule – they describe a slightly different version of their parent module.  The concept could be familiar to you from Twitter Bootstrap and examples would be things like <code>.m-box.right</code>, <code>.m-box.no-border</code>.  The idea behind module modifiers is to use them for **little**, **chainable** changes to modules. Submodules on the other hand are used for more **substantial** changes, which for example also affect or add components.

Here we have a complete SMURF code example of both submodules and modifiers in action:

```css
// -- module --
.m-box
  // components
  .m-box--header

  .m-box--body

  // modifiers
  &.no-border
    border: none

  &.right
    float: right

  // states
  &.is-disabled
    background-color: #ccc

// -- submodule --
.m-box_attention
  @extend .m-box
  border: 2px solid red

   // additional component, that only exists in the submodule
  .m-box_attention--teaser
```

HTML:

```html
<div class="m-box_attention right is-disabled">
```

The great thing about using <code>@extend</code> here is, that it allows the element to inherit all the styles from the root module without having to explicitly state it in the markup.  In traditional SMACSS (or Twitter Bootstrap for that matter) you'd have to apply both classes (<code>class="m-box m-box_attention"</code>) to achieve the same thing.


### SMURF's Advantages


<aside>
  <p><strong>FYI</strong>: Besides single responsibility, SMURF also improves on some other parts of the SOLID principles as was outlined in this recommendable <a href="http://blog.millermedeiros.com/solid-css/">blogpost</a>.</p>
</aside>

In summary, the advantages of writing CSS (or Sass) the SMURF way are the following:

* you can learn something about a selector's semantics just by looking at its naming convention
* styles have a more well-defined (single) responsibility
* you make sure that styles only apply where they should
* you can suddenly safely and comprehensibly share and inherit styles to [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) up your CSS and improve maintainability

<br />

# II) The Right Usage of Sass's @extend (and Placeholder Selectors)

As shown above, a central element of the modularization of your CSS is Sass' <code>@extend</code> functionality.  It allows you to inherit styles from a parent module inside of submodules.

Sass:

```css
.m-button
  border: 1px solid black

.m-button_attention
  @extend .m-button
  border-color: red
```

CSS output:

```css
.m-button, .m-button_attention {
  border: 1px solid black;
}

.m-button_attention {
  border-color: red;
}
```

Another option to achieve this code reuse in Sass would be to use <code>@mixins</code>.  Then our stylesheet code would look like this:

Sass:

```css
@mixin button
  border: 1px solid black

.m-button
  @include button

.m-button_attention
  @include button
  border-color: red
```

CSS output:

```css
.m-button {
  border: 1px solid black;
}

.m-button_attention {
  border: 1px solid black; /* unnecessary repetition */
  border-color: red;
}
```

The problem here is that mixins work like marcros and copy their properties everywhere they are used.  Therefore, the compiled CSS code is not DRY at all and unnecessarily inflated.  In the example above it's only one property but imagine the bloat when you use  mixins (with many more properties) for **every** module.

<code>@extend</code> is much more elegant and DRY in this regard, because it ueses CSS's built-in inheritance capability, by copying selectors instead of properties.  However, at the same time this is the big disadvantage of <code>@extend</code>, because you can totally get yourself in deep trouble, with this selector copying.

The problem arises, when you start using the extended module in a different context.  Here's a simple example:

```css
// button module
.m-button
  border: 1px solid black

.m-button_attention
  @extend .m-button
  border-color: red

// form module, reusing styles from button module
.m-form
  .m-form--submit
    @extend .m-button_attention
    float: right

// m-button module also used as a selector in a different context
.l-sidebar
  .m-button
    border-color: green
```

CSS output

```css
.m-button, .m-button_attention, .m-form .m-form--submit {
  border: 1px solid black;
}

.m-button_attention, .m-form .m-form--submit {
  border-color: red;
}

.m-form .m-form--submit {
  float: right;
}

.l-sidebar .m-button, .l-sidebar .m-button_attention,
.l-sidebar .m-form .m-form--submit, .m-form .l-sidebar .m-form--submit {
  border-color: green;
}
```

The problem here is, that <code>@extend</code> will copy the **complete** extending selector (<code>.m-form .m-form--submit</code>) **anywhere** you used the extended selector (<code>.m-button_attention</code>).  In addition, since that selector is using <code>@extend</code> itself (called [chaining extends](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#chaining_extends)), it will actually also copy the original selector anywhere that extended selector (<code>.m-button</code>) is used.  This can lead to a couple of negative effects.

The biggest problem is that the <code>.m-form .m-form--submit</code> selector will suddenly appear inside the <code>.l-sidebar</code> context, with possibly breaking and very hard-to-debug consequences for your design.  This is unacceptable.  In addition, the selector copying is increasing the complexity of the CSS output exponentially.  Selectors using <code>.m-button</code> are going to get very long, cryptic and possibly slow, and finally this has a negative impact on Sass compilation times.

To give you a real world example for a worst case scenario, we had it happen in one project that somebody extended some ubiquitously used class from Twitter Bootstrap and immediately made our Sass stylesheet unusable. Compile time went from under a minute to 9 minutes(!).

To prevent this from happening, in SMURF we've created the rule to "Never @extend across modules!".

Luckily all of this changed with the recent introduction of [placeholder selectors](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#placeholders) in Sass version 3.2.  So, what are placeholder selectors?  Well, they are mostly just like regular selectors, but they have a different <code>%</code>-syntax (<code>%placeholder-selector</code>) and their sole purpose is to be extended.  They won't appear in your CSS output and they can't be used for anything else besides being extended.  And that last feature suddenly makes them safe to use for extending across modules.

Now you simply define your module styles first as a placeholder selector and that is the only selector you will extend.  You extend it in the actual module, as well as in all the submodules, and also in totally different contexts, if you want to reuse that module's styles:

Sass:

```css
// button module
// placeholder selctor which won't be compiled to CSS but can be @extended
%m-button
  border: 1px solid black

// .m-button no longer defines any properties but @extends the placeholder selector
.m-button
  @extend %m-button

%m-button_attention
  @extend %m-button
  border-color: red

.m-button_attention
  @extend %m-button_attention

// form module, reusing styles from button module
.m-form
  .m-form--submit
    @extend %m-button_attention
    float: right

// m-button module also used as a selector in a different context
.l-sidebar
  .m-button
    border-color: green
```

CSS output:

```css
.m-button, .m-button_attention, .m-form .m-form--submit {
  border: 1px solid black;
}

.m-button_attention, .m-form .m-form--submit {
  border-color: red;
}

.m-form .m-form--submit {
  float: right;
}

.l-sidebar .m-button {
  border-color: green;
}
```

Since you can't use <code>%m-button</code> in any other way, but to @extend it, you can be sure that extending selectors can't get copied around to undesired parts of your CSS (in this case into the <code>.l-sidebar</code> context).  Awesome isn't it?  Through placeholder selectors we now have a CSS code reusage/inheritance pattern that:

* is safe to use in team settings
* is DRY
* doesn't produce bloated CSS output

For me, and for SMURF, that is a pretty revolutionary change that only gradually dawned on me and I'm a little surprise why there isn't a lot more buzz in the Sass community about placeholder selectors, yet.  So, please spread the word about them.

<br />

# More about SMURF

If you want to know more about SMURF I recommend you watch my [presentation](http://vimeo.com/51903907) at the awesome [ArrrCamp 6](http://arrrrcamp.be) in Belgium in October.

<iframe src="http://player.vimeo.com/video/51903907?badge=0" width="675" height="379" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>

You can also find a [slides only version of the presenation](http://smurf-presentation.herokuapp.com/).

Besides that, check out our [Smurfville GitHub repository](https://github.com/railslove/smurfville) that has more info about SMURF coding conventions in the [wiki](https://github.com/railslove/smurfville/wiki) and the Smurfville gem, which can automatically generate _living styleguides_ from you Sass code, following the SMURF coding conventions.  But that's a story for another upcoming blogpost.  We're also looking for people to contribute to both the SMURF conventions and the Smurfville gem.  So please head over to GitHub, fork our code, report issues, and give us feedback.

To stay up-to-date on SMURF, you can follow [@jkwebs](https://twitter.com/jkwebs) and [@railslove](https://twitter.com/railslove) on Twitter.  For the European Sass community we just started [@sassmeetup_eu](https://twitter.com/sassmeetup_eu).  And finally, don't hesitate to contact us should you be interested in consulting on modular frontend development.

