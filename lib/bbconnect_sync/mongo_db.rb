module BBConnectSync
  class MongoDB
    require 'mongo'

    def self.client(&block)
      raise ArgumentError, 'A block must be given' unless block_given?

      mongo_client = if Settings.mongodb.hosts.length > 1
        hosts = Settings.mongodb.hosts.map { |host| "#{host}:#{Settings.mongodb.port}" }
        Mongo::MongoReplicaSetClient.new(hosts)
      else
        Mongo::MongoClient.new(Settings.mongodb.hosts.first)
      end
      db = mongo_client.db(Settings.mongodb.database)
      db.authenticate Settings.mongodb.username, Settings.mongodb.password

      result = yield db
      mongo_client.close
      result
    end
  end
end
