---
title: UI-Check.com relaunched
author: paul_wittmann
featured_image: http://farm9.staticflickr.com/8156/7689995006_2212744f08_b.jpg
tags:
  keyword: ui-check
  keyword: clients
  keyword: relaunch
---
We're very proud to present our latest client work - the new [UI-check.com](http://www.ui-check.com).

[![UI-Check.com Screenshot](http://farm9.staticflickr.com/8156/7689995006_2212744f08_b.jpg)](http://www.ui-check.com)

UI-Check.com is a remote crowd testing service for (mobile) web sites and apps offering usability and quality assurance (bug) test packages.<br>
Site owners who'd like to improve the usability or safety of their websites can order test runs with 5 to 30 participating testers. UI-Check.com has a crowd of thousands of testers and you can choose testers by a range of criteria. Testers get a list of assignments, such as 'go to 9flats.com and book a flat in Berlin'. They then record a video of their screen as they browse your page and comment on what they're doing or what they find confusing. Besides the full videos, larger packages include PDF reports listing issues testers encountered with direct links to the relevant sequences in the videos.

UI-Check.com offers a great way to get real user feedback extremely fast - you get your results in one to three days, depending on your requirements. We can't wait to unleash their crowd of testers on the next website we build and hear their really helpful feedback =)

Development Process
-------------------
[Stephan](http://railslove.com/team/stephan_pavlovic) and I developed UI-Check.com in eight weeks. The design was done by [Liane](http://railslove.com/team/liane_thonnes), and [Michael](http://railslove.com/team/michael_bumann) helped us with refactoring, advanced backend stuff, and the deployment to Engine Yard, which we're using for the first time for a production system.<br>
We used Pivotal Tracker to plan weekly sprints and had daily Skype calls with Jan Wolter from UI-Check.com. The code's hosted on Github and continually tested with [Travis CI](http://travis-ci.org) Pro.

We started by implementing the data model and the workflow from ordering a test to the automatic selection of testers by certain criteria (gender, age, internet experience etc.).<br>
Once the design had been perfected, we started SMACSSing things up by following [Jakob's](http://railslove.com/team/jakob_hilden) [Smurfville conventions](https://github.com/railslove/smurfville/wiki/Styleguide). We love SMACSS and together with [Smurfville's](https://github.com/railslove/smurfville) adjustments for SASS and Compass (nesting for better code layout, the additional power of CSS variables, mixins, and extends) it was the best guideline we've ever had for structuring our front-end templates.

### Back end
* Ruby on Rails 3.2
* Engine Yard (production)
* Heroku (staging)
* [Delayed Job](https://github.com/collectiveidea/delayed_job)
* [Kaminari](https://github.com/amatsuda/kaminari)

### Front end
* HAML
* SASS (SASS syntax)
* CoffeeScript
* jQuery
* [Compass](http://compass-style.org)
* [SMACSS](http://smacss.com)

### Services
* [WebTranslateIt](https://webtranslateit.com)
* [Wistia](http://wistia.com)
