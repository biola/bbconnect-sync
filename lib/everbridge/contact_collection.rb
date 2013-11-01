module Everbridge
  class ContactCollection
    attr_accessor :contacts

    def initialize
      @contacts = []
    end

    def <<(contact)
      @contacts << contact
    end

    def [](contact)
      contacts.find do |c|
        c.is? contact
      end
    end

    def includes?(contact)
      !!self[contact]
    end

    def -(other_collection)
      unless other_collection.is_a? self.class
        raise ArgumentError, "other_collection must be a #{self.class}"
      end

      self.contacts.reject do |contact|
        other_collection.includes? contact
      end
    end

    def self.all
      db = EverbridgeSync::MongoDB.new

      self.new.tap do |collection|
        db[:contacts].find.map do |record|
          collection << Contact.new(record['id_number'], record['first_name'], record['last_name'], record['email'], record['cell'], record['groups'])
        end
      end
    end
  end
end