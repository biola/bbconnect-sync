module EverbridgeSync
  class Synchronizer

    def initialize
    end

    def sync!
      append_new_contacts_to_csv
      append_updated_contacts_to_csv
      append_removed_contacts_to_csv
      csv.save!
    end

    private

    def stored_contacts
      @stored_contacts ||= Everbridge::ContactCollection.all
    end

    def updated_contacts
      @updated_contacts ||= Oracle.new.contacts
    end

    def csv
      @csv ||= Everbridge::CSV.new(csv_file_paths)
    end

    def comparer
      @comparer ||= Everbridge::ContactCollectionComparer.new(stored_contacts, updated_contacts)
    end

    def append_new_contacts_to_csv
      comparer.added.each do |contact|
        if valid? contact
          csv.add(contact.csv_attributes)
          contact.store!
        end
      end
    end

    def append_updated_contacts_to_csv
      comparer.updated.each do |updated_contact|
        if valid? updated_contact
          outdated_contact = @stored_contacts[updated_contact]
          old_groups = outdated_contact.groups - updated_contact.groups

          attributes = updated_contact.csv_attributes
          attributes.merge! remove_groups: old_groups

          csv.update attributes
          updated_contact.store!
        end
      end
    end

    def append_removed_contacts_to_csv
      comparer.removed.each do |contact|
        csv.remove contact.csv_attributes
        contact.delete!
      end
    end

    def csv_file_paths
      paths     = Settings.csv.paths
      prefix    = Settings.csv.filename_prefix
      timestamp = Time.now.to_i

      paths.map do |path|
        "#{path}/#{prefix}-#{timestamp}.csv"
      end
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
