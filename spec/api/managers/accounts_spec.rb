require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::Accounts do

  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#signup' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/signup', body: { org_name: 'foo',
                                                                    username: 'foobar',
                                                                    email: 'foo@example.com',
                                                                    password: 'pass',
                                                                    'billing_address_country' => 'Spain',
                                                                    billing_address_city: 'Barcelona' })
                                 .and_return('account' => { 'id' => 42 })
      expect(client.sign_up(name: 'foo', username: 'foobar', password: 'pass',
                            billing_address_city: 'Barcelona', email: 'foo@example.com',
                            'billing_address_country' => 'Spain'))
          .to eq('id' => 42)
    end
  end

  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/accounts', params: nil).and_return('accounts' => [])
      expect(client.list).to eq([])
    end
  end

  context '#show' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/accounts/42').and_return('account' => {})
      expect(client.read(42)).to eq({})
    end
  end

  context '#show_provider' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/provider').and_return('account' => {})
      expect(client.show_provider).to eq({})
    end
  end

  context '#update' do
    it do
      expect(http_client).to receive(:put)
                                 .with('/admin/api/accounts/42', body: { })
                                 .and_return('account' => { id: 42 })
      expect(client.update(42, {})).to eq({ id: 42 })
    end
  end
end
