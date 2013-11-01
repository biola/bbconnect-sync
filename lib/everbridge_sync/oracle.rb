require 'oci8'

module EverbridgeSync
  class Oracle
    def contacts
      Everbridge::ContactCollection.new.tap do |collection|
        cursor = connection.exec('SELECT * FROM bgv_everbridge')
        while row = cursor.fetch_hash
          id_number   = row['ID']
          first_name  = row['FNAME']
          last_name   = row['LNAME']
          email       = row['EMAIL']
          cell        = row['CELL']
          groups      = [] # TODO

          collection << Everbridge::Contact.new(id_number, first_name, last_name, email, cell, groups)
        end
      end
    end

    private

    def connection
      @connection ||= OCI8.new(Settings.oracle.connection_string)
    end
  end
end