require 'delegate'

module BBConnectSync
  class MongoDB < SimpleDelegator
    require 'mongo'

    def initialize
      mongo_client = if Settings.mongodb.hosts.length > 1
        hosts = Settings.mongodb.hosts.map { |host| "#{host}:#{Settings.mongodb.port}" }
        Mongo::MongoReplicaSetClient.new(hosts)
      else
        Mongo::MongoClient.new(Settings.mongodb.hosts.first)
      end
      db = mongo_client.db(Settings.mongodb.database)
      db.authenticate Settings.mongodb.username, Settings.mongodb.password

      # Now that we've connected delegate everything to db
      super db
    end
  end
end
