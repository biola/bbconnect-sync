require 'spec_helper'

describe BBConnectSync::Email::InvalidCell do
  let(:email) { BBConnectSync::Email::InvalidCell.new(new_contact) }

  before do
    Mail.defaults do
      delivery_method :test
    end
    BBConnectSync::MongoDB.new[:email_log].remove()
  end

  it 'sends an email' do
    expect { email.send! }.to change { Mail::TestMailer.deliveries.length}.by 1
  end

  it 'only sends one email' do
    expect { email.send! }.to change { Mail::TestMailer.deliveries.length}.by 1
    expect { email.send! }.to_not change { Mail::TestMailer.deliveries.length}
  end
end
