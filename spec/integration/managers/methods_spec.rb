require 'securerandom'
require '3scale/api'
require 'pp'

RSpec.describe 'Application plan limits API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id) { ENV.fetch('SERVICE_ID').to_i }
  let(:metric) { client.list_metrics(service_id).detect {|metric| metric['name'] == 'hits'} }
  let(:name) { SecureRandom.uuid }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  let!(:method) { client.create_method(service_id, metric['id'], friendly_name: name, unit: 'hit') }

  after(:each) do
    begin
      client.delete_method(service_id, metric['id'], method['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    rescue ThreeScale::API::HttpClient::ForbiddenError
    end
  end

  it 'list' do
    expect(client.list_methods(service_id, metric['id']).length).to be >= 1
  end

  it 'create' do
    expect(method).to include('id' => method['id'])
  end

  it 'delete' do
    expect(client.list_methods(service_id, metric['id']).any? { |method| method['id'] == self.method['id'] }).to be(true)
    client.delete_method(service_id, metric['id'], method['id'])
    expect{ client.read_method(service_id, metric['id'], method['id'])}
        .to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    expect(client.list_methods(service_id, metric['id']).any? { |method| method['id'] == self.method['id'] }).to be(false)
  end

end