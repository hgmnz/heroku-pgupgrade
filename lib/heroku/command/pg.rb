module Heroku::Command
  class Pg < BaseWithApp

    # pg:upgrade <FOLLOWER>
    #
    # unfollow a database and upgrade it to the latest PostgreSQL version
    #
    def upgrade
      follower_db = resolve_db(:required => 'pg:upgrade')

      case follower_db[:name]
      when 'SHARED_DATABASE'
        output_with_bang "#{follower_db[:name]} does not support upgrading"
        return
      when /\A#{Resolver.shared_addon_prefix}\w+/
        output_with_bang "#{follower_db[:name]} does not support upgrading"
        return
      else
        follower_name  = follower_db[:pretty_name]
        upgrade_status = heroku_postgresql_client(follower_db[:url]).upgrade_status

        if upgrade_status[:error]
          output_with_bang "There were problems upgrading #{follower_name}"
          output_with_bang upgrade_status[:error]
        else
          follower_db_info = heroku_postgresql_client(follower_db[:url]).get_database
          origin_db_url    = follower_db_info[:following]
          origin_name      = name_from_url(origin_db_url)

          output_with_bang "#{follower_name} will be upgraded to a newer PostgreSQL version,"
          output_with_bang "stop following #{origin_name}, and become writable."
          output_with_bang "Use `heroku pg:wait` to track status"
          output_with_bang "\nThis cannot be undone."
          return unless confirm_command

          working_display "upgrading" do
            heroku_postgresql_client(follower_db[:url]).upgrade
          end
        end

      end
    end

  end
end
