require 'securerandom'
require '3scale/api'

RSpec.describe 'Application plans API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:name) { SecureRandom.uuid }
  let!(:plan) { client.create_application_plan(service_id, name: name) }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  after(:each) do
    begin
      client.delete_application_plan(service_id, plan['id'])
      rescue ThreeScale::API::HttpClient::NotFoundError
      rescue ThreeScale::API::HttpClient::ForbiddenError
    end
  end

  it 'list application plans' do
    expect(client.list_service_application_plans(service_id).length).to be >= 1
  end

  it 'list of all application plans across services' do
    expect(client.list_all_application_plans.length).to be >= 1
  end

  it 'create application plan' do
    expect(plan).to include('name' => name)
  end

  it 'read application plan' do
    expect(client.read_application_plan(service_id, plan['id'])).to include('name' => name)
  end

  it 'update application plan' do
    expect(plan).to include('name' => name)

    newValue = 'updated name'
    expect(client.update_application_plan(service_id, plan['id'], name: newValue)
    ).to include('name' => newValue)
  end

  it 'delete application plan' do
    client.delete_application_plan(service_id, plan['id'])
    expect(client.list_service_application_plans(service_id).any? { |plan| plan['id'] == self.plan['id'] }).to be(false)
  end

  it 'set default application plan' do
    expect(plan).to include('default' => false)
    expect(client.application_plan_default(service_id, plan['id'])).to include('default' => true)
  end

end