---
title: Taking Sass to another level using SMURF and @extend
slug: smurf-and-using-sass-extend
author: jakob_hilden
featured_image: http://farm8.staticflickr.com/7261/7731744988_e2c0176b25_z.jpg
published: false
published_at: 2012-11-09
tags:
  keyword: smacss, sass, railslove, rails, oss, css, smurf, stylesheets, frontend, modular, conventions
  person: stephan_pavlovic, tim_schneider
todo:
  - add SMURF image
  - add more examples with CSS output for @extend part
---

Back in March I attended a SMACSS workshop by Jonathan Snook ([@snookca](https://twitter.com/snookca)) and wrote a blogpost about the ["Future of Stylesheets"](/blog/2012/03/28/smacss-and-sass-the-future-of-stylesheets) with my first thoughts on implementing the [SMACSS](http://smacss.com) approach using the [Sass preprocessor language](http://sass-lang.com).  Well, the topic has kept us busy for all the time since and we have been codifying "Future of Stylesheets" form of SMURF and gained some very valuable practical experience from using it in our first projects.

The first part of this blogpost gives you an overview about "**SMURF**", which stands for **S**calable, **M**odular, re**U**sable **R**ails **F**rontends and is our effort to implement the SMACSS approach using Sass (& Rails). The second part is about the lessons we learned along our way about the sensible usage of Sass' powerful but dangerous <code>@extend</code> functionality.

<br />

# I)  What is SMURF?

SMURF basically consists of two things:  firstly, it's a set of coding conventions for writing SMACSS-style CSS modules using Sass, and secondly it's a Ruby gem called ["Smurfville"](https://github.com/railslove/smurfville) which helps you to generate "living styleguides" based on your SMURF-following Sass code.  However, in this post we will mostly talk about the coding conventions that are designed to lead to better, more modular frontends.


## How to write better frontend code using SMACSS & Sass

When you start desiring to write better CSS frontend code, the first things you should actually learn about are general best practices such as [using only classes](http://smurf-presentation.herokuapp.com/#16), [shallow selectors](http://smacss.com/book/selectors), [avoiding element selectors](http://smacss.com/book/selectors), [limiting depth of applicability](http://smacss.com/book/applicability) and [categorizing your styles](http://smacss.com/book/categorizing).  In my opinion SMACSS is doing a really brilliant job in explaining these approaches and I can warmly recommend the [SMACSS website](http://smacss.com) to any frontend developer.  In addition to that you can also read about these things in the earlier parts of my recent [talk](http://smurf-presentation.herokuapp.com/) at the [ArrrCamp](http://arrrrcamp.be) in Belgium.

However, in this blogpost I want to concentrate on "the next step", the concrete implementation of modular SMACSS/SMURF using Sass.

SMACSS introduces the concepts of modules, module components, states and submodules.  However, it doesn't really say too much about the actual coding conventions for these entities, therefore SMURF is trying to fill that "gap" by establishing some clear coding guidelines:


### Modules

Modules are the fundamental entities of your CSS and carefully designed for modular reuse.  To clearly distinguish these from things like layout styles (using <code>.l-</code>), legacy code, libraries, and other non-modular CSS, modules are always prefixed with <code>.m-</code>.

Some very basic frontend code:

Sass:

```css
.l-single-centered-colum
  width: 400px
  margin: 0 auto

.m-box
  border: 1px solid $border-color
```

HTML:

```html
<div class="l-single-centered-column m-box">
  <!-- ... box content ... -->
</div>
```

As we can see the layout style is only(!) responsible for the width and positioning (= "layout") of the element while the module defines its appearance in a reusable way.


### Module components

Module components are styling for child elements of modules.  They are always prefixed with the full name of the module they belong to and a <code>--</code>, in order to a) communicate their relationship  b) prevent those styles to apply outside of the "scope" of the module.

Sass:

```css
.m-box
 .m-box--header
   background-color: $header-background-color

 .m-box--body
   padding: $padding
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

In this example you can see that, if we would simply give our component a generic classname, such as <code>.header</code>, its styles would also apply anywhere down the DOM tree, outside the immediate context of our module and create unintended consequences.  But by using the <code>.m-box--</code> prefix we have 100% control over its applicability, and we get the additional benefit of knowing immediately which elements belong together, in stylesheet as well as in the markup.

This might seem very strict and verbose on first sight, but especially in a larger team setting it becomes invaluable.

<aside>
  <p>One little comment on <strong>nesting Sass</strong></p>

  <p>After some back and forth I concluded that I prefer to nest/indent all the styles belonging to a module.  This is not technically necessary, because we are already using the module namespacing, but I still like the visual closure and hierachy that it gives my Sass code.  I think the slightly more complex selectors in the compiled CSS can be ignored and you simply need to be careful not to nest more than 2-3 levels down.</p>
</aside>


### States

They define states of the module that can change dynamically (e.g. through JS) and are prefixed with <code>.is-</code> just as defined in SMACSS.  States also include pseudo elements such as <code>:hover</code>, <code>:focus</code> or @media queries.


### Submodules

Submodules inherit all the attributes of their parent module and describe a different version of them for certain contexts (e.g. <code>.m-module\_sidebar</code>) or use cases (e.g. <code>.m-module\_attention</code>).  Submodules are the primary use case for Sass <code>@extend</code> as I will further discuss below.


### Module modifiers

Because, creating a new submodule for every different context or use case proved to be kind of overkill and submodules are very awkward to combine (should it be <code>.m-module\_attention_sidebar</code>?), SMURF introduces a new entity called "module modifiers".  They are something in between states and submodules.  They are defined in the same way as states, as an additional class on the root module (e.g. <code>&.modifier</code>), but – just as a submodule – they describe a slightly different version of their module.  The concept could be familiar to you from Twitter Bootstrap and examples would be things like <code>.m-box.right</code>, <code>.m-box.no-border</code>.  The idea is to use modifiers for little chainable changes to modules, while submodules are used for more "substantial" changes, which for example also affect/add components.

Sass:

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
    background-color: $disabled-color

// -- submodule --
.m-box_attention
  @extend .m-box
  border: 2px solid $attention-color

   // additional component, that only exists in the submodule
  .m-box_attention--teaser
```

HTML:

```html
<div class="m-box_attention right is-disabled">
```

The great thing about using <code>@extend</code> here is, that it allows the element to inherit all the styles from the root module without having to explicitly stating it in the markup.  In traditional SMACSS (or Twitter Bootstrap for that matter) you would have to put both classes <code>class="m-box m-box_attention"</code> to achieve the same thing.


### SMURF advantages


<aside>
  <p><strong>FYI</strong>: Besides single responsibility, SMURF also improves on some other parts of the SOLID principles as was outlined in this recommendable <a href="http://blog.millermedeiros.com/solid-css/">blogpost</a>.</p>
</aside>

In summary, the advantages of writing CSS (or Sass) the SMURF way are the following:

* you can infer something about the semantics of a selector just by its prefix & syntax
* styles have a more well-defined (single) responsibility
* you make sure that styles only apply where they should
* you can suddenly safely and comprehensibly share and inherit styles to DRY up your CSS and improve maintainability

<br />

# II) The right usage of Sass' @extend (and placeholder selectors)

As shown above, a central element of the modularization of your CSS is Sass' <code>@extend</code> functionality.  It allows you to inherit styles from a parent module inside your submodule.

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

Another option to achieve this code reuse in Sass would be to use <code>@mixins</code>.  Doing that, would look like this:

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
  border: 1px solid black;
  border-color: red;
}
```
The problem here is that mixins work like marcros and copy their properties everywhere they are used.  Therefore the compiled CSS code is not DRY at all and if you use this in many different places it would unnecessarily inflate the the size of your CSS stylesheets.

<code>@extend</code> is much more elegant and DRY in this regard, because it is using CSS's built-in inheritance capability, by copying selectors instead of properties.  However, at the same time this is the big disadvantage of <code>@extend</code>, because you can totally get yourself in deep trouble, with this selector copying.

The problem arises, when you start using the extended module in a different context.  Here is a simplistic example of such a case:

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

The problem here is, that <code>@extend</code> will copy the complete(**!**) extending selector (<code>.m-form .m-form--submit</code>) anywhere(**!**) you used the extended selector (<code>.m-button_attention</code>).  In addition, since that selector is using <code>@extend</code> itself (called [chaining extends](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#chaining_extends)), it will actually also copy the original selector to anywhere that extended selector (<code>.m-button</code>) is used.  This can lead to a couple of negative effects.

The biggest problem is that the <code>.m-form .m-form--submit</code> selector will suddenly appear inside the <code>.l-sidebar</code> context, with possibly breaking and very hard to debug consequences for your design.  This is unacceptable.  In addition, the selector copying is increasing the complexity of the CSS output exponentially, selectors using <code>.m-button</code> are going to get very long, cryptic and possibly slow, and finally this has a negative impact on Sass compilation times.

As a real world example for a worst case scenario we had it happen in one project that somebody extended some basic, ubiquitously used class from Twitter Bootstrap and immediately made our Sass stylesheet unusable. Compile time went from under a minute to 9 minutes(!).

To prevent this when applying SMURF we had to come up with the rule "Never @extend across modules".

However, luckily all of this changed with the recent introduction of [placeholder selectors](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#placeholders) in Sass version 3.2.  So, what are placeholder selectors?  Well, they are mostly just like regular selectors, but they have a different <code>%</code>-syntax (<code>%placeholder-selector</code>) and their only purpose is to be extended.  They won't appear in your CSS output and they can't be used for anything else besides being extended.  And that last feature suddenly makes them safe to use for extending beyond modules.

Now you simply define your module styles first as a placeholder selector and then you extend only that one both for the actual module, all the submodules, and also if you want to reuse the module in totally different contexts:

Sass:

```css
// button module
%m-button
  border: 1px solid black
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

For me, and for SMURF, that is a pretty revolutionary change that only gradually dawned on me and I'm a little surprise why there aren't more people in the Sass community are talking about placeholder selectors, yet.  So, please go out and change that.

<br />

# More about SMURF

If you want to know more about SMURF I recommend you to go watch my presentation at the awesome [ArrrCamp 6](http://arrrrcamp.be) in Belgium in October.  There is a [video recording with slides](https://vimeo.com/51903907) as well as the [presentation slides only](http://smurf-presentation.herokuapp.com/).


Besides that, check out our [Smurfville Github repository](https://github.com/railslove/smurfville) that has some more info about SMURF coding conventions in the [wiki](https://github.com/railslove/smurfville/wiki) and the Smurfville gem, which is trying to build a "living styleguide" base upon those coding conventions.  But that's a story for another upcoming blogpost.  Only that much:  We are actively looking for people to contribute to both the SMURF coding conventions and the Smurfville gem.  So, please head on over to GitHub and contribute in any way you can think of.

To stay up-to-date about SMURF, you can follow [@jkwebs](https://twitter.com/jkwebs) and [@railslove](https://twitter.com/railslove) on Twitter.  Also, if you should be interested in consulting services about modular frontend development, please come talk to us.

