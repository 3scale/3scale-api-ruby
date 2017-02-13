require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::Mappings do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#show' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/proxy/mapping_rules/43').and_return('mapping_rule' => {})
      expect(client.read(42, 43)).to eq({})
    end
  end

  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/proxy/mapping_rules').and_return('mapping_rules' => [])
      expect(client.list(42)).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/proxy/mapping_rules',
                                       body: {})
                                 .and_return('mapping_rule' => {})
      expect(client.create(42, {})).to eq({})
    end
  end

  context '#update' do
    it do
      expect(http_client).to receive(:patch)
                                 .with('/admin/api/services/42/proxy/mapping_rules/43',
                                       body: { mapping_rule: {} })
                                 .and_return('mapping_rule' => {})
      expect(client.update(42, 43, {})).to eq({})
    end
  end
end
