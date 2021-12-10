# Fetch Rewards backend code challenge
### Rowan DeLong

## Table of contents
- [Overview](#overview)
- [SetUp](#setup)
- [Endpoints](#endpoints)
- [Contact](#contact)

## Overview
This is a code challenge for Fetch Rewards backend apprenticeship application

This is hosted on Heroku at: [https://delong-fetch-challenge.herokuapp.com/](https://delong-fetch-challenge.herokuapp.com/)
* note this is only an api with no views so, the webpage will give you a 404 error, but the endpoints can be accessed via HTTP request

## Setup
To use this application:

* Clone this repository
* Ensure you have [ruby v2.7.2](https://www.ruby-lang.org/en/downloads/), [rails v5.2.5](https://rails.github.io/download/), and [postgres](https://www.postgresql.org/download/) installed on your machine
* From the command line, install gems and set up your DB:
    * `bundle install`
    * `rails db:{create,migrate}`
* Run the test suite with `bundle exec rspec`
* Run your development server with `rails s` to see the app in action.

## Endpoints

#### Add Transaction

`POST /add_transaction params{"payer": <PAYER_NAME>, "points": <POINTS_TO_ADD>, "timestamp": <TIMESTAMP>}`

Example JSON response:

```
{
    "payer": "DANNON",
    "points": 500,
    "timestamp": "2020-11-02T14:00:00.000Z"
}
```

#### Spend Points

`POST /spend_points params{"points": <POINTS_TO_SPEND>}`

Example JSON response:

```
{
    "DANNON": -300,
    "UNILEVER": -200
}
```

#### Points Balances

`GET /points_balance`

Example JSON response:

```
{
    "UNILEVER": 800,
    "DANNON": 300
}
```

### Contact

* Rowan DeLong
* rowanwinzer@gmail.com
* [LinkedIn](https://www.linkedin.com/in/rowandelong)


