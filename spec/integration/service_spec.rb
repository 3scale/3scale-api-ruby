require 'securerandom'

RSpec.describe 'Service API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:metric_id) { ENV.fetch('METRIC_ID').to_i }
  let(:application_plan_id) { ENV.fetch('APPLICATION_PLAN_ID').to_i }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  context '#list_services' do
    it { expect(client.list_services.length).to be >= 1 }
  end

  context '#show_service' do
    it { expect(client.show_service(service_id)).to be }
  end

  context '#create_service' do
    let(:name) { SecureRandom.uuid }
    subject(:response) { client.create_service('name' => name) }

    after(:each) do
      client.delete_service(response['id'])
    end

    it { is_expected.to include('name' => name) }

  end

  context '#show_proxy' do
    it { expect(client.read_proxy(service_id).keys.size).to be >= 1 }
  end

  context '#update_proxy' do
    subject(:response) { client.update_proxy(service_id, credentials_location: 'headers') }
    it { is_expected.to include('credentials_location' => 'headers') }
  end

  context '#list_applications' do
    it { expect(client.list_applications.length).to be >= 1 }
  end

  context '#create_mapping_rules' do
    subject(:create) do
      client.create_mapping_rule(service_id,
                                 http_method: 'PUT',
                                 pattern: '/',
                                 metric_id: metric_id,
                                 delta: 2)
    end

    it { expect(create).to include('http_method' => 'PUT') }

    after {
      begin
        client.delete_mapping_rule(service_id, create.fetch('id'))
      rescue ThreeScale::API::HttpClient::NotFoundError
      end
    }

    context '#list_mapping_rules' do
      before { create }
      subject(:list) { client.list_mapping_rules(service_id) }
      it { expect(list.size).to be >= 1 }
      it { is_expected.to include(create) }
    end

    context '#delete_mapping_rule' do
      subject(:delete) { client.delete_mapping_rule(service_id, create.fetch('id')) }

      it { is_expected.to be }
    end

    context '#show_mapping_rule' do
      subject(:read) { client.show_mapping_rule(service_id, create.fetch('id')) }
      it { is_expected.to include('http_method' => 'PUT', 'pattern' => '/', 'metric_id' => metric_id, 'delta' => 2) }
    end
  end

  context '#list_metrics' do
    it { expect(client.list_metrics(service_id).length).to be >= 1 }
  end

  context '#create_metric' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(client.create_metric(service_id, 'friendly_name' => name, 'unit' => 'foo'))
        .to include('friendly_name' => name, 'unit' => 'foo',
                    'name' => name.tr('-', '_'), 'system_name' => name.tr('-', '_'))
    end
  end

  context '#list_methods' do
    it { expect(client.list_methods(service_id, metric_id).length).to be >= 1 }
  end

  context '#create_method' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(client.create_method(service_id, metric_id, 'friendly_name' => name, 'unit' => 'bar'))
        .to include('friendly_name' => name, # no unit
                    'name' => name.tr('-', '_'), 'system_name' => name.tr('-', '_'))
    end
  end

  context '#list_service_application_plans' do
    it { expect(client.list_service_application_plans(service_id).length).to be >= 1 }
  end

  context '#create_method' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(client.create_application_plan(service_id, 'name' => name))
        .to include('name' => name, 'default' => false)
    end
  end

  context '#create_application_plan_limit' do
    let(:create) { client.create_application_plan_limit(application_plan_id, metric_id, period: 'hour', value: 42) }

    it do
      expect(create).to include('period' => 'hour', 'value' => 42)
    end

    context '#list_application_plan_limits' do
      before { create }
      it { expect(client.list_application_plan_limits(application_plan_id).length).to be >= 1 }
    end

    after do
      # the test has to clean up after itself, otherwise the second run would fail validation
      if (limit_id = create['id'])
        client.delete_application_plan_limit(application_plan_id, metric_id, limit_id)
      end
    end
  end
end
