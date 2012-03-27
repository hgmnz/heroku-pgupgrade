# heroku pg:upgrade

Upgrades your Dedicated Postgres database to the latest version, current 9.1.

## Installation

    heroku plugins:install git://github.com/hgimenez/heroku-pgupgrade.git

## Usage

In short: `heroku pg:upgrade A_FOLLOWER_HEROKU_POSTGRES_URL --app your_app`

This command will only work on a follower, so that your main database is kept
untouched, and so that it contains the most recent data possible. During the
course of the upgrade, it will unfollow its parent and run the upgrade
procedure. During the upgrade, you can use `heroku pg:wait` to track progress.

After the upgrade is done, check the data in the new database and make sure that
everything still works. Then use `heroku pg:promote` to promote the upgraded
database for your application. Leave the old one around until you're comfortable
with the new database.

A typical upgrade procedure looks like so:

    # Create a follower
    heroku addons:add heroku-postgresql:<your-plan> --follow=MASTER_DATABASE_URL --app <your-app>
    # Wait until it's cought up with the master
    heroku pg:wait --app <your-app>
    # Put your app in maintenance mode
    heroku maintenance:on --app <your-app>
    # Upgrade the follower
    heroku pg:upgrade FOLLOWER_URL --app <your-app>
    # Wait until it completes upgrading
    heroku pg:wait --app <your-app>
    # Promote it, so your app now talks to this new database
    heroku pg:promote UPGRADED_DATABASE_URL --app <your-app>
    # Remove maintenance mode
    heroku maintenance:off --app <your-app>

We recommend you leave the original master for a few days, or until you're comfortable
that the new database is working as expected. To remove the old database, simply remove
the addon:

    heroku addons:remove OLD_DATABASE_URL --app <your-app>

## THIS IS BETA SOFTWARE

Thanks for trying it out. If you find any issues, please notify us at support@heroku.com
