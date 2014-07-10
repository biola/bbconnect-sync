require 'erb'
require 'ostruct'

module BBConnectSync
  module Email
    class Base
      attr_accessor :type, :contact

      def initialize(type, contact)
        @type = type
        @contact = contact
      end

      def recipient
        contact.email
      end

      def send!
        unless recently_sent?
          email.deliver!
          EmailLog.log(self)
        end
      end

      private

      def recently_sent?
        last_email_at = EmailLog.last_email_at(type, recipient)
        return false if last_email_at.nil?

        last_email_at >= cut_off_date
      end

      def cut_off_date
        # Converting days into seconds
        Time.now - Settings.email.once_every * 24 * 60 * 60
      end

      def email
        email_address = self.contact.email
        subj = subject
        message = body

        @email ||= Mail.new do
          from    Settings.email.from
          to      email_address
          subject subj
          body    message
        end
      end

      def subject
        if Settings.email[type]
          Settings.email[type].subject
        else
          'Blackboard Connect Sync'
        end
      end

      def body
        erb = ERB.new(File.read("emails/#{type}.erb"))
        struct = OpenStruct.new(contact.attributes)

        erb.result(struct.instance_eval { binding })
      end
    end
  end
end
