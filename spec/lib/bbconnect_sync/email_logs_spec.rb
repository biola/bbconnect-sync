require 'spec_helper'
include BBConnectSync

describe EmailLog do
  let(:contact) { BBConnect::Contact.new(1, "Luke", "Skywalker", "a@a.a", "1231231234") }
  let(:email) { Email::InvalidCell.new(contact) }
  let(:db) { MongoDB.new() }

  before do
    db[:email_log].remove()
  end

  describe ".log" do
    it{ expect{ EmailLog.log(email) }.to change{ db[:email_log].count }.from(0).to(1) }
  end

  describe ".last" do
    before { EmailLog.log(email) }
    it { expect( EmailLog.last(:invalid_cell, "a@a.a") ).to_not be_nil }
  end

  describe ".last_email_at" do
    before { EmailLog.log(email) }
    it { expect( EmailLog.last_email_at(:invalid_cell, "a@a.a").class ).to eql Time }
  end
end
