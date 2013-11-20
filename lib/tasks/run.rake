namespace :run do
  desc 'Tell Sidekiq to run Everbridge Sync immediately'
  task(:nowish) do
    EverbridgeSync::Worker.perform_async
  end
end