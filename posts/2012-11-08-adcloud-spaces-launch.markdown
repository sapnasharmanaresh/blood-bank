---
title: Adcloud Spaces Launch
author: stephan_pavlovic
featured_image: http://i.imgur.com/i8rUU.png
published: false
tags:
  keyword: adcloud
  keyword: clients
  keyword: launch

---
We're very proud to present our latest client work - [Adcloud Spaces](http://spaces.adcloud.com).

Adcloud Spaces is a tool for small businesses to create and manage their online advertisting campaigns. In an easy three step process you choose an image for your ad, crop it to a nice format and set up you budget. If you like, you could target only specific cities or regions and restrict the website your ad is shown on with some global topics.

![Adcloud Spaces Screenshot](http://i.imgur.com/fsjrO.png)]

After that your ready to go and you campaign can be out there after a few minutes. While your advertising is running, you can monitor their performance and adjust the pricing or the targeting, if you are not happy with it.

Development Process
-------------------

Max, Philipp, Schorsch, Jan and me were the core developer team of Adcloud Spaces and were supported by Liane, who did the initial design and helped with ui questions along the way.   We worked closly with Verena Würbel, who was the project owner for Adcloud. With weekly sprints and daily standups, the organisational procedure was pretty normal.

This project was one of the first times, we agreed on only committing small bug fixes in the master and every feature was developed in a seperate branch. After finishig such a feature, a pull request was created and the others reviewed the code and gave tips for improvements.

Adcloud Spaces was developed in parallel to the Adcloud API, that will be public in a few weeks. Lars is part of the Adcloud API team, so that we were able to work really close with them. Spaces will be the first user of this api and will help pushing it forward.

### Back end
* Ruby on Rails 3.2
* Mysql

### Front end
* HAML
* SASS (SASS syntax)
* CoffeeScript
* jQuery
* [Compass](http://compass-style.org)
* [SMURF](https://github.com/railslove/smurfville/wiki)

### Services
* [WebTranslateIt](https://webtranslateit.com)
* Adcloud Api
