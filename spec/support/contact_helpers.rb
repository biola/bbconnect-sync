module ContactHelpers
  def new_contact(attributes = {})
    id_number   = attributes[:id_number]  || 1234567
    first_name  = attributes[:first_name] || 'John'
    last_name   = attributes[:last_name]  || 'Doe'
    email       = attributes[:email]      || 'john.doe@example.com'
    cell        = attributes[:cell]       || '1231231234'
    groups      = attributes[:groups]     || []

    Everbridge::Contact.new id_number, first_name, last_name, email, cell, groups
  end

  def delete_all_contacts!
    EverbridgeSync::MongoDB.new[:contacts].remove()
  end
end