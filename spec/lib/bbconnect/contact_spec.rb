require 'spec_helper'
include ContactHelpers

describe BBConnect::Contact do
  let(:id_number) { nil }
  let(:contact) { new_contact id_number: id_number }
  subject { contact }

  describe '#id_number' do
    before { contact.id_number = '0000042' }
    its(:id_number) { should eql 42 }
  end

  describe '#groups' do
    before { contact.groups = 'Some Group' }
    its(:groups) { should eql ['Some Group'] }
  end

  # See ContactHelpers#new_contact for default attributes
  its(:attributes) { should eql id_number: 1234567, first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', groups: [] }
  its(:csv_attributes) { should eql contact_type: 'Other', reference_code: 1234567, first_name: 'John', last_name: 'Doe', email_address: 'john.doe@example.com', group: [] }

  describe '#is?' do
    context 'when other is same contact' do
      let(:other) { new_contact id_number: '1234567' }
      it { expect(contact.is? other).to be_true }
    end

    context 'when other is a different contact' do
      let(:other) { new_contact id_number: '7654321' }
      it { expect(contact.is? other).to be_false }
    end
  end

  describe '#hash' do
    let(:id_number) { 42 }
    its(:hash) { should eql 42.hash }
  end

  describe '#==' do
    context 'when not a BBConnect::Contact' do
      let(:other) { Object.new }
      it { expect(contact == other).to be_false }
    end

    context 'when attributes are different' do
      let(:other) { new_contact first_name: 'Jonny' }
      it { expect(contact == other).to be_false }
    end

    context 'when attributes are the same' do
      let(:other) { new_contact }
      it { expect(contact == other).to be_true }
    end
  end

  describe '#store!' do
    let(:id_number) { rand(1..9999999) }
    before { contact.store! }

    it 'saves to the database' do
      expect(BBConnectSync::MongoDB.client { |db| db[:contacts].find(id_number: id_number).count }).to eql 1
    end

    after { delete_all_contacts! }
  end

  describe '#delete!' do
    let(:id_number) { rand(1..9999999) }
    before { contact.store! }

    it 'deletes from the database' do
      expect{contact.delete!}.to change{BBConnectSync::MongoDB.client { |db| db[:contacts].find(id_number: id_number).count }}.from(1).to 0
    end
  end

  its(:to_s) { should eql "John Doe"}
end
