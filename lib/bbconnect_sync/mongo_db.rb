module BBConnectSync::MongoDB
  require 'mongo'

  def self.client(&block)
    raise ArgumentError, 'A block must be given' unless block_given?

    mongo_client = Mongo::Client.new(hosts, configuration)
    result = yield mongo_client
    mongo_client.close
    result
  end

  def self.hosts
    Settings.mongodb.hosts || ['localhost:27017']
  end

  def self.configuration
    conf = Settings.mongodb.to_hash
    conf[:database] ||= 'bbconnect_sync' # default
    conf.delete(:hosts)
    conf
  end
end
