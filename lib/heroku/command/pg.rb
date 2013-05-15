module Heroku::Command
  class Pg < BaseWithApp

    # pg:upgrade <FOLLOWER>
    #
    # unfollow a database and upgrade it to the latest PostgreSQL version
    #
    def upgrade
      name = args.shift
      follower = hpg_resolve(name)
      client = hpg_client(follower)

      case follower.plan
      when "shared" # or "dev"
        output_with_bang "#{follower.resource_name} does not support upgrading"
        return
      else
        upgrade_status = hpg_client(follower).upgrade_status

        if upgrade_status[:error]
          output_with_bang "There were problems upgrading #{follower.resource_name}"
          output_with_bang upgrade_status[:error]
        else
          follower_db_info = hpg_client(follower).get_database
          origin_db_url    = follower_db_info[:following]
          # TODO: should be name not URL
          origin_name      = origin_db_url

          output_with_bang "#{follower.resource_name} will be upgraded to a newer PostgreSQL version,"
          output_with_bang "stop following #{origin_name}, and become writable."
          output_with_bang "Use `heroku pg:wait` to track status"
          output_with_bang "\nThis cannot be undone."
          return unless confirm_command

          action "Requesting upgrade" do
            hpg_client(follower).upgrade
          end
        end

      end
    end

  end
end
