module BBConnectSync

  def self.initialize!
    env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :development

    RailsConfig.load_and_set_settings('./config/settings.yml', "./config/settings.#{env}.yml", './config/settings.local.yml')

    if defined? Raven
      Raven.configure do |config|
        config.dsn = Settings.sentry.url
      end
    end

    Sidekiq.configure_server do |config|
      config.redis = { url: Settings.redis.url, namespace: 'bbconnect-sync' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: Settings.redis.url, namespace: 'bbconnect-sync' }
    end

    require './lib/bbconnect'
    require './lib/bbconnect_sync/group_rules'
    require './lib/bbconnect_sync/mongo_db'
    require './lib/bbconnect_sync/oracle'
    require './lib/bbconnect_sync/synchronizer'
    require './lib/bbconnect_sync/workers/csv_writer'
    require './lib/bbconnect_sync/workers/csv_uploader'

    true
  end
end
