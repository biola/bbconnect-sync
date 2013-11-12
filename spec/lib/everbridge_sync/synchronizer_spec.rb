require 'spec_helper'
include ContactHelpers

describe EverbridgeSync::Synchronizer do
  let(:old_guy)             { new_contact(id_number: 1) }
  let(:unchanged_guy)       { new_contact(id_number: 2) }
  let(:changed_guy_before)  { new_contact(id_number: 3, first_name: 'Billy') }
  let(:changed_guy_after)   { new_contact(id_number: 3, first_name: 'William') }
  let(:new_guy)             { new_contact(id_number: 4) }

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
Action,First Name,Middle Init.,Last Name,Suffix,Organization,Address,Address 2,Address 3,City,State/Province,Postal Code,Country,Role,Language,External Id,Account Code,Member Pin Number,Assistant Phone,Assistant Phone Country,Assistants Phone Ext,Business Phone,Business Phone 2,Business Phone 2 Country,Business Phone 3,Business Phone 3 Country,Business Phone 4,Business Phone 4 Country,Business Phone Country,Business Phone Ext,Business Phone Ext 2,Business Phone Ext 3,Business Phone Ext 4,E-mail Address,E-mail Address 2,E-mail Address 3,Fax 1,Fax 1 Country,Fax 2,Fax 2 Country,Fax 3,Fax 3 Country,Home Phone,Home Phone 2,Home Phone 2 Country,Home Phone Country,IM System,Instant Messaging,International Phone 1,International Phone 2,International Phone 3,International Phone 4,International Phone 5,Mobile Phone,Mobile Phone 2,Mobile Phone 2 Country,Mobile Phone 2 Provider,Mobile Phone 3,Mobile Phone 3 Country,Mobile Phone 3 Provider,Mobile Phone Country,Mobile Phone Provider,Numeric Pager,One Way Pager Limited,One Way Pager Unlimited,Oneway SMS Device,Oneway SMS Device Country,Other Phone,Other Phone Country,Pager Pin #,SMS Device 1,SMS Device 1 Country,SMS Device 2,SMS Device 2 Country,Tap,Tap Country,Text Device Limited,Text Device Unlimited,TTY/TDD 1,TTY/TDD 1 Country Calling Code,TTY/TDD 2,TTY/TDD 2 Country Calling Code,TTY/TDD 3,TTY/TDD 3 Country Calling Code,Numeric Pager Country,TAP Pager PIN,Escalate First Name 1,Escalate Middle Init 1,Escalate Last Name 1,Escalate Suffix 1,Escalate First Name 2,Escalate Middle Init 2,Escalate Last Name 2,Escalate Suffix 2,Escalate First Name 3,Escalate Middle Init 3,Escalate Last Name 3,Escalate Suffix 3,Member of Group 1,Member of Group 2,Member of Group 3,Leader of Group 1,Leader of Group 2,Leader of Group 3,Contract Number,Contract Plan Name,Groups,Leaders,Remove Groups,Remove Group Leaders,User Attribute Field Name 1,User Attribute Value 1,User Attribute Field Name 2,User Attribute Value 2,User Attribute Field Name 3,User Attribute Value 3,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,END
A,John,,Doe,,Biola University,,,,,,,United States,Contact,English (US),4,,,,,,,,,,,,,,,,,,john.doe@example.com,,,,,,,,,,,,,,,,,,,,1231231234,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"",,,,,,,,,,,,,,,,,,,,,,,,END
U,William,,Doe,,Biola University,,,,,,,United States,Contact,English (US),3,,,,,,,,,,,,,,,,,,john.doe@example.com,,,,,,,,,,,,,,,,,,,,1231231234,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"",,"",,,,,,,,,,,,,,,,,,,,,,END
D,John,,Doe,,Biola University,,,,,,,United States,Contact,English (US),1,,,,,,,,,,,,,,,,,,john.doe@example.com,,,,,,,,,,,,,,,,,,,,1231231234,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"",,,,,,,,,,,,,,,,,,,,,,,,END
EOD
    end

    before { synchronizer.stub(:csv_file_path).and_return file_path }

    let!(:result) { synchronizer.sync! }

    it { expect(result).to be_true }
    it { expect(File.read(file_path)).to eql csv_content }

    after { File.unlink file_path }
  end
end