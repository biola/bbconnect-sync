require 'erb'
require 'ostruct'

module EverbridgeSync
  module Email
    class Base
      attr_accessor :type, :contact

      def initialize(type, contact)
        @type = type
        @contact = contact
      end

      def send!
        email.deliver!
      end

      private

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
          'Everbridge Sync'
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