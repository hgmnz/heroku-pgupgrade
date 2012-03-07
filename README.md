# heroku pg:upgrade

  Upgrades your Dedicated Postgres database to the latest version, current 9.1.

## Installation

  heroku plugins:install git://github.com/hgimenez/heroku-pgupgrade.git

## Usage

In short: `heroku pg:upgrade HEROKU_POSTGRESQL_BLUE --app your_app`

This command will only work on a follower, so that your main database is kept
untouched, and so that it contains the most recent data possible. During the
course of the upgrade, it will unfollow its parent and run the upgrade
procedure. During the upgrade, you can use `heroku pg:wait` to be track progress.

After the upgrade is done, check the data in the new database and make sure that
everything still works. Then use `heroku pg:promote` to promote the upgraded
database for your application. Leave the old one around until you're comfortable
with the new database.

## THIS IS BETA SOFTWARE

Thanks for trying it out. If you find any issues, please notify us at support@heroku.com
