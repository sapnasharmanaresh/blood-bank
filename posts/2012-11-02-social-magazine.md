---
title: Social Magazine - Fresh Publishing Platform for Enterprise 2.0
author: paul_wittmann
featured_image: http://i.imgur.com/tEmD3.png
published: false
tags:
  keyword: enterprise-2-0, corporate-publishing, social-media
---

Much like traditional newspapers, corporate in-house magazines are struggling to find effective ways to present their content online and to engage their readership. The biggest challenge seems to be to strike a good balance between new media and existing print issues.

Some in-house magazine's website is nothing but a stale digitised copy of the paper version. Many have seen the trouble that can arise when corporations carelessly try to harness social media for marketing - Shell's [Arctic Ready campaign](http://arcticready.com/social/gallery) is an extreme example - and are shunning social media altogether until better news arrive. Finally, there's the ones who cautiously started integrating social media, but there still seems to be confusion about how to bring editorial articles into harmony with community-generated content to shape exciting and vivid new online platforms that attract a broad readership.

Together with [Kuhn, Kammann & Kuhn](http://www.kkundk.de), a Cologne communications agency we've known for a long time, we've developed [Social Magazine](http://www.social-magazine.info), an intriguing new publishing platform combining the best features of traditional editorial publishing with social media.
An issue of [Social Magazine](http://www.social-magazine.info) consists of profesionally edited articles, published at the same time as the print issue, and short articles, published in real time. Readers can like, tag, recommend, or comment on articles and short articles. But what's more is that they can also write their own articles and compile them to their personal issues. By allowing readers to individually remix and enrich editorial content, [Social Magazine](http://www.social-magazine.info) entices employees to participate and create their own corporate news. The decisive advantage of [Social Magazine](http://www.social-magazine.info) is its hybrid structure; it's held up by a firm and stable skeleton of quality editorial content that's enlivened by a constant stream of contributions from its active user base.

For German speakers, here's a video introducing the idea behind [Social Magazine](http://www.social-magazine.info) and summarising its benefits:
<iframe width="560" height="315" src="http://www.youtube.com/embed/1dzbhKD3x3E" frameborder="0" allowfullscreen></iframe>

This August, after six months of planning and development, a first-stage version of [Social Magazine](http://www.social-magazine.info) was launched for Continental (_conti intern - Automotive online_). The reactions so far have been very positive; two more stages are in the making and further instances are planned. _Conti intern_ has even been [shortlisted](http://www.hr-excellence-awards.de/shortlist) for the Human Resources Excellence Awards 2012.

To learn more about [Social Magazine](http://www.social-magazine.info) or order your own instance, please visit [www.social-magazine.info](http://www.social-magazine.info), or contact us directly at: [team@railslove.com](mailto:team@railslove.com).


Development
-----------

Kuhn, Kammann und Kuhn created the conceptual as well as the page design. Most of the initial code was written by [Michael](http://railslove.com/team/michael_bumann) and [me](http://railslove.com/team/paul_wittmann). We're currently pushing the project ahead in a team of three - [Jakob](http://www.railslove.com/team/jakob_hilden), [Marco](http://www.railslove.com/team/marco_schaden), and [myself](http://railslove.com/team/paul_wittmann).
_Conti intern_ was deployed via VPN to Continental's intranet.

[Social Magazine](http://www.social-magazine.info) was built with the following components:

### Backend
* [Rails 3.2](http://rubyonrails.org)
* [MongoDB](http://www.mongodb.org) &amp; [Mongoid](http://two.mongoid.org)
* [Elasticsearch](http://www.elasticsearch.org) &amp; [Tire](https://github.com/karmi/tire)
* [Carrierwave](https://github.com/jnicklas/carrierwave)
* [Kaminari](https://github.com/amatsuda/kaminari)

### Frontend
* [HAML](http://haml.info)
* [Compass](http://compass-style.org)
* [Smurfville SASS conventions](https://github.com/railslove/smurfville)
* [CoffeeScript](http://coffeescript.org)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap) (admin backend only)
* [validation_rage](https://github.com/bumi/validation_rage)
