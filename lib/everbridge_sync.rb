module EverbridgeSync

  def self.initialize!
    require 'rails_config'
    require 'mail'
    require 'sidekiq'

    env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :development

    RailsConfig.load_and_set_settings('./config/settings.yml', "./config/settings.#{env}.yml", './config/settings.local.yml')

    Mail.defaults do
      delivery_method Settings.email.delivery_method, address: Settings.email.options
    end

    Sidekiq.configure_server do |config|
      config.redis = { url: Settings.redis.url, namespace: 'everbridge-sync' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: Settings.redis.url, namespace: 'everbridge-sync' }
    end

    require './lib/everbridge'
    require './lib/everbridge_sync/email'
    require './lib/everbridge_sync/email_log'
    require './lib/everbridge_sync/group_rules'
    require './lib/everbridge_sync/mongo_db'
    require './lib/everbridge_sync/oracle'
    require './lib/everbridge_sync/synchronizer'
    require './lib/everbridge_sync/worker'

    true
  end
end