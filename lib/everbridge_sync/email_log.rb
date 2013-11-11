module EverbridgeSync
  module EmailLog
    def self.log(email)
      db = EverbridgeSync::MongoDB.new
      db[:email_log].save type: email.type, recipient: email.recipient, sent: Time.now
    end

    def self.last(email_type, recipient)
      db = EverbridgeSync::MongoDB.new
      db[:email_log].find({type: email_type, recipient: recipient}, sort: [:sent, :desc]).first
    end

    def self.last_email_at(email_type, recipient)
      log = EmailLog.last(email_type, recipient)
      log["sent"] unless log.nil?
    end
  end
end
