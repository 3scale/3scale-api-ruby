require 'securerandom'
require '3scale/api'


RSpec.describe 'Service Plan API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id) { ENV.fetch('SERVICE_ID') }
  let(:name) { SecureRandom.uuid }
  let(:rnd_num) { SecureRandom.random_number(1000000000) * 1.0 }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  before(:each) do
    @service_plan = client.service_plan.create(service_id, name) # placeholder until we have direct access to DB
  end

  after(:each) do
    if @service_plan != nil
      begin
        client.service_plan.delete(service_id, @service_plan['id']) # placeholder until we have direct access to DB
      rescue ThreeScale::API::HttpClient::NotFoundError
      rescue ThreeScale::API::HttpClient::ForbiddenError
      end
    end

  end

  context '#service_plans_crud' do
    it 'list an service plans' do
      expect(client.service_plan.list.any? { |plan| plan['name'] == @service_plan['name'] }).to be(true)
      expect(client.service_plan.list_for_service(service_id).any? { |plan| plan['name'] == @service_plan['name'] }).to be(true)
    end

    it 'read an service plan' do
      expect(client.service_plan.read(service_id, @service_plan['id'])).to include('name' => @service_plan['name'])
    end

    it 'deletes service plan' do
      client.service_plan.delete(service_id, @service_plan['id'])
      expect(client.service_plan.list.any? { |plan| plan['name'] == @service_plan['name'] }).to be(false)
    end

    it 'sets service plan as default' do
      expect(client.service_plan.set_default(service_id, @service_plan['id'])).to include('name' => @service_plan['name'])
      expect(client.service_plan.get_default(service_id)).to include('id' => @service_plan['id'])
      client.service_plan.set_default(service_id, client.service_plan.get_by_name(service_id, 'Default')['id'])
    end

    it 'gets correctly by name' do
      expect(client.service_plan.get_by_name(service_id, 'Default')).to include('default' => true)
    end


  end
end
