require 'oci8'

module EverbridgeSync
  class Oracle
    def contacts
      Everbridge::ContactCollection.new.tap do |collection|
        # BGV_EVERBRIDGE returns multiple rows for a person who is a student and employee, so we are concatenating the two rows
        cursor = connection.exec("SELECT ID, FNAME, LNAME, CELL, EMAIL, listagg( AFFILIATION, '|' ) WITHIN GROUP( order by AFFILIATION ) AS AFFILIATIONS, HOUSING_1
                                  FROM BGV_EVERBRIDGE
                                  GROUP BY ID, FNAME, LNAME, CELL, EMAIL, HOUSING_1")
        while row = cursor.fetch_hash
          id_number   = row['ID']
          first_name  = row['FNAME']
          last_name   = row['LNAME']
          email       = row['EMAIL']
          cell        = row['CELL']
          groups      = GroupRules.new(affiliation: row['AFFILIATIONS'].to_s.split('|'), housing: row['HOUSING_1']).results

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