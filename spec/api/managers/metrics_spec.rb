require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::Metrics do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#show' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/metrics/43').and_return('metric' => {})
      expect(client.read(42, 43)).to eq({})
    end
  end

  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/metrics').and_return('metrics' => [])
      expect(client.list(42)).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/metrics',
                                       body: {})
                                 .and_return('metric' => {})
      expect(client.create(42, {})).to eq({})
    end
  end
end
