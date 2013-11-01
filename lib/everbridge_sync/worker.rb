require 'sidekiq'

module EverbridgeSync
  class Worker
    include Sidekiq::Worker

    def initialize
      @synchronizer = EverbridgeSync::Synchronizer.new
    end

    def perform
      @synchronizer.sync!
    end
  end
end