module EverbridgeSync

  def self.initialize!
    require 'rails_config'
    require 'mail'
    require 'sidekiq'
    require 'exception_notification'

    env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :development

    RailsConfig.load_and_set_settings('./config/settings.yml', "./config/settings.#{env}.yml", './config/settings.local.yml')

    Mail.defaults do
      delivery_method Settings.email.delivery_method, Settings.email.options.to_hash
    end

    Sidekiq.configure_server do |config|
      config.redis = { url: Settings.redis.url, namespace: 'everbridge-sync' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: Settings.redis.url, namespace: 'everbridge-sync' }
    end

    if defined? ::ExceptionNotifier
      require 'active_support/core_ext'
      require 'exception_notification/sidekiq'
      ExceptionNotifier.register_exception_notifier(:email, Settings.exception_notification.options.to_hash)
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