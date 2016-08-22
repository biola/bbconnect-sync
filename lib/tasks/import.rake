namespace :import do
  desc 'Export from Blackboard Connect'
  task(:csv) do
    require 'csv'
    require './lib/bbconnect_sync'

    BBConnectSync.initialize!

    raise ArgumentError, 'FILE_PATH is required.' if ENV['FILE_PATH'].nil?

    contacts = CSV.read(ENV['FILE_PATH'], { headers: true } )
    synced_groups = BBConnectSync::GroupRules.all_groups
    bar = ProgressBar.new(contacts.length)

    BBConnect::Contact.delete_all!

    contacts.each do |row|
      id_number = row['REFERENCECODE']
      first_name = row['FIRSTNAME']
      last_name = row['LASTNAME']
      email = row['EMAILADDRESS']
      cell = row['SMSPHONE']
      groups = row.map { |col, val| val if col == 'GROUP' }.compact & synced_groups

      contact = BBConnect::Contact.new(id_number, first_name, last_name, email, cell, groups)
      contact.store!

      bar.increment!
    end
  end
end
