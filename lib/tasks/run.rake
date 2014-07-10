namespace :run do
  desc 'Tell Sidekiq to run Blackboard Connect Sync immediately'
  task(:nowish) do
    require './lib/bbconnect_sync'
    require 'sidekiq'
    require 'sidetiq'

    BBConnectSync.initialize!

    BBConnectSync::Worker.perform_async
  end
end
