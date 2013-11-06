require 'spec_helper'

describe EverbridgeSync::Email::InvalidCell do
  let(:email) { EverbridgeSync::Email::InvalidCell.new(new_contact) }

  before do
    Mail.defaults do
      delivery_method :test
    end
  end

  it 'sends an email' do
    expect { email.send! }.to change { Mail::TestMailer.deliveries.length}.from(0).to 1
  end
end