require 'erb'
require 'ostruct'

module EverbridgeSync
  class InvalidCellEmail
    attr_accessor :contact

    def initialize(contact)
      @contact = contact
    end

    def send!
      email.deliver!
    end

    private

    def email
      email_address = self.contact.email
      message = body

      @email ||= Mail.new do
        from    Settings.email.from
        to      email_address
        subject Settings.email.invalid_cell.subject
        body    message
      end
    end

    def body
      erb = ERB.new(File.read('emails/invalid_cell.erb'))
      struct = OpenStruct.new(contact.attributes)

      erb.result(struct.instance_eval { binding })
    end
  end
end