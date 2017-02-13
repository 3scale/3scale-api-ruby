require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::AccountFeatures do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#read' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/features/42').and_return('feature' => {})
      expect(client.read(42)).to eq({})
    end
  end


  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/features').and_return('features' => [])
      expect(client.list).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/features', body: {
                                     name: 'test-feature',
                                     system_name: 'test-feature'
                                 })
                                 .and_return('feature' => {})
      expect(client.create('test-feature', 'test-feature')).to eq({})
    end
  end

  context '#update' do
    it do
      expect(http_client).to receive(:put)
                                 .with('/admin/api/features/42', body: {})
                                 .and_return('feature' => {})
      expect(client.update(42, {})).to eq({})
    end

  end
end
