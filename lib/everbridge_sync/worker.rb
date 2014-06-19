require 'sidekiq'
require 'sidetiq'

module EverbridgeSync
  class Worker
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    recurrence do
      daily.hour_of_day(Settings.worker.schedule.hour)
    end
    # This job should only run once
    sidekiq_options unique: true

    def initialize
      @synchronizer = EverbridgeSync::Synchronizer.new
    end

    def perform
      if Settings.worker.enabled
        @synchronizer.sync!
      end
    end
  end
end