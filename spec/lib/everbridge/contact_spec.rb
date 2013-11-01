require 'spec_helper'
include ContactHelpers

describe Everbridge::Contact do
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
  its(:attributes) { should eql id_number: 1234567, first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', cell: '1231231234', groups: [] }
  its(:csv_attributes) { should eql external_id: 1234567, first_name: 'John', last_name: 'Doe', email_address: 'john.doe@example.com', mobile_phone: '1231231234', groups: [] }

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

  describe '#==' do
    context 'when not an Everbridge::Contact' do
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
      expect(EverbridgeSync::MongoDB.new[:contacts].find(id_number: id_number).count).to eql 1
    end

    after { delete_all_contacts! }
  end

  its(:to_s) { should eql "John Doe"}
end