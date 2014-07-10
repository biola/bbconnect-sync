module BBConnectSync
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
      @stored_contacts ||= BBConnect::ContactCollection.all
    end

    def updated_contacts
      @updated_contacts ||= Oracle.new.contacts
    end

    def csv
      @csv ||= BBConnect::CSV.new(csv_file_path)
    end

    def comparer
      @comparer ||= BBConnect::ContactCollectionComparer.new(stored_contacts, updated_contacts)
    end

    def append_new_contacts_to_csv
      comparer.added.each do |contact|
        csv.add(contact.csv_attributes)
        contact.store!
      end
    end

    def append_updated_contacts_to_csv
      comparer.updated.each do |updated_contact|
        outdated_contact = @stored_contacts[updated_contact]

        # Blackboard Connect only considers IDs as unique within a ContactType
        # So if a person's type changes we need to delete their record under
        # the old type and create one with the new type
        if outdated_contact.type != updated_contact.type
          csv.remove outdated_contact.csv_attributes
          outdated_contact.delete!

          csv.add updated_contact.csv_attributes
          updated_contact.store!
        else
          old_groups = outdated_contact.groups - updated_contact.groups

          attributes = updated_contact.csv_attributes
          attributes.merge! del_group: old_groups

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

    def csv_file_path
      path      = Settings.csv.path
      prefix    = Settings.csv.filename_prefix
      timestamp = Time.now.to_i

      "#{path}/#{prefix}-#{timestamp}.csv"
    end
  end
end
