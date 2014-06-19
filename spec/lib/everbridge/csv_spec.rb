require 'spec_helper'
include CSVHelpers

describe Everbridge::CSV do
  let(:file_path) { '/tmp/everbridge_sync_test.csv' }
  let(:csv) { Everbridge::CSV.new(file_path) }
  let(:row) { csv.rows.last }
  subject { row }

  it { should be_nil }

  after { File.unlink file_path if File.exists? file_path }

  describe '#<<' do
    before { csv << {external_id: 1234567, groups: ['Some Group', 'Other Group']} }
    it { expect(row[15]).to eql 1234567 }
    it { expect(row[106]).to eql 'Some Group|Other Group' }
    its(:last) { should eql 'END' }
  end

  describe '#add' do
    before { csv.add first_name: 'John' }
    it { expect(row[0]).to eql 'A' }
    it { expect(row[1]).to eql 'John' }
  end

  describe '#update' do
    before { csv.update last_name: 'Doe' }
    it { expect(row[0]).to eql 'U' }
    it { expect(row[3]).to eql 'Doe' }
  end

  describe '#remove' do
    before { csv.remove mobile_phone: '0420420042' }
    it { expect(row[0]).to eql 'D' }
    it { expect(row[53]).to eql '0420420042' }
  end

  describe '#save!' do
    let(:csv_content) do
<<EOD
Action,First Name,Middle Init.,Last Name,Suffix,Organization,Address,Address 2,Address 3,City,State/Province,Postal Code,Country,Role,Language,External Id,Account Code,Member Pin Number,Assistant Phone,Assistant Phone Country,Assistants Phone Ext,Business Phone,Business Phone 2,Business Phone 2 Country,Business Phone 3,Business Phone 3 Country,Business Phone 4,Business Phone 4 Country,Business Phone Country,Business Phone Ext,Business Phone Ext 2,Business Phone Ext 3,Business Phone Ext 4,E-mail Address,E-mail Address 2,E-mail Address 3,Fax 1,Fax 1 Country,Fax 2,Fax 2 Country,Fax 3,Fax 3 Country,Home Phone,Home Phone 2,Home Phone 2 Country,Home Phone Country,IM System,Instant Messaging,International Phone 1,International Phone 2,International Phone 3,International Phone 4,International Phone 5,Mobile Phone,Mobile Phone 2,Mobile Phone 2 Country,Mobile Phone 2 Provider,Mobile Phone 3,Mobile Phone 3 Country,Mobile Phone 3 Provider,Mobile Phone Country,Mobile Phone Provider,Numeric Pager,One Way Pager Limited,One Way Pager Unlimited,Oneway SMS Device,Oneway SMS Device Country,Other Phone,Other Phone Country,Pager Pin #,SMS Device 1,SMS Device 1 Country,SMS Device 2,SMS Device 2 Country,Tap,Tap Country,Text Device Limited,Text Device Unlimited,TTY/TDD 1,TTY/TDD 1 Country Calling Code,TTY/TDD 2,TTY/TDD 2 Country Calling Code,TTY/TDD 3,TTY/TDD 3 Country Calling Code,Numeric Pager Country,TAP Pager PIN,Escalate First Name 1,Escalate Middle Init 1,Escalate Last Name 1,Escalate Suffix 1,Escalate First Name 2,Escalate Middle Init 2,Escalate Last Name 2,Escalate Suffix 2,Escalate First Name 3,Escalate Middle Init 3,Escalate Last Name 3,Escalate Suffix 3,Member of Group 1,Member of Group 2,Member of Group 3,Leader of Group 1,Leader of Group 2,Leader of Group 3,Contract Number,Contract Plan Name,Groups,Leaders,Remove Groups,Remove Group Leaders,User Attribute Field Name 1,User Attribute Value 1,User Attribute Field Name 2,User Attribute Value 2,User Attribute Field Name 3,User Attribute Value 3,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,User Attribute Field Name,User Attribute Value,END
A,John,,Doe,,Biola University,,,,,,,United States,Contact,English (US),1234567,,,,,,,,,,,,,,,,,,john.doe@example.com,,,,,,,,,,,,,,,,,,,,1231231234,,,,,,,,,,,,,,,,,1231231234,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"",,,,,,,,,,,,,,,,,,,,,,,,END
EOD
    end

    before do
      # See ContactHelpers#new_contact for default attributes
      csv.add new_contact.csv_attributes
    end

    it { expect(File.read(file_path)).to eql csv_content }
  end
end