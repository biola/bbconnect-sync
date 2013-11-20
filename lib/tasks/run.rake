namespace :run do
  desc 'Tell Sidekiq to run Everbridge Sync immediately'
  task(:nowish) do
    require './lib/everbridge_sync'
    require 'sidekiq'
    require 'sidetiq'

    EverbridgeSync.initialize!

    EverbridgeSync::Worker.perform_async
  end
end