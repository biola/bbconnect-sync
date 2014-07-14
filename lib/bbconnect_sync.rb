module BBConnectSync

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
      config.redis = { url: Settings.redis.url, namespace: 'bbconnect-sync' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: Settings.redis.url, namespace: 'bbconnect-sync' }
    end

    if defined? ::ExceptionNotifier
      require 'active_support/core_ext'
      require 'exception_notification/sidekiq'
      ExceptionNotifier.register_exception_notifier(:email, Settings.exception_notification.options.to_hash)
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
