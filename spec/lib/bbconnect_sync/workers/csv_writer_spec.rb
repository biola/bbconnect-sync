require 'spec_helper'

describe BBConnectSync::Worker::CSVWriter do
  before { Settings.stub_chain(:worker, :enabled).and_return(enabled) }

  context 'when enabled' do
    let(:enabled) { true }

    it 'should run' do
      BBConnectSync::Synchronizer.any_instance.should_receive(:sync!)
      subject.perform
    end
  end

  context 'when not enabled' do
    let(:enabled) { false }

    it 'should not run' do
      BBConnectSync::Synchronizer.any_instance.should_not_receive(:sync!)
      subject.perform
    end
  end
end
