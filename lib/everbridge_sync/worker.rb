require 'sidekiq'
require 'sidetiq'

module EverbridgeSync
  class Worker
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    recurrence do
      daily.hour_of_day(Settings.schedule.hour)
    end

    def initialize
      @synchronizer = EverbridgeSync::Synchronizer.new
    end

    def perform
      @synchronizer.sync!
    end
  end
end