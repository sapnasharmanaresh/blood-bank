---
title: Currency conversion in Ruby
author: mike_poltyn
tags:
  keyword: currency
  project: railslove, sales_king
  people: mike_poltyn, georg_leciejewski
published: false

---

Last Friday (9th November) we have rolled out currency conversion in one of our big projects, [Salesking](/items/sales_king/). For those who do not know it, it is an invoicing and billing service, where you can create your own documents and print PDFs right away.

This post will show what were the problems we have encountered while developing this feature. While our needs were very specific, hopefully, this post will be useful for people who will tackle similar tasks in the future in an already developed project.

Data source
---

First big question we had ask ourselves was "Where do we get the data from". There are numerous sources for currency conversion, both free and paid. The choice is though and it will mostly depend on how many currencies you want to support.

We have also asked ourselves "What range of exchange rates we want to support". Since we work with static documents, which dates vary, we have to have access to historical exchange rates as well.

In the end, we chose [EU Central Bank](http://www.ecb.int/home/html/index.en.html) as our provider. Because we did not need all the currencies in the world, and because it's free, it made our choice pretty easy in the end.

EU Central Bank provides information about [24 currencies](http://www.ecb.int/stats/exchange/eurofxref/html/index.en.html), which is more than enough for our needs. The data also include historical exchange rates since 1999.

We have imported all the possible data from EU Central Bank to our own database, saving exchange rate date, base currency, counter currency, and the exchange rate. It also helped us index this data better, access it more efficient than reading it form a static file, and allowed us to update the exchange rates with new exchange rate as they come.

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

This is a short list of exchange rate services we have had a look at. For reasons mentioned above we haven't chosen them, but they deserve a short mention.

* [XE.com](http://www.xe.com/) - self-proclaimed "World's Favorite Currency and Foreign Exchange Site". This service has a great range of currencies (over 150 currencies!) and supports historical exchange rates. It's also very expensive (from $540/year).
* [Citibank N.A.](https://www.citivelocity.com/) - used by Google [in their search results](https://www.google.com/search?q=1+EUR+in+PLN).
* [Ruby Currency API](http://www.exchangerate-api.com/ruby-currency-api) - has a really nice API, but doesn't support historical exchange rates.

Data gaps
---

Because banks and markets usually do not work on the weekends, there are some gaps in available data. Therefore, we have to compensate for the data that is not there. First, we've come up with a simple solution in [a StackOverflow thread](http://stackoverflow.com/questions/6186962/sql-query-to-show-nearest-date):

    SELECT * FROM currencies
    ORDER BY ABS( DATEDIFF( currency_on, "date" ) ) ASC
    LIMIT 1

but after a quick look at it we've figured it was not enough, because when asked for Sunday's exchange rates, where there are no rates available, due to `ABS()` function, it would show us the nearest date, which is next Monday. That's obviously wrong, so, we needed to tweak our query just a bit:

    SELECT * FROM currencies
    WHERE DATEDIFF( currency_on, "date" ) <= 0
    ORDER BY ABS( DATEDIFF( currency_on, "date" ) ) ASC
    LIMIT 1

The added `WHERE` condition allowes to choose only exchange rates which exist before a given "`date`". The `ABS()` function is still needed in `ORDER BY`, because `DATEDIFF` will always return a negative value in our case.

Now, put it as a Rails scope, for example:

	scope :on, lambda{|date = Date.today| {
	  order: "ABS( DATEDIFF( currency_on, '#{date.to_s}' ) )",
	  limit: 1,
	  conditions: ["DATEDIFF( currency_on, :date ) <= 0", {date: date}]
	}}

And you're ready to do `Currency.on(Date.yesterday)`.

<small>P.S. to the scope code: To best of my knowledge, Rails version we're using in SalesKing does not support prepared SQL statements in other places than `conditions`, so the `order` call had to be put as an interpolated string.</small>

Document handling
---

Having the data, it's good to put these to use. Our case was to use them in documents users are creating:

![Currency](http://img.poltyn.com/currency_SK-20121114-130542.png)
<center><small>Currency fields shown when editing a document</small></center>

Therefore our clients can invoice their clients in a different currency than their company uses, and still retain all information about gotten money in their company.

![Example](http://img.poltyn.com/example-SK-currency-20121114-131307.png)
<center><small>Excerpt from an example PDF document with currency conversion made by SalesKing</small></center>

We had to take care of saving static value of exchange rate in documents. This is the most important thing to remember. Always save final exchange rate in the models. Exchange rates that we save in the database are there only for easy access and for filling in the exchange rate field in documents.

To properly format the currencies, we use [`money` gem](https://github.com/RubyMoney/money), which has [default currency formats defined](https://github.com/RubyMoney/money/blob/master/config/currency.json) for 158 currencies of the world. `money` gem is definitely the best library for Ruby right now for currency formatting and handling.

TL;DR
---

To sum it all up, there are just three things that have to be taken care of, while implementing historical exchange rates in Ruby project:

1. Choose your data source wisely. (EU Central Bank is a great example.)
2. Take care about dates, when banks do not work (weekends, holidays).
3. Use `money` gem for everything you can! It'll ease up development a lot for you.

I hope somebody will find this post useful. I couldn't find many exhaustive resources about currency conversion on the Internet, so I wrote this one myself.

