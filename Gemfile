source 'https://rubygems.org'

gem 'curb'
gem 'mongodb'
gem 'rails_config'
gem 'rake'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'progress_bar'

group :development, :staging, :production do
  gem 'ruby-oci8', require: 'oci8'
end

group :development, :test do
  gem 'pry'
  gem 'pry-stack_explorer'
  gem 'pry-rescue'
end

group :test do
  gem 'rspec'
  gem 'webmock'
end

group :production do
  gem 'sentry-raven'
end
