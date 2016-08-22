require 'spec_helper'
include CSVHelpers
include ContactHelpers

describe BBConnect::CSV do
  let(:file_path) { '/tmp/bbconnect_sync_test.csv' }
  let(:csv) { BBConnect::CSV.new(file_path) }
  let(:row) { csv.rows.last }
  let(:flat_row) { csv.flattened_rows.last }
  subject { row }

  it { should be_nil }

  after { File.unlink file_path if File.exists? file_path }

  describe '#<<' do
    let(:groups) { ['Some Group', 'Other Group'] }
    before { csv << {reference_code: 1234567, group: groups} }
    subject { csv }

    it { expect(row['ReferenceCode']).to eql 1234567 }
    it { expect(row['Group']).to eql ['Some Group', 'Other Group'] }
    it { expect(flat_row[7]).to eql 'Some Group' }
    it { expect(flat_row[8]).to eql 'Other Group' }

    context 'without groups' do
      let(:groups) { [] }
      its(:flattened_columns) { should_not include 'Group' }
    end

    context 'without multiple groups' do
      let(:groups) { ['A', 'B', 'C'] }
      it { expect(csv.flattened_columns.select { |c| c == 'Group' }.length).to eql 3 }
    end
  end

  describe '#add' do
    before { csv.add first_name: 'John' }
    it { expect(row['Terminate']).to be_nil }
    it { expect(row['FirstName']).to eql 'John' }
  end

  describe '#update' do
    before { csv.update last_name: 'Doe' }
    it { expect(row['Terminate']).to be_nil }
    it { expect(row[3]).to eql 'Doe' }
  end

  describe '#remove' do
    before { csv.remove reference_code: 2345678 }
    it { expect(row['Terminate']).to_not be_empty }
    it { expect(row['ReferenceCode']).to eql 2345678 }
  end

  describe '#save!' do
    context 'with changes' do
      let(:csv_content) do
<<EOD
ContactType,ReferenceCode,FirstName,LastName,EmailAddress,SMSPhone,Terminate
Other,1234567,John,Doe,john.doe@example.com,5629036000,
EOD
      end

      before do
        # See ContactHelpers#new_contact for default attributes
        csv.add new_contact.csv_attributes
        csv.save!
      end

      it { expect(File.read(file_path)).to eql csv_content }
    end

    context 'without changes' do
      it { expect(csv.save!).to be_nil }
    end
  end
end
