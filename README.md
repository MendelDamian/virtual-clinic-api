### Projekt Innowacja 2022/2023 API

[For beginners](https://htdror.notion.site/HTD-Innowacja-API-3a5831af7f994c84875cacc46066bc00)

#### Requirements

- `ruby`, installation instruction - [Ruby](https://www.ruby-lang.org/en/documentation/installation/), check the `ruby` version: `ruby -v`, you should have `ruby '3.0.4'`
- `postgresql` - [Download](https://www.postgresql.org/download/), required version `PG 14.X`

#### You should initialize environment variables

- create file with name `.env` in main folder `projekt-innowacja-2023-api`
- add environment variables:
  - `DB_NAME=<nazwa_bazy>`
  - `DB_USERNAME=<nazwa_usera>`
  - `DB_PASSWORD=<password>`

#### Update all gems and set up the database

- write in the console: `bundle install`
- for setup database: `bundle exec rake db:create && bundle exec rake db:migrate`

#### Start the server

- `rails s` or `rails server`
