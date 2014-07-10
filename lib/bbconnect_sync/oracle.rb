require 'oci8'

module BBConnectSync
  class Oracle
    def contacts
      BBConnect::ContactCollection.new.tap do |collection|
        # BGV_BBCONNECT returns multiple rows for a person who is a student and employee, so we are concatenating the two rows
        cursor = connection.exec("SELECT ID, PNAME, LNAME, CELL, EMAIL, listagg( AFFILIATION, '|' ) WITHIN GROUP( order by AFFILIATION ) AS AFFILIATIONS, HOUSING_1
                                  FROM BGV_BBCONNECT
                                  GROUP BY ID, PNAME, LNAME, CELL, EMAIL, HOUSING_1")
        while row = cursor.fetch_hash
          id_number   = row['ID']
          first_name  = row['PNAME']
          last_name   = row['LNAME']
          email       = row['EMAIL']
          cell        = row['CELL']
          groups      = GroupRules.new(affiliation: row['AFFILIATIONS'].to_s.split('|'), housing: row['HOUSING_1']).results

          collection << BBConnect::Contact.new(id_number, first_name, last_name, email, cell, groups)
        end
      end
    end

    private

    def connection
      @connection ||= OCI8.new(Settings.oracle.connection_string)
    end
  end
end
