require 'spec_helper'
include ContactHelpers

describe Everbridge::ContactCollectionComparer do
  let(:old_guy)             { new_contact(id_number: 1) }
  let(:unchanged_guy)       { new_contact(id_number: 2) }
  let(:changed_guy_before)  { new_contact(id_number: 3, first_name: 'Billy') }
  let(:changed_guy_after)   { new_contact(id_number: 3, first_name: 'William') }
  let(:new_guy)             { new_contact(id_number: 4) }
  let(:old_collection)      { Everbridge::ContactCollection.new }
  let(:new_collection)      { Everbridge::ContactCollection.new }
  let(:comparer)            { Everbridge::ContactCollectionComparer.new(old_collection, new_collection) }

  before do
    old_collection << old_guy
    old_collection << unchanged_guy
    old_collection << changed_guy_before

    new_collection << unchanged_guy
    new_collection << changed_guy_after
    new_collection << new_guy
  end

  subject { comparer }

  describe '#added' do
    its(:added) { should eql [new_guy] }
  end

  describe '#updated' do
    its(:updated) { should eql [changed_guy_after] }
  end

  describe '#removed' do
    its(:removed) { should eql [old_guy] }
  end
end