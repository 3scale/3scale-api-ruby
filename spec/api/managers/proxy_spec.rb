require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::Proxy do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#show' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/proxy').and_return('proxy' => {})
      expect(client.read(42)).to eq({})
    end
  end

  context '#update' do
    it do
      expect(http_client).to receive(:patch)
                                 .with('/admin/api/services/42/proxy',
                                       body: { })
                                 .and_return('proxy' => {})
      expect(client.update(42, {})).to eq({})
    end
  end
end
