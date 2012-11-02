---
title: Adcloud Spaces Launch
author: stephan_pavlovic
featured_image: http://i.imgur.com/i8rUU.png
published: false
tags:
  keyword: adcloud, clients, launch

---
We're very proud to present our latest client work - [Adcloud Spaces](http://spaces.adcloud.com).

Adcloud Spaces is a tool for small businesses to create and manage their online advertisment campaigns. In an easy three step process you choose an image for your ad, crop it to a nice format and set up your budget. If you like, you could target only specific geographical regions or restrict the websites your ad is shown on with some global topics.

![Adcloud Spaces Screenshot](http://i.imgur.com/fsjrO.png)

After that you're ready to go and you campaign can be out there after a few minutes. While your campaign is running, you can monitor its performance and adjust the pricing or the targeting, if you are not happy with it.

Development Process
-------------------

Max, Philipp, Schorsch, Jan and I were the core developer team of Adcloud Spaces and were supported by Liane, who did the initial design and helped with UI questions along the way. We worked closly with Verena Würbel, who was the project owner on the Adcloud side of things. With weekly sprints and daily standups, the organizational procedure was pretty normal.

This project was one of the first times we agreed on only committing small bug fixes to master while every feature was developed strictly in a seperate branch. After a feature landed, a pull request was created, which then got reviewed, critized or even praised.

API
-----------

Adcloud Spaces was developed alongside the new Adcloud API, which will be public soon.As Lars is part of the Adcloud API team, we were able to work really close with them. Spaces will be the first user of this API, so before we could start using it, our first step was to develop a gem, that wraps the API.

With the current release of the gem you can do basic creation of campaigns, ads and attachments. Furthermore you can get performance data of your campaigns like clicks, costs and conversions.

Geolocation
-----------

Adcloud Spaces enables you to book an ad for a whole country or specific regions; Pick states, cities or be even more granular and punch in the first three digits of a cities' postal code.

Naturally, we wanted to display the chosen regions on a map, so wet set out to build a database of locations available for booking ads. Fortunately, the advertising world runs on a semi-standard list provided by acuity

The main challenge we had was finding high-quality sources of easily importable shape data. After trying out geonames.org at first, we quickly settled on natural earth's amazing collection of free shape data, which we imported through their Google fusion tables.

![Adcloud Spaces Map Screenshot](http://i.imgur.com/i8rUU.png)

The country selection is driven by a collection of select2.js select boxes which loads the regions' shape data and displays it on a Google Map. We initially used chosen.js, but it proved to be too limited, which caused us to hack it into submission, and in the end, drop it completely.

Javascript
----------

All our interaction concepts are event-driven. We are using a very thin wrapper around the jQuery event API, which allows us to use it as a pub/sub system. Components are wrapped in Coffeescript classes which emit events that are picked up by whoever needs to react to events. That way, we avoid the dreaded callback pyramid and can separate out concerns.
