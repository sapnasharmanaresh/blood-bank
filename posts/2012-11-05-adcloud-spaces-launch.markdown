---
title: Adcloud Spaces Launch
author: stephan_pavlovic
featured_image: http://i.imgur.com/i8rUU.png
published: true
tags:
  keyword: adcloud, client, launch

---
We're very proud to present our latest client work - [Adcloud Spaces](http://spaces.adcloud.com).

Adcloud Spaces is a tool for small businesses to create and manage their online advertisement campaigns. In an easy three step process you choose an image for your ad, crop it to a nice format and set up your budget. If you like, you could target only specific geographical regions or restrict the websites your ad is shown on with some global topics.

![Adcloud Spaces Screenshot](http://i.imgur.com/fsjrO.png)

After that, you're ready to go and your campaign can be out there after a few minutes. While your campaign is running, you can monitor its performance and adjust the pricing or the targeting, if you are not happy with it.

Development Process
-------------------

[Max](http://railslove.com/team/maximilian_schulz), [Philipp](http://railslove.com/team/philipp_brumm/), [Schorsch](http://railslove.com/team/georg_leciejewski/), [Jan](http://railslove.com/team/jan_kus/) and [I](http://railslove.com/team/stephan_pavlovic/) are the core developer team of Adcloud Spaces and were supported by [Liane](http://railslove.com/team/liane_thonnes/), who did the initial design and helped with UI questions along the way. We worked closely with Verena Würbel, who was the project owner on the Adcloud side of things. With weekly sprints and daily standups, the organizational procedure was pretty normal.

This project was one of the first times we agreed on using the [Github Flow](http://scottchacon.com/2011/08/31/github-flow.html), which means we are only committing small bug fixes to master while every feature was developed strictly in a separate branch. After a feature landed, a pull request was created, which then got reviewed, criticized or even praised. The integration of [Travis CI Pro](https://magnum.travis-ci.com/) into Github is a big help for this. Using this approach the master stays deployable all the time and anything that is ready can immediately go to staging for a customer review.

API
-----------

Adcloud Spaces was developed alongside the new Adcloud API, which will be public soon. As Lars is part of the Adcloud API team, we were able to work really close with them. Spaces will be the first app consuming this API, so before we could start using it, our first step was to develop a gem that wraps the API and makes it easy to use in a Rails application.

With the current release of the gem you can do basic creation of campaigns, ads and attachments. Furthermore, you can get performance data of your campaigns like clicks, costs and conversions.

Geolocation
-----------

Adcloud Spaces enables you to book an ad for a whole country or specific regions; pick states, cities or be even more granular and punch in the first three digits of a city's postal code.

Naturally, we wanted to display the chosen regions on a map, so wet set out to build a database of locations available for booking ads. Fortunately, the advertising world runs on a semi-standard list provided by acuity.

The main challenge we had was finding high-quality sources of easily importable shape data. After trying out [Geonames](geonames.org) at first, we quickly settled on natural earth's amazing collection of free shape data, which we imported through their Google fusion tables.

![Adcloud Spaces Map Screenshot](http://i.imgur.com/i8rUU.png)

The country selection is driven by a collection of select2.js select boxes which load the regions' shape data and displays it on a Google Map. We initially used chosen.js, but it proved to be too limited, which caused us to hack it into submission, and in the end, drop it completely.

Javascript
----------

All our interaction concepts are event-driven. We are using a very thin wrapper around the jQuery event API, which allows us to use it as a pub/sub system. Components are wrapped in Coffeescript classes which emit events that are picked up by whoever needs to react to events. That way, we avoid the dreaded callback pyramid and can separate out concerns.


### Backend
* [Rails 3.2](http://rubyonrails.org)
* [Mysql](http://www.mysql.de/)
* [Carrierwave](https://github.com/jnicklas/carrierwave)
* [Kaminari](https://github.com/amatsuda/kaminari)
* [Css Splitter](https://github.com/zweilove/css_splitter)

### Frontend
* [HAML](http://haml.info)
* [Compass](http://compass-style.org)
* [Smurfville SASS conventions](https://github.com/railslove/smurfville)
* [CoffeeScript](http://coffeescript.org)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap)
