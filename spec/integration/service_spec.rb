RSpec.describe 'Service API', type: :integration do
  include_context :integration_test_context

  context '#list_services' do
    it { expect(client.list_services.length).to be >= 1 }
  end

  context '#show_service' do
    it { expect(client.show_service(@service_test['id'])).to be }
  end

  context '#create_service' do
    let(:name) { "#{SecureRandom.hex(16)}" }
    subject(:response) { client.create_service('name' => name) }

    after :each do
      client.delete_service(response['id']) if response['errors'].nil?
    end

    it { is_expected.to include('name' => name) }

    context 'with invalid name' do
      let(:name) { '' }

      it { is_expected.to include('errors' => { 'name' => ["can't be blank"] }) }
    end
  end

  context '#update_service' do
    let(:name) { "#{SecureRandom.hex(16)}" }
    subject(:response) { client.update_service(@service_test['id'], 'name' => name) }

    it { is_expected.to include('name' => name) }
  end

  context '#show_proxy' do
    it { expect(client.show_proxy(@service_test['id']).keys.size).to be >= 1 }
  end

  context '#update_proxy' do
    subject(:response) { client.update_proxy(@service_test['id'], credentials_location: 'headers') }
    it { is_expected.to include('credentials_location' => 'headers') }
  end

  context '#list_applications' do
    it { expect(client.list_applications.length).to be >= 1 }
  end

  context '#create_mapping_rules' do
    subject(:mapping_rule) do
      client.create_mapping_rule(@service_test['id'],
                                 http_method: 'PUT',
                                 pattern: '/',
                                 metric_id: @metric_test['id'],
                                 delta: 2)
    end

    after do
      begin
        client.delete_mapping_rule(@service_test['id'], mapping_rule.fetch('id'))
      rescue ThreeScale::API::HttpClient::NotFoundError
      end
    end

    it { expect(mapping_rule).to include('http_method' => 'PUT') }
  end

  context '#list_mapping_rules' do
    subject(:list) { client.list_mapping_rules(@service_test['id']) }
    it { expect(list.size).to be >= 1 }
    it { is_expected.to include(@mapping_rule_test) }
  end

  context '#delete_mapping_rule' do
    let(:new_mapping_rule) do
      client.create_mapping_rule(@service_test['id'],
                                 http_method: 'PUT',
                                 pattern: '/',
                                 metric_id: @metric_test['id'],
                                 delta: 2)
    end

    it 'mapping rule is deleted' do
      expect(client.delete_mapping_rule(@service_test['id'], new_mapping_rule['id'])).to be_truthy
    end
  end

  context '#show_mapping_rule' do
    subject(:show) { client.show_mapping_rule(@service_test['id'], @mapping_rule_test.fetch('id')) }
    it {
      is_expected.to include('http_method' => 'PUT', 'pattern' => '/',
                             'metric_id' => @metric_test['id'], 'delta' => 2)
    }
  end

  context '#list_metrics' do
    it { expect(client.list_metrics(@service_test['id']).length).to be >= 1 }
  end

  context '#create_metric' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(client.create_metric(@service_test['id'], 'friendly_name' => name, 'unit' => 'foo'))
        .to include('friendly_name' => name, 'unit' => 'foo',
                    'name' => name.tr('-', '_'), 'system_name' => name.tr('-', '_'))
    end
  end

  context '#list_methods' do
    it { expect(client.list_methods(@service_test['id'], @hits_metric_test['id']).length).to be >= 1 }
  end

  context '#create_method' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(client.create_method(@service_test['id'], @hits_metric_test['id'], 'friendly_name' => name, 'unit' => 'bar'))
        .to include('friendly_name' => name, # no unit
                    'name' => name.tr('-', '_'), 'system_name' => name.tr('-', '_'))
    end
  end

  context '#list_service_application_plans' do
    it { expect(client.list_service_application_plans(@service_test['id']).length).to be >= 1 }
  end

  context '#create_application_plan' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(client.create_application_plan(@service_test['id'], 'name' => name))
        .to include('name' => name, 'default' => false)
    end
  end

  context '#create_application_plan_limit' do
    let(:create) {
      client.create_application_plan_limit(@application_plan_test['id'],
                                           @metric_test['id'], period: 'hour', value: 42)
    }

    it do
      expect(create).to include('period' => 'hour', 'value' => 42)
    end

    context '#list_application_plan_limits' do
      before { create }
      it { expect(client.list_application_plan_limits(@application_plan_test['id']).length).to be >= 1 }
    end
  end

  context '#delete_service' do
    let(:service_name) { "#{SecureRandom.hex(16)}" }
    let(:new_service) { client.create_service name: service_name }

    it 'service is deleted' do
      expect(client.delete_service(new_service['id'])).to be_truthy
    end
  end
end
