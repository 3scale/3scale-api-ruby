require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::Services do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#show' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42').and_return('service' => {})
      expect(client.read(42)).to eq({})
    end
  end

  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services').and_return('services' => [])
      expect(client.list).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services', body: { })
                                 .and_return('service' => {})
      expect(client.create({})).to eq({})
    end
  end
end
