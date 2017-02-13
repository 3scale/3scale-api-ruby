require 'securerandom'
require '3scale/api'


RSpec.describe 'Service API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:name) { SecureRandom.uuid }
  let(:rnd_num) { SecureRandom.random_number(1000000000) * 1.0 }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  before(:each) do
    @service = client.services.create({ name: name, system_name: name }) # placeholder until we have direct access to DB
  end

  after(:each) do

    if @service != nil
      begin
        client.services.delete(@service['id']) # placeholder until we have direct access to DB
      rescue ThreeScale::API::HttpClient::NotFoundError
      rescue ThreeScale::API::HttpClient::ForbiddenError

      end
    end

  end

  context '#service_crud' do
    it 'creates a service' do
      expect(@service).to include('name' => name)
    end

    it 'list an services' do
      expect(client.services.list.any? { |serv| serv['name'] == @service['name'] }).to be(true)
    end

    it 'read a service' do
      expect(client.services.read(@service['id'])).to include('name' => @service['name'])
    end

    it 'delete service' do
      client.services.delete(@service['id'])
      expect(client.services.list.any? { |serv| serv['name'] == @service['name'] }).to be(false)
      @service = nil
    end

  end
end
