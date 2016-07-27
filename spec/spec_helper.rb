$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

require 'bundler'
Bundler.require :default, :test

require 'rspec'
require 'webmock/rspec'
require 'bbconnect_sync'
BBConnectSync.initialize!

Dir['./spec/support/*.rb'].each { |f| require f }

# Only log mongo errors, instead of every action
Mongo::Logger.logger.level = ::Logger::ERROR

RSpec.configure do |config|
  config.before(:each) do
    # Clear database before each test
    # Right now we are manually clearing what we create after each test,
    # so this is unnessesary, but it could be useful in the future.
    # BBConnectSync::MongoDB.client {|db| db.collections.each(&:drop) }
  end
end
