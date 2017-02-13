require 'securerandom'
require '3scale/api'

RSpec.describe 'Applications API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:account_id) { ENV.fetch('ACCOUNT_ID') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:application_plan_id) { ENV.fetch('APPLICATION_PLAN_ID').to_i }
  let(:name) { SecureRandom.uuid }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  let!(:application) do
    client.create_application(account_id,
                              plan_id: application_plan_id,
                              user_key: name,
                              application_id: name,
                              application_key: name)
  end

  after(:each) do
    client.delete_application(account_id, application['id'])
  end

  it 'creates an application' do
    expect(application).to include('user_key' => name, 'service_id' => service_id)
  end

  it 'find all applications' do
    expect(client.list_applications.length).to be >= 1
  end

  it 'find all applications for account' do
    expect(client.list_applications_for_account(account_id).length).to be >= 1
  end

  it 'update an application' do
    expect(client.update_application(account_id, application['id'], name: 'testName')).to include('name' => 'testName')
  end

  it 'suspend and resume an application' do
    expect(client.suspend_application(account_id, application['id'])).to include('state' => 'suspended')
    expect(client.resume_application(account_id, application['id'])).to include('state' => 'live')
  end

  context '#show_application' do
    let(:application_id) { application.fetch('id') }

    subject(:show) { client.show_application(application_id) }

    it do
      expect(show).to include('id' => application_id, 'service_id' => service_id)
    end
  end

  context '#find_application' do
    let(:application_id) { application.fetch('id') }
    let(:user_key) { application.fetch('user_key') }

    it 'finds by id' do
      find = client.find_application(id: application_id)
      expect(find).to include('id' => application_id, 'service_id' => service_id)
    end

    it 'finds by user_key' do
      find = client.find_application(user_key: user_key)
      expect(find).to include('id' => application_id, 'user_key' => user_key)
    end
  end

  context '#application_key' do
    let(:serviceName){ SecureRandom.uuid }
    let(:planName){ SecureRandom.uuid }
    let(:service){ client.create_service(name: serviceName, backend_version: 2) }
    let(:app_plan){ client.create_application_plan(service['id'], name: planName) }
    let(:keyValue){ SecureRandom.uuid }
    let!(:key) { client.create_application_key(account_id, application['id'], keyValue) }

    after(:each) do
      begin
        client.delete_application_key(account_id, application['id'], keyValue)
        client.delete_application_plan(service['id'], app_plan['id'])
        client.delete_service(service['id'])
      rescue ThreeScale::API::HttpClient::NotFoundError
      rescue ThreeScale::API::HttpClient::ForbiddenError
      end
    end

    it 'create' do
      expect(client.list_applications_keys(account_id, application['id']).any? { |key| key['value'] == keyValue }).to be(true)
    end

    it 'list' do
      expect(client.list_applications_keys(account_id, application['id']).any? { |key| key['value'] == keyValue }).to be(true)
    end

    it 'delete'do
      expect(client.list_applications_keys(account_id, application['id']).any? { |key| key['value'] == keyValue }).to be(true)
      client.delete_application_key(account_id, application['id'], keyValue)
      expect(client.list_applications_keys(account_id, application['id']).any? { |key| key['value'] == keyValue }).to be(false)
    end
  end

  context '#application_plan' do
    let(:planName){ SecureRandom.uuid }
    let!(:app_plan){ client.create_application_plan(service_id, name: planName) }

    after(:each) do
      begin
        client.delete_application_plan(service_id, app_plan['id'])
      rescue ThreeScale::API::HttpClient::NotFoundError
      rescue ThreeScale::API::HttpClient::ForbiddenError
      end
    end

    it 'change' do
      expect(application).to include('plan_id' => application_plan_id)
      client.change_application_plan(account_id, application['id'], app_plan['id'])
      expect(client.find_application(id: application['id'])).to include('plan_id' => app_plan['id'])
    end

    it 'create plan customization' do
      expect(client.create_application_plan_customization(account_id, application['id'])).to include('custom' => true)
    end

    it 'delete plan customization' do
      expect(client.delete_application_plan_customization(account_id, application['id'])).to include('custom' => false)
    end
  end

end