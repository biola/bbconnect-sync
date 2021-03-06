require 'spec_helper'
include ContactHelpers

describe BBConnectSync::Synchronizer do
  let(:old_guy)                 { new_contact(id_number: 1) }
  let(:unchanged_guy)           { new_contact(id_number: 2) }
  let(:changed_guy_before)      { new_contact(id_number: 3, first_name: 'Billy', groups: ['Students', 'Students - off campus']) }
  let(:changed_guy_after)       { new_contact(id_number: 3, first_name: 'William', groups: ['Students', 'Students - on campus']) }
  let(:type_changed_guy_before) { new_contact(id_number: 4, groups: ['Students']) }
  let(:type_changed_guy_after)  { new_contact(id_number: 4, groups: ['Employees']) }
  let(:new_guy)                 { new_contact(id_number: 5, groups: ['Employees']) }

  let(:stored_contacts) { BBConnect::ContactCollection.new([old_guy, unchanged_guy, changed_guy_before, type_changed_guy_before]) }
  let(:updated_contacts) { BBConnect::ContactCollection.new([type_changed_guy_after, unchanged_guy, changed_guy_after, new_guy]) }

  let(:synchronizer) { BBConnectSync::Synchronizer.new }
  subject { synchronizer }

  before(:each) do
    BBConnect::ContactCollection.stub(:all).and_return(stored_contacts)
    BBConnectSync::Oracle.any_instance.stub(:contacts).and_return(updated_contacts)
  end

  describe '#sync!' do
    let(:file_path) { '/tmp/bbconnect_sync_test.csv' }
    let(:csv_content) do
<<EOD
ContactType,ReferenceCode,FirstName,LastName,EmailAddress,SMSPhone,Terminate,Group,Group,DelGrp
Staff,5,John,Doe,john.doe@example.com,5629036000,,Employees,,
Student,4,John,Doe,john.doe@example.com,5629036000,0,Students,,
Staff,4,John,Doe,john.doe@example.com,5629036000,,Employees,,
Student,3,William,Doe,john.doe@example.com,5629036000,,Students,Students - on campus,Students - off campus
Other,1,John,Doe,john.doe@example.com,5629036000,0,,,
EOD
    end

    before { synchronizer.stub(:csv_file_path).and_return file_path }

    let!(:result) { synchronizer.sync! }

    it { expect(result).to be_true }
    it { expect(File.read(file_path)).to eql csv_content }

    after { File.unlink file_path }
  end
end
