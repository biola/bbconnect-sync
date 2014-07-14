require 'spec_helper'

describe BBConnectSync::Worker::CSVUploader do
  let(:url) { 'https://www.blackboardconnected.com/contacts/importer_portal.asp?qDest=imp' }
  let(:file_path) { '/dev/null' }
  let(:status) { 200 }
  let(:body) { 'Your data has been received' }
  before { stub_request(:post, url).to_return(status: status, body: body) }

  context 'with a successful response' do
    it { expect { subject.perform(file_path) }.to_not raise_error }
  end

  context 'with an unsuccessful response code' do
    let(:status) { 500 }
    it { expect { subject.perform(file_path) }.to raise_error(BBConnectSync::Worker::UploadError) }
  end

  context 'with an unsuccessful body' do
    let(:body) { 'NO SOUP FOR YOU!' }
    it { expect { subject.perform(file_path) }.to raise_error(BBConnectSync::Worker::UploadError) }
  end

  it 'should have user agent of "Autoscript (curl)"' do
    subject.perform file_path
    a_request(:post, url).with(headers: {'User-Agent' => 'Autoscript (curl)'}).should have_been_made.once
  end
end
