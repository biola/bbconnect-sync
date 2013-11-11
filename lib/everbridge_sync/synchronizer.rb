module EverbridgeSync
  class Synchronizer

    def initialize
      @stored_contacts = Everbridge::ContactCollection.all
      @updated_contacts = Oracle.new.contacts
      @csv = Everbridge::CSV.new
      @comparer = Everbridge::ContactCollectionComparer.new(stored_contacts, updated_contacts)
    end

    def sync!
      append_new_contacts_to_csv!
      append_updated_contacts_to_csv!
      append_removed_contacts_to_csv!
      csv.save!(csv_file_path)
      updated_contacts.each(&:store!)
    end

    private

    attr_accessor :stored_contacts, :updated_contacts, :csv, :comparer

    def append_new_contacts_to_csv!
      comparer.added.each do |contact|
        csv.add(contact.csv_attributes) if valid? contact
      end
    end

    def append_updated_contacts_to_csv!
      comparer.updated.each do |updated_contact|
        if valid? updated_contact
          outdated_contact = @stored_contacts[updated_contact]
          old_groups = outdated_contact.groups - updated_contact.groups

          attributes = updated_contact.csv_attributes
          attributes.merge! remove_groups: old_groups

          csv.update attributes
        end
      end
    end

    def append_removed_contacts_to_csv!
      comparer.removed.each do |contact|
        csv.remove contact.csv_attributes
      end
    end

    def csv_file_path
      path      = Settings.csv.path
      prefix    = Settings.csv.filename_prefix
      timestamp = Time.now.to_i

      "#{path}/#{prefix}-#{timestamp}.csv"
    end

    def valid?(contact)
      if Everbridge::Validator.valid? contact
        true
      else
        Email::InvalidCell.new(contact).send!

        false
      end
    end
  end
end