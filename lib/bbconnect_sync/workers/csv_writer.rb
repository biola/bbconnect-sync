module BBConnectSync
  module Worker
    class CSVWriter
      include Sidekiq::Worker
      include Sidetiq::Schedulable

      recurrence do
        daily.hour_of_day(Settings.worker.schedule.hour)
      end
      # This job should only run once
      sidekiq_options unique: true

      def initialize
        @synchronizer = BBConnectSync::Synchronizer.new
      end

      def perform
        if Settings.worker.enabled
          if file_path = @synchronizer.sync!
            CSVUploader.new.perform(file_path)
          end
        end
      end
    end
  end
end
