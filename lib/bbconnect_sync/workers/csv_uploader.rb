module BBConnectSync
  module Worker
    class UploadError < StandardError; end

    class CSVUploader
      include Sidekiq::Worker

      URL = 'https://www.blackboardconnected.com/contacts/importer_portal.asp?qDest=imp'
      # User-Agent has to be set to this or it won't work because it's stupid.
      USER_AGENT = 'Autoscript (curl)'

      def perform(file_path)
        curl = Curl::Easy.new(URL)
        curl.enable_cookies = true
        curl.follow_location = true
        curl.headers['User-Agent'] = USER_AGENT
        curl.multipart_form_post = true
        curl.http_post(
          Curl::PostField.content('fNTIUser', Settings.bbconnect.username),
          Curl::PostField.content('fNTIPassEnc', Settings.bbconnect.password),
          Curl::PostField.content('fPreserveData', '1'),
          Curl::PostField.content('fSubmit', '1'),
          Curl::PostField.file('fFile', file_path)
        )

        raise UploadError, "#{curl.body}" unless successful?(curl)
      end

      private

      def successful?(curl)
        !!(curl.response_code == 200 && curl.body =~ /Your data has been received/)
      end
    end
  end
end
