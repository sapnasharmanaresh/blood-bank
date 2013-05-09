---
title: In Defence of jQuery UI and about new Possiblities using it with Sass
slug: jquery-ui-sass-rails
author: jakob_hilden
featured_image: https://dl.dropbox.com/u/409736/smurf_blog_background.png
published: false
published_at: 2012-11-09
tags:
  keyword: sass, railslove, rails, oss, css, stylesheets, jquery-ui, gem, javascript, ui, frontend
---

# Rehabilitating jQuery UI with Words and Sass

What do you think about jQuery-UI?  I have personally always been a pretty big fan, but I have also kept on hearing people talk badly about it.  Two of the main points of criticism I was hearing have been the 1) lack of (visible) progress in the project over the years and 2) jQuery UI's suboptimal design and CSS code.  In this blogpost I want to defend the value and quality of library and show how the pain of customizing its design & CSS can be alleviated using Sass.

## Criticism #1:  Development is soo sloooow!

The first point about the slow progress of the project has certainly been somewhat justified for a long time (e.g. certain new widgets have actually taken years to be released).  However, I think progress has definitely picked up within the last year, where we were able to see the releases of versions 1.9 and 1.10 in fairly rapid succession, which is already really good news.  Also, the criticism has been mostly about lack of **visible** progress, which doesn't mean there was no progress at all.  On the contrary a lot of time has been spent on important and valuable internal refactorings.

In addition, the focus of jQuery UI has always been to provide a very stable, cross-browser compatible, accessible framework, so big changes are not always very easy to achieve.  And finally, it's an open source project with no huge company backing it, so it relies mainly on the personal time of volunteers.  I'm glad that jQuery UI is this kind of **stable, independent, well maintained open source framework** and if the current speed of development is kept up **everything is cool**.

## Criticism #2:  Design is soo uuuugly!

The second area of criticism I was hearing dealt with jQuery UI's dated design and the difficulties working with its CSS framework, and I can definitely relate to those points.  The theme design hasn't been updated in years and still looks a little bit like Windows XP with its bubbly, round and glossy style.  This itself wouldn't actually be a problem if the CSS was really easy to customize.  Because in most cases you will want to adjust the look of the widgets to your site's design anyway.  But jQuery UI's CSS & HTML is quite complex and not very easy to get a grip on for some quick customizations.  You always had to hunt for all the right classes to customize and, in some special cases, even needed to resort to dirty hacks like `!important`.

The other option for customization was to not use the theme CSS at all and write your own, but this required good knowledge of the jQuery UI HTML structure as well and it took time to build a theme that is functionally on par with the jQuery UI theme.  In both cases you ended up with a pile of custom CSS code that you had to maintain (e.g. when jQuery UI releases updates).  So the situation wasn't really great and I can understand why people would choose other widgets, that look better from the start or have a simpler HTML structure to customize them.

## Sass to the Rescue

However, this situation has changed now thanks to the power of Sass.  I recently released the [jquery-ui-sass-rails](https://github.com/jhilden/jquery-ui-sass-rails) gem which allows you to quickly and easily customize jQuery UI themes using Sass variables.  All you need to do now is to customize a handful of variables before you `@import` the jQuery UI Sass stylesheets from the gem and then the widgets will fit quite nicely into your app's design without any big effort.

### How it Works

The way it works is that jQuery UI has already placed a form of pseudo CSS variables in their `theme.css`, which they use during the build process to create all the different Themeroller themes.  All I'm doing in my gem is to replace those parts of the `theme.css` with regular Sass variables.  The actual theme information is stored in a set of Sass variables, which you can easily adjust and override.  In any well structured Sass project you should already have all your colors inside variables, so the main thing you would do is to map your variables to the jQuery UI theme variables.

```css
$borderColorDefault: $apps-border-color
$bgColorHeader: $apps-light-grey
...
```
For more information about the gem please refer to its README at: [github.com/jhilden/jquery-ui-sass-rails](https://github.com/jhilden/jquery-ui-sass-rails)

### In Production

I have recently used `jquery-ui-sass-rails` in our first production app ([sportabzeichen.splink.de](http://sportabzeichen.splink.de)) and I have to say, it was a real pleasure to use.  I simply adjusted a total of only 11 variables disabling round corners and glossy backgrounds, changing some colors and the result already looked very good inside the app's the design.  Maximum effect with minimum effort!  Besides the simplicity and quickness of this type of customization it also creates less code, is DRYer and a lot more update-friendly.

Here is a screenshot of the app's jQuery UI datepicker.  Customized using **only 11 variables**:

![jQuery UI Datepicker in Splink Sportabzeichen app](https://dl.dropboxusercontent.com/u/409736/static/splink_sportabzeichen_datepicker.png)

## Perspectives for the Future

To further improve the customization of jQuery UI using Sass, here are some possible future goals:

### Distribution

The gem is packaged to be used within a Rails app, but its Sass files could actually easily be used within any Sass project.  A good idea might also be to create a `jquery-ui` [Compass](http://compass-style.org/) extension (hint: any help with that would be appreciated).

### Better Integration with jQuery UI

The integration with the jQuery UI codebase could also still be improved.  For example, right now I'm manually parsing the theme variables from the compiled CSS, which is hacky and error prone.  But there is already some [discussion](https://github.com/jquery/download.jqueryui.com/issues/36) to put the variable sets from all the themes into the jquery-ui codebase in an accessible format (probably JSON).  It's not Sass variables, but it would already make the integration a lot more solid.

I personally think it would be great to use even more of the power of Sass (and maybe Compass) into jQuery UI in order to DRY up their code and to make it even easier to customize.  However, they are a little reluctant to introduce technologies that are not official web standards.

### Convenience Improvements

I would also like to simplify the variable usage even more by creating some convenience variables such as `$glossyBackgrounds: false`, because it's still not 100% obvious which variables control what.  Any suggestions (or help) is very welcome.

## Questions Anybody?

In general I would be grateful for any feedback.  What do you think about the gem?  Does this change your opinion about jQuery UI?  Are there other things that bother you?  Should jQuery UI start using Sass, even though it's not an official web standard or wait for the CSS spec (variables etc.) to evolve?
