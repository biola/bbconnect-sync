require 'spec_helper'

describe BBConnectSync::GroupRules do
  let(:attributes) { {} }
  let(:group_rules) { BBConnectSync::GroupRules.new(attributes, file: 'spec/fixtures/group_rules.rb') }
  subject { group_rules.results }

  context 'with Employee affiliation and no housing' do
    let(:attributes) { {affiliation: 'Employee', housing: nil} }
    it { should eql ['Employees'] }
  end

  context 'with Student affiliation and Alpha East housing' do
    let(:attributes) { {affiliation: 'Student', housing: 'Alpha East'} }
    it { should eql ['Students', 'Students - on campus'] }
  end

  context 'with Student affiliation and no housing' do
    let(:attributes) { {affiliation: 'Student', housing: nil} }
    it { should eql ['Students', 'Students - off campus'] }
  end

  context 'with Employee and Student affiliation and no housing' do
    let(:attributes) { {affiliation: ['Employee', 'Student'], housing: nil} }
    it { should eql ['Employees', 'Students', 'Students - off campus'] }
  end
end
