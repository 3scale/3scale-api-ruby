require 'securerandom'
require '3scale/api'

RSpec.describe 'Account Features API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:name) { SecureRandom.uuid }
  let(:rnd_string) { SecureRandom.hex(14) }
  let(:rnd_num) { SecureRandom.random_number(1000000000) * 1.0 }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  before(:each) do
    @account_feature = client.account_feature_create(name, name)
  end

  after(:each) do
    begin
      client.account_feature_delete(@account_feature['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    end
  end

  context '#account_feature_crud' do
    it 'create an account feature' do
      expect(@account_feature).to include('system_name' => name)
      expect(client.account_feature_create(name, name)).to include('errors' => {'system_name' => ["has already been taken"]})
      expect(client.account_feature_delete(@account_feature['id'])).to be(true)
      expect { client.account_feature_delete(@account_feature['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'list an account feature' do
      expect(client.account_feature_list.any? { |feature| feature['system_name'] == @account_feature['system_name'] }).to be(true)
      expect(client.account_feature_delete(@account_feature['id'])).to be(true)
      expect(client.account_feature_list.any? { |feature| feature['system_name'] == @account_feature['system_name'] }).to be(false)
    end

    it 'read an account feature' do
      expect(client.account_feature_read(@account_feature['id'])).to include('system_name' => @account_feature['system_name'])
      expect(client.account_feature_delete(@account_feature['id'])).to be(true)
      expect { client.account_feature_read(@account_feature['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'update an account feature' do
      puts rnd_string
      expect(client.account_feature_update(@account_feature['id'], name: rnd_string, system_name: rnd_string, id: rnd_num))
          .to include('name' => rnd_string, 'system_name' => rnd_string, 'id' => @account_feature['id'])

      expect(client.account_feature_read(@account_feature['id']))
          .to include('name' => rnd_string, 'system_name' => rnd_string, 'id' => @account_feature['id'])
    end

    it 'can\'t update system name to already exists one' do
      feature = client.account_feature_create(rnd_string, rnd_string)
      expect(client.account_feature_update(@account_feature['id'], system_name: rnd_string))
          .to include('errors' => {'system_name' => ["has already been taken"]})
      expect(client.account_feature_read(@account_feature['id'])).to include('system_name' => name)
      client.account_feature_delete(feature['id'])
    end

    it 'delete an account feature' do
      client.account_feature_delete(@account_feature['id'])
      expect { client.account_feature_read(@account_feature['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
      expect(client.account_feature_list.any? { |feature| feature['system_name'] == @account_feature['system_name'] }).to be(false)
    end
  end
end
