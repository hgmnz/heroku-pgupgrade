module Heroku::Command
  class Pg < BaseWithApp

    # pg:upgrade <FOLLOWER>
    #
    # unfollow a database and upgrade it to the latest PostgreSQL version
    #
    def upgrade
      name = args.shift
      follower_name, follower_url = hpg_resolve(name)

      case follower_name
      when /SHARED_DATABASE/
        output_with_bang "#{follower_name} does not support upgrading"
        return
      else
        upgrade_status = hpg_client(follower_url).upgrade_status

        if upgrade_status[:error]
          output_with_bang "There were problems upgrading #{follower_name}"
          output_with_bang upgrade_status[:error]
        else
          follower_db_info = hpg_client(follower_url).get_database
          origin_db_url    = follower_db_info[:following]
          # TODO: should be name not URL
          origin_name      = origin_db_url

          output_with_bang "#{follower_name} will be upgraded to a newer PostgreSQL version,"
          output_with_bang "stop following #{origin_name}, and become writable."
          output_with_bang "Use `heroku pg:wait` to track status"
          output_with_bang "\nThis cannot be undone."
          return unless confirm_command

          action "upgrading" do
            hpg_client(follower_url).upgrade
          end
        end

      end
    end

  end
end
