require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::Applications do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#find' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/applications/find',
                                                params: { application_id: 42 }
      ).and_return('application' => {})
      expect(client.find(id: 42)).to eq({})
    end
  end

  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/applications', params: nil).and_return('applications' => [])
      expect(client.list).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/accounts/42/applications', body: {plan_id: 43})
                                 .and_return('application' => {})
      expect(client.create(42, plan_id: 43)).to eq({})
    end
  end

  context '#key_create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/accounts/42/applications/43/keys', body: {
                                     key: 100,
                                     account_id: 42,
                                     application_id: 43
                                 })
                                 .and_return('key' => {})
      expect(client.key_create(42, 43, 100)).to eq({})
    end
  end

  context '#keys_list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/accounts/42/applications/43/keys').and_return('keys' => [])
      expect(client.keys_list(42, 43)).to eq([])
    end
  end
end
