require 'spec_helper'
require 'ostruct'
include ContactHelpers

describe BBConnect::Validator do
  let(:contact_attributees) { {} }
  let(:contact) { new_contact(contact_attributes) }
  let(:validator) { BBConnect::Validator.new contact }
  subject { validator.valid? }

  context 'invalid object' do
    let(:contact) { OpenStruct.new(id_number: nil, first_name: nil, last_name: nil, email: nil, cell: nil) } # no group
    it { should be_false }
  end

  context 'invalid cell' do
    let(:contact_attributes) { {cell: 1234567} }
    it { should be_false }
  end

  context 'valid contact' do
    let(:contact_attributes) { {cell: 1234567890} }
    it { should be_true }
  end
end
