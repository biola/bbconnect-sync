module Everbridge
  class ContactCollectionComparer
    attr_reader :old_collection, :new_collection

    def initialize(old_collection, new_collection)
      @old_collection = old_collection
      @new_collection = new_collection
    end

    def added
      @added ||= new_collection - old_collection
    end

    def updated
      @updated ||= new_collection.contacts.select do |new_contact|
        old_contact = old_collection[new_contact]

        old_contact && old_contact != new_contact
      end
    end

    def removed
      @removed ||= old_collection - new_collection
    end
  end
end