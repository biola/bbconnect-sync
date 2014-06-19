require 'spec_helper'

describe EverbridgeSync::Worker do
  before { Settings.stub_chain(:worker, :enabled).and_return(enabled) }

  context 'when enabled' do
    let(:enabled) { true }

    it 'should run' do
      EverbridgeSync::Synchronizer.any_instance.should_receive(:sync!)
      subject.perform
    end
  end

  context 'when not enabled' do
    let(:enabled) { false }

    it 'should not run' do
      EverbridgeSync::Synchronizer.any_instance.should_not_receive(:sync!)
      subject.perform
    end
  end
end