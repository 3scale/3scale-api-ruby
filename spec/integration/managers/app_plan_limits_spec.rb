require 'securerandom'
require '3scale/api'

RSpec.describe 'Application plan limits API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id) { ENV.fetch('SERVICE_ID').to_i }
  let(:metric) { client.create_metric(service_id, friendly_name: name, unit: 'click') }
  let(:plan) { client.create_application_plan(service_id, name: name) }
  let(:name) { SecureRandom.uuid }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  let!(:limit) { client.create_application_plan_limit(plan['id'], metric['id'], period: 'minute', value: 'limit') }

  after(:each) do
    begin
      client.delete_application_plan_limit(plan['id'], metric['id'], limit['id'])
      client.delete_application_plan(service_id, plan['id'])
      client.delete_metric(service_id, metric['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    rescue ThreeScale::API::HttpClient::ForbiddenError
    end
  end


  it 'list' do
    expect(client.list_application_plan_limits(plan['id']).length).to be >= 1
  end

  it 'create' do
    expect(client.read_application_plan_limit(plan['id'], metric['id'], limit['id'])).to include('id' => limit['id'])
  end

  it 'delete' do
    client.delete_application_plan_limit(plan['id'], metric['id'], limit['id'])
    expect{ client.read_application_plan_limit(plan['id'], metric['id'], limit['id'])}
        .to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    expect(client.list_application_plan_limits(plan['id']).any? { |limit| limit['id'] == self.limit['id'] }).to be(false)
  end

end