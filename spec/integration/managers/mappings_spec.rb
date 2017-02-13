require 'securerandom'
require '3scale/api'

RSpec.describe 'Application plans API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:name) { SecureRandom.uuid }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }
  let(:service) { client.create_service(name: name, system_name: name) }
  let(:metric) { client.create_metric(service['id'], friendly_name: name, unit: 'click') }
  let!(:mapping) { client.create_mapping_rule(service['id'], http_method: 'GET', pattern: '/pattern', delta: 2, metric_id: metric['id']) }

  after(:each) do
    begin
      client.delete_mapping_rule(service['id'], mapping['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    end
    begin
      client.delete_metric(service['id'], metric['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    end
    begin
      client.delete_service(service['id'])
    rescue ThreeScale::API::HttpClient::NotFoundError
    end
  end

  context 'mapping rule crud' do
    it 'create a mapping rule' do
      mapping_rule = client.create_mapping_rule(service['id'], http_method: 'GET', pattern: '/pattern', delta: 2,
                                                metric_id: metric['id'])
      expect(mapping).to include('metric_id' => metric['id'])
      expect(mapping_rule).to include('metric_id' => metric['id'])
      expect(client.delete_mapping_rule(service['id'], mapping_rule['id'])).to be(true)
    end

    it 'list a mapping rule' do
      expect(client.list_mapping_rules(service['id']).any? { |rule| rule['id'] == mapping['id'] }).to be(true)
      expect(client.delete_mapping_rule(service['id'], mapping['id'])).to be(true)
      expect(client.list_mapping_rules(service['id']).any? { |rule| rule['id'] == mapping['id'] }).to be(false)
    end

    it 'read a mapping rule' do
      expect(client.show_mapping_rule(service['id'], mapping['id'])).to include('id' => mapping['id'], 'metric_id' => metric['id'])
      expect(client.delete_mapping_rule(service['id'], mapping['id'])).to be(true)
      expect { client.show_mapping_rule(service['id'], mapping['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'delete a mapping rule' do
      expect(client.delete_mapping_rule(service['id'], mapping['id'])).to be(true)
      expect { client.show_mapping_rule(service['id'], mapping['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
      expect(client.list_mapping_rules(service['id']).any? { |rule| rule['id'] == mapping['id'] }).to be(false)
    end

    it 'update a mapping rule' do
      expect(client.update_mapping_rule(service['id'], mapping['id'], pattern: "/#{name}")).to include('pattern' => "/#{name}")
      expect(client.show_mapping_rule(service['id'], mapping['id'])).to include('pattern' => "/#{name}")
      expect(client.delete_mapping_rule(service['id'], mapping['id'])).to be(true)
      expect { client.update_mapping_rule(service['id'], mapping['id'], pattern: "/#{name}") }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end
  end
end