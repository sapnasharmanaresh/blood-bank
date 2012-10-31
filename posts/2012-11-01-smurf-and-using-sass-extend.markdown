---
title: SMACSS and SASS - The future of stylesheets
slug: smurf-and-using-sass-extend
author: jakob_hilden
featured_image: http://farm8.staticflickr.com/7261/7731744988_e2c0176b25_z.jpg
published: false
author_name: jakob
author_email: jakob@railslove.com
categories:
- sass
- railslove
- rails
- oss
- css
- smurf
tags:
  keyword:
  - smacss
  - sass
  - css
  - stylesheets
  - frontend
  - modular
  - conventions
  - smurf
---
# About SMURF and using Sass @extend

Back in March I attended a SMACSS workshop by Jonathan Snook and wrote a blogpost about the ["Future of Stylesheets"](/blog/2012/03/28/smacss-and-sass-the-future-of-stylesheets) with some thoughts on implementing the SMACSS approach using the Sass preprocessor language.  Well the story didn't end there this topic is still very hot for me.  At Railslove we have ever since been codifying our SMACSS+Sass+Rails ideas in the form of SMURF (**S**calable, **M**odular, re**U**sable **R**ails **F**rontends) and with the recent release of Sass 3.2 the possibilities have gotten even greater.

This blogpost is intended to give an overview of the current state of SMURF and the particular aspect of the usage of Sass' <code>@extend</code>.


## How to write better frontend code using SMACSS & Sass

When you start desiring to write better CSS frontend code, the first things you should actually learn about are general best practices such a [using only classes], [shallow selectors], [avoiding element selectors], [limiting depth of applicability] and [categorizing your styles].  In my opinion SMACSS did a really brilliant job in explaining these approaches and I can warmly recommend the SMACSS website to anybody.  In addition I also talked about these things in the first 5 advices of my recent [talk] at the [ArrrCamp] in Belgium.

However, in this blogpost I want to concentrate on the concrete implementation of SMACSS using Sass.

SMACSS introduces the concepts of modules, module components, states and submodules.  However, it doesn't really say too much about the actual coding conventions for these so SMURF tries fill that "gap" by establishing some clear coding guidelines:


### Modules are prefixed with <code>.m-</code>

This clearly differentiates parts of your CSS that are carefully designed for reuse from layout styles (using <code>.l-</code>), legacy code, libraries, and other non-modular CSS.


### Module components use a <code>--</code> syntax while submodules use <code>_</code>

Both module components and submodules start with the name of their modules, so the two syntaxes are used to differentiate the two:  <code>.m-module--component</code>, <code>.m-module_submodule</code>

The double dash is important if you use compound module names such as "list-item", to keep module name <code>.m-list-item</code> and component <code>--header</code>


### States

States are prefixed with <code>.is-</code> just as in SMACSS.


### Module modifiers

Because, creating a new submodule for every different context or use case proved to be kind of overkill, SMURF introduced "module modifiers".  They are something in between states and submodules.  They are defined in the same way as states, as an additional class on the root module <code>&.modifier</code>, but, just as a submodule, they describe a slightly different version of the module.  Examples would be things like <code>.m-module.right</code>, <code>.m-module.no-border</code>.  The idea is to use modifiers for little chainable changes to modules, which submodules are used for more "substantial" changes, that for example also affect components.

### Submodules

As just said, they describe different versions of a module for another context (e.g. <code>.m-module_sidebar</code>) or use case (e.g. <code>.m-module_attention</code>).


So a full-blown SMURF code example would look something like this:



The advantages of writing CSS (or Sass) this way are the following:

* you can infer something about the semantic of a selector just by its name & syntax
* styles have a much better defined (single) responsibility
* you make sure that styles only apply where they should
* you can suddenly safely and nachvollziehbar share and inhert styles to DRY up your CSS and improve maintainability


## The right usage of Sass' <code>@extend</code> (and placeholder selector)

A central element of the modularization of your CSS is Sass' <code>@extend</code> funcionality.

First of all it allows you to inherit styles from modules to submodules without unnecessarily blowing up your HTML.  In SMCASS (and e.g. in Twitter Bootstrap) you need to apply both classes to our element (<code>&lt;div class="m-module m-module\_submodule"&gt;</code>), while in SMURF you can just do (<code>&lt;div class="m-module\_submodule"&gt;</code>).

Another option for inheritance in Sass would be to use <code>@mixins</code>.  However, the big advantage of <code>@extend</code> is that it's not unnecessarily duplicating your CSS output.

So far, the big disadvantage of <code>@extend</code> has been that you can quickly get yourself in trouble when extending selectors used in multiple different places.  Therefore the SMURF rule of thumb up until recently was "Never @extend accros modules".

This is great:

```css
.m-button

.m-button_call-to-action
  @extend .m-button
```

But this can quickly get you in trouble

```css
.m-button

.m-form
  .m-form--submit
    @extend .m-button_call-to-action
```

Because when you also use the extendend module in other places, like:

```css
#homepage
  .m-button

.l-container
  .m-button
```

It will copy the complete(!) extending selector (<code>.m-form .m-form--button</code>) anywhere(!) you used the extended selector (<code>.m-button</code>).  This will slow down your Sass compilation and create unnecessary CSS bloat at the least and might even break your design in a very hard to debug way.  If you are very careful and strict with using your modules you could get away with this, but especially in a team setting the risk is way too high.

following extends ???

For example we had the case where somebody extended some basic, ubiquous class from Twitter's bootstrap and immediately crashed our Sass stylesheet. Compiling it went from under a minute to 9 minutes.

However, all of this changes with the recent introduction of placeholder selectors in Sass version 3.2.  What are placeholder selectors?  Well, they are mostly just like regular selectors, but their only purpose is to be extended, they won't appear in your CSS output and they can't be used for anything else besides being extended.  And that last feature suddenly makes them safe to use for extending beyond modules.

You simply define your module styles first in a placeholder selector and then you extend only that one both for the actual module and submodules, and also if you want to reuse the module in a totally different context:

```css
%m-button
  // styles

.m-button
  @extend %m-button

.m-button_submodule
  @extend %m-button

.m-form
  .m-form--submit
    @extend %m-button
```

Awesome isn't it?  Through placeholder selectors we now have a CSS code reusage/inheritance pattern that:

* safe to use in team settings
* DRY
* doesn't produce bloated CSS output


If you want to know more about SMURF I recommend you to go watch my presentation at the awesome [ArrrCamp 6](http://arrrrcamp.be) in Belgium in October:

* [Video recording with slides](https://vimeo.com/51903907)
* [Presentation slides only](http://smurf-presentation.herokuapp.com/)


Besides that, check out our [Smurfville Github repository] that has some more info about SMURF coding conventions in the wiki and the Smurfville gem, which is trying to build a "living styleguide" base upon those coding conventions.  But that's a story for another blogpost.  Only that much:  We are looking for people to contribute to both the SMURF coding conventions and the Smurfville gem.  So, happy forking, and really looking forward to hear all your feedback.

