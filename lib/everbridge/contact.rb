module Everbridge
  class Contact
    attr_accessor :first_name, :last_name, :email, :cell
    attr_writer :id_number, :groups

    def initialize(id_number, first_name, last_name, email, cell, groups = [])
      @id_number  = id_number.to_i
      @first_name = first_name.to_s
      @last_name  = last_name.to_s
      @email      = email.to_s
      @cell       = cell.to_s
      @groups     = Array(groups)
    end

    def contact_type
      if groups.include? 'Employees'
        'Staff'
      elsif groups.include? 'Students'
        'Student'
      else
        'Other'
      end
    end

    def id_number
      @id_number.to_i
    end

    def groups
      Array(@groups).flatten
    end

    def attributes
      {id_number: id_number, first_name: first_name, last_name: last_name, email: email, cell: cell, groups: groups}
    end

    def csv_attributes
      {contact_type: contact_type, reference_code: id_number, first_name: first_name, last_name: last_name, email_address: email, group: groups}
    end

    # I'm preferring is? over eql? because I feel it better represents what we're checking.
    # Which is that they have the same id_numebr not that they are the same object or even
    # have the same attributes. But we're also using it for eql? for simple array comparisons.
    def is?(other)
      return false unless other.respond_to? :id_number

      other.id_number.to_i == id_number.to_i
    end
    alias :eql? :is?

    def hash
      id_number.to_i.hash
    end

    def ==(other)
      return false unless other.is_a? self.class

      other.id_number   == id_number &&
      other.first_name  == first_name &&
      other.last_name   == last_name &&
      other.email       == email &&
      other.cell        == cell &&
      other.groups.sort == groups.sort
    end

    # I'm not calling it "save!" because querying Oracle for contacts and then saving those contacts
    # would save them to MongoDB and not to Oracle like you'd expect.
    def store!
      db = EverbridgeSync::MongoDB.new

      db[:contacts].update({id_number: id_number}, attributes, upsert: true)
    end

    def delete!
      db = EverbridgeSync::MongoDB.new

      db[:contacts].remove id_number: id_number
    end

    def self.delete_all!
      db = EverbridgeSync::MongoDB.new

      db[:contacts].remove
    end

    def to_s
      "#{first_name} #{last_name}"
    end
  end
end
