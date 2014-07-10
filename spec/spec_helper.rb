$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

require 'bundler'
Bundler.setup :default, :test

require 'rspec'
require 'bbconnect_sync'
BBConnectSync.initialize!

Dir['./spec/support/*.rb'].each { |f| require f }
