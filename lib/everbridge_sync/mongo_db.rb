require 'delegate'

module EverbridgeSync
  class MongoDB < SimpleDelegator
    require 'mongo'

    def initialize
      mongo_client = Mongo::MongoClient.new(Settings.mongodb.host, Settings.mongodb.port)
      db = mongo_client.db(Settings.mongodb.database)
      db.authenticate Settings.mongodb.username, Settings.mongodb.password

      # Now that we've connected delegate everything to db
      super db
    end
  end
end