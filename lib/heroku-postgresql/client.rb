class Heroku::Client::HerokuPostgresql
  def upgrade
    http_post "#{@database_sha}/upgrade"
  end

  def upgrade_status
    http_get "#{@database_sha}/upgrade_status"
  end
end
