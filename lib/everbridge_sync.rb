module EverbridgeSync
  require './lib/everbridge'
  require './lib/everbridge_sync/group_rules'
  require './lib/everbridge_sync/mongo_db'
  require './lib/everbridge_sync/oracle'
  require './lib/everbridge_sync/synchronizer'
  require './lib/everbridge_sync/worker'

  def self.initialize!
    require 'rails_config'

    env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :development

    RailsConfig.load_and_set_settings('./config/settings.yml', "./config/settings.#{env}.yml", './config/settings.local.yml')

    true
  end
end