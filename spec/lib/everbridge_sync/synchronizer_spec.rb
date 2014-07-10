require 'spec_helper'
include ContactHelpers

describe EverbridgeSync::Synchronizer do
  let(:old_guy)             { new_contact(id_number: 1) }
  let(:unchanged_guy)       { new_contact(id_number: 2) }
  let(:changed_guy_before)  { new_contact(id_number: 3, first_name: 'Billy', groups: ['Students', 'Students - off campus']) }
  let(:changed_guy_after)   { new_contact(id_number: 3, first_name: 'William', groups: ['Students', 'Students - on campus']) }
  let(:new_guy)             { new_contact(id_number: 4, groups: ["Employees"]) }

  let(:stored_contacts) { Everbridge::ContactCollection.new([old_guy, unchanged_guy, changed_guy_before]) }
  let(:updated_contacts) { Everbridge::ContactCollection.new([unchanged_guy, changed_guy_after, new_guy]) }

  let(:synchronizer) { EverbridgeSync::Synchronizer.new }
  subject { synchronizer }

  before(:each) do
    Everbridge::ContactCollection.stub(:all).and_return(stored_contacts)
    EverbridgeSync::Oracle.any_instance.stub(:contacts).and_return(updated_contacts)
  end

  describe '#sync!' do
    let(:file_path) { '/tmp/everbridge_sync_test.csv' }
    let(:csv_content) do
<<EOD
ContactType,ReferenceCode,FirstName,LastName,EmailAddress,Terminate,Group,Group,DelGrp
Staff,4,John,Doe,john.doe@example.com,,Employees,,
Student,3,William,Doe,john.doe@example.com,,Students,Students - on campus,Students - off campus
Other,1,John,Doe,john.doe@example.com,0,,,
EOD
    end

    before { synchronizer.stub(:csv_file_paths).and_return [file_path] }

    let!(:result) { synchronizer.sync! }

    it { expect(result).to be_true }
    it { expect(File.read(file_path)).to eql csv_content }

    after { File.unlink file_path }
  end
end
