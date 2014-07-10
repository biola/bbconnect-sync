namespace :import do
  desc 'Export from Blackboard Connect'
  task(:csv) do
    require 'csv'
    require './lib/bbconnect_sync'
    require 'progress_bar'

    BBConnectSync.initialize!

    raise ArgumentError, 'FILE_PATH is required.' if ENV['FILE_PATH'].nil?

    contacts = CSV.read(ENV['FILE_PATH'], { headers: true } )
    bar = ProgressBar.new(contacts.length)

    BBConnect::Contact.delete_all!

    contacts.each do |row|
      contact = BBConnect::Contact.new(row['External Id'], row['First Name'], row['Last Name'], row['E-mail Address'], row['Mobile Phone'], row['Member Of Group'].to_s.split('|'))
      contact.store!

      bar.increment!
    end
  end
end
