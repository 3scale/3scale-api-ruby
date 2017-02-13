require 'securerandom'
require '3scale/api'

RSpec.describe 'Metrics API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:name) { SecureRandom.uuid }
  let(:unit) {'click'}
  let!(:metric) { client.create_metric(service_id, friendly_name: name, unit: unit) }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  after(:each) do
    begin
      client.delete_metric(service_id, metric['id'])
      rescue ThreeScale::API::HttpClient::NotFoundError
      rescue ThreeScale::API::HttpClient::ForbiddenError
    end

  end

  it 'create' do
    expect(metric).to include('friendly_name' => name)
  end

  it 'list' do
    expect(client.list_metrics(service_id).length).to be >= 1
  end

  it 'read' do
    expect(client.read_metric(service_id, metric['id'])).to include('friendly_name' => name)
  end

  it 'update' do
    expect(metric).to include('friendly_name' => name, 'unit' => unit)

    newValue = SecureRandom.uuid
    expect(client.update_metric(service_id, metric['id'], friendly_name: newValue, unit: newValue)
    ).to include('friendly_name' => newValue, 'unit' => newValue)
  end

  it 'delete metric' do
    client.delete_metric(service_id, metric['id'])
    expect(client.list_metrics(service_id).any? { |metric| metric['id'] == self.metric['id'] }).to be(false)
  end

end