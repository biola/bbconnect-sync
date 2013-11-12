namespace :import do
  desc 'Export from Everbridge'
  task(:csv) do
    require 'csv'
    require './lib/everbridge_sync'
    require 'progress_bar'

    EverbridgeSync.initialize!

    raise ArgumentError, 'FILE_PATH is required.' if ENV['FILE_PATH'].nil?

    contacts = CSV.read(ENV['FILE_PATH'], { headers: true } )
    bar = ProgressBar.new(contacts.length)

    Everbridge::Contact.delete_all!

    contacts.each do |row|
      contact = Everbridge::Contact.new(row['External Id'], row['First Name'], row['Last Name'], row['E-mail Address'], row['Mobile Phone'], row['Member Of Group'].to_s.split('|'))
      contact.store!

      bar.increment!
    end
  end
end