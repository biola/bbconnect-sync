module BBConnect
  class ContactCollection
    attr_accessor :contacts

    def initialize(contacts = [])
      @contacts = Array(contacts)
    end

    def <<(contact)
      @contacts << contact
    end

    def [](contact)
      contacts.find do |c|
        c.is? contact
      end
    end

    def each
      contacts.each do |contact|
        yield contact
      end
    end

    def includes?(contact)
      !!self[contact]
    end

    def -(other_collection)
      unless other_collection.is_a? self.class
        raise ArgumentError, "other_collection must be a #{self.class}"
      end

      contacts - other_collection.contacts
    end

    def self.all
      BBConnectSync::MongoDB.client do |db|
        self.new.tap do |collection|
          db[:contacts].find.map do |record|
            collection << Contact.new(record['id_number'], record['first_name'], record['last_name'], record['email'], record['groups'])
          end
        end
      end
    end
  end
end
