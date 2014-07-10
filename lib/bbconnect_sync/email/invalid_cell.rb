module BBConnectSync
  module Email
    class InvalidCell < Base
      def initialize(contact)
        super :invalid_cell, contact
      end
    end
  end
end
