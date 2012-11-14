---
title: Currency conversion in Ruby
author: mike_poltyn
tags:
  keyword: currency
  project: railslove, sales_king
  person: mike_poltyn, georg_leciejewski
published: true

---

Last Friday (9th November) we rolled out currency conversion in one of our big projects, [Salesking](/items/sales_king/). For those who don't know it, it is an invoicing and billing service where you can create your own documents and print PDFs right away.

This post will show what problems we encountered while developing this feature. While our needs were very specific, hopefully, this post will be useful for people tackling similar tasks in their own projects.

TL;DR
---

To sum it all up, there are just three things that have to be taken care of, while implementing historical exchange rates in a Ruby project:

1. Choose your data source wisely. (the European Central Bank is a great choice for starters)
2. Take care of dates when banks are closed (weekends, holidays).
3. Use the `money` gem for everything you can! It'll ease up development a lot for you.

Data source
---

The first question we asked ourselves was "Where do we get the conversion data from?". There are numerous services offering conversion rates, both free and paid. The choice is tough and will mostly depend on how many currencies you'd like to support.

We have also asked ourselves "What range of exchange rates do we want to support?". Since we work with static documents, whose dates vary, we need to have access to historical exchange rates as well.

In the end, we chose the [European Central Bank](http://www.ecb. nt/home/html/index.en.html) (ECB) as our provider Because we don't need all the currencies in the world and because their service is free, our  hoice was pretty easy after all. The ECB provides information about [24 currencies](http://www.ecb.int/stats/exchange/eurofxref/html/in ex.en.html), which is more than enough for our needs. The data also includes historical exchange rates since 1999.

We imported all the data from the ECB to our own database, saving exchange rate dates, base currency, counter currency, and exchange rates. This process allowed us to index the data to access it quicker and more efficiently than reading it form the static file offered by the ECB. Furthermore, with this setup in place, updating exchange rates with new data from the ECB is a breeze.

    mysql> DESCRIBE currencies;
    +------------------+----------------+------+-----+---------+-------+
    | Field            | Type           | Null | Key | Default | Extra |
    +------------------+----------------+------+-----+---------+-------+
    | currency_on      | date           | YES  | MUL | NULL    |       |
    | base_currency    | varchar(3)     | YES  |     | NULL    |       |
    | counter_currency | varchar(3)     | YES  |     | NULL    |       |
    | exchange_rate    | decimal(16,10) | YES  |     | NULL    |       |
    +------------------+----------------+------+-----+---------+-------+

#### Paid sources

Here is a short list of alternative exchange rate services we had a look at. For reasons mentioned above we haven't chosen them, but they deserve a short mention.

* [XE.com](http://www.xe.com/) - self-proclaimed "World's Favorite Currency and Foreign Exchange Site". This service has a great range of currencies (over 150 currencies!) and supports historical exchange rates. It's also very expensive (from $540/year).
* [Citibank N.A.](https://www.citivelocity.com/) - used by Google [in their search results](https://www.google.com/search?q=1+EUR+in+PLN).
* [Ruby Currency API](http://www.exchangerate-api.com/ruby-currency-api) - has a really nice API, but doesn't support historical exchange rates.

Data gaps
---

Because banks and stock exchanges are usually closed on weekends there are some gaps in the available data. Therefore, we have to compensate for "weekend gaps". First, we found with a simple solution in [a StackOverflow thread](http://stackoverflow.com/questions/6186962/sql-query-to-show-nearest-date):

    SELECT * FROM currencies
    ORDER BY ABS( DATEDIFF( currency_on, "date" ) ) ASC
    LIMIT 1

But after a quick look we figured it wasn't enough because when asked for Sunday's exchange rates (for which no rates are available), due to how the `ABS()` function works, it would show us the nearest date, which is the following Monday. That's obviously wrong, so we needed to tweak our query just a bit:

    SELECT * FROM currencies
    WHERE DATEDIFF( currency_on, "date" ) <= 0
    ORDER BY ABS( DATEDIFF( currency_on, "date" ) ) ASC
    LIMIT 1

The added `WHERE` condition allows us to choose only exchange rates which exist before a given "`date`". The `ABS()` function is still needed in the `ORDER BY` because `DATEDIFF` will always return a negative value in our case.

As a Rails scope it would look like this:

    scope :on, lambda { |date = Date.today| {
      order: "ABS( DATEDIFF( currency_on, '#{date.to_s}' ) )",
      limit: 1,
      conditions: ["DATEDIFF( currency_on, :date ) <= 0", {date: date}]
    }}

And you're ready to do `Currency.on(Date.yesterday)`.

<small>P.S. to the scope code: as far as I know, the Rails version we're using on SalesKing doesn't support prepared SQL statements except in `conditions`, so the `order` call had to be put as an interpolated string.</small>

Document handling
---

Time to put all the juicy exchange rate data to good use! In our case, we wanted to use it for user-generated documents:

![Currency](http://img.poltyn.com/currency_SK-20121114-130542.png)
<center><small>Currency fields shown when editing a document</small></center>

Therefore, our clients can invoice their clients in a different currency than their company uses and still retain all the required information on money their company received (in their home currency).

![Example](http://img.poltyn.com/example-SK-currency-20121114-131307.png)
<center><small>Excerpt from an example PDF document with currency conversion made by SalesKing</small></center>

We had to take care of saving static values of exchange rates in documents. This is the most important thing to remember. Always save the final exchange rate in the models. Exchange rates that we save in the database are there only for easy access and for filling in the exchange rate field in documents.

To properly format the currencies, we use the [`money` gem](https://github.com/RubyMoney/money), which has [default currency formats defined](https://github.com/RubyMoney/money/blob/master/config/currency.json) for 158 currencies of the world. The `money` gem is definitely the best library for Ruby right now for currency formatting and handling.

Afterword
---

I hope this post will save you some of the trouble I had with currency conversion and will be a helpful guide to many Ruby and Ruby on Rails developers!
