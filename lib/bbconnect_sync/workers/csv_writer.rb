module BBConnectSync
  module Worker
    class CSVWriter
      include Sidekiq::Worker

      def initialize
        @synchronizer = BBConnectSync::Synchronizer.new
      end

      def perform
        if Settings.worker.enabled
          if file_path = @synchronizer.sync!
            # It would be nice to run this asynchronously but in a load balanced situation
            # we can't guarantee that the file wasn't written onto a different server.
            # Until we have a shared files directory, this is the best workaround.
            CSVUploader.new.perform(file_path)
          end
        end
      end
    end
  end
end
