require 'spec_helper'
include ContactHelpers

describe BBConnect::ContactCollection do
  let(:contact) { new_contact }
  let(:other_contact) { BBConnect::Contact.new(7654321, 'Jane', 'Doe', 'jane.doe@example.com', '3213214321') }
  let(:modified_contact) { contact.dup.tap { |c| c.first_name = 'Jonny' } }

  describe '#<<' do
    it 'adds contacts' do
      expect { subject << contact }.to change{ subject.contacts.length }.from(0).to 1
    end
  end

  describe '#[]' do
    before { subject << contact }

    context 'with some invalid object' do
      it { expect(subject[Object.new]).to be_nil }
    end

    context 'with different id_numbers' do
      it { expect(subject[other_contact]).to be_nil }
    end

    context 'with same contact but modified attributes' do
      it { expect(subject[modified_contact]).to eql contact }
    end

    context 'with matching contact' do
      it { expect(subject[contact]).to eql contact }
    end
  end

  describe '#includes?' do
    before { subject << contact }

    context 'with some invalid object' do
      it { expect(subject.includes? Object.new).to be_false }
    end

    context 'with different id_numbers' do
      it { expect(subject.includes? other_contact).to be_false }
    end

    context 'with same contact but modified attributes' do
      it { expect(subject.includes? modified_contact).to be_true }
    end

    context 'with matching contact' do
      it { expect(subject.includes? contact).to be_true }
    end
  end

  describe '#-' do
    let(:other_collection) { BBConnect::ContactCollection.new }

    before do
      subject << contact
      subject << other_contact
      other_collection << contact
    end

    it { expect(subject - other_collection).to eql [other_contact] }
  end

  describe '.all' do
    let(:contact_a) { new_contact id_number: 1 }
    let(:contact_b) { new_contact id_number: 2 }
    let(:contact_c) { new_contact id_number: 3 }
    let(:collection) { BBConnect::ContactCollection.all }

    before do
      contact_a.store!
      contact_b.store!
      contact_c.store!
    end

    it 'contains all contacts' do
      expect(collection.includes? contact_a).to be_true
      expect(collection.includes? contact_b).to be_true
      expect(collection.includes? contact_c).to be_true
    end

    after { delete_all_contacts! }
  end
end
