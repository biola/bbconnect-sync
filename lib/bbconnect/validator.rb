module BBConnect
  class Validator
    attr_accessor :contact

    def initialize(contact)
      @contact = contact
    end

    def valid?
      quacks_like_a_contact?
      cell_valid?
    end

    def self.valid?(contact)
      self.new(contact).valid?
    end

    private

    def quacks_like_a_contact?
      [:id_number, :first_name, :last_name, :email, :cell, :groups].all? do |attr|
        contact.respond_to? attr
      end
    end

    def cell_valid?
      contact.cell.to_s =~ /^\d{10}$/
    end
  end
end
