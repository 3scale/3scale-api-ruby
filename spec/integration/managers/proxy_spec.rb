require 'securerandom'
require '3scale/api'

RSpec.describe 'Account Plan API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:name) { SecureRandom.uuid }
  let(:url) { "http://#{ name }.com:7" }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }
  let(:service) { client.create_service(name: name) }

  after(:each) do
    begin
      client.delete_service(service['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    end
  end

  context '#account_plans_crud' do
    it 'read a proxy' do
      expect(client.read_proxy(service['id'])).to include('service_id' => service['id'])
      expect(client.delete_service(service['id'])).to be(true)
      expect { client.read_proxy(service['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'update a proxy' do
      expect(client.update_proxy(service['id'], endpoint: url)).to include('endpoint' => url)
      expect(client.read_proxy(service['id'])).to include('endpoint' => url)
    end
  end
  end