RSpec.describe ThreeScale::API::Client do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#show_service' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42').and_return('service' => {})
      expect(client.show_service(42)).to eq({})
    end
  end

  context '#list_services' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services').and_return('services' => [])
      expect(client.list_services).to eq([])
    end
  end

  context '#create_service' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services', body: { })
        .and_return('service' => {})
      expect(client.create_service({})).to eq({})
    end
  end

  context '#show_proxy' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/proxy').and_return('proxy' => {})
      expect(client.read_proxy(42)).to eq({})
    end
  end

  context '#update_proxy' do
    it do
      expect(http_client).to receive(:patch)
        .with('/admin/api/services/42/proxy', body: {})
        .and_return('proxy' => {})
      expect(client.update_proxy(42, {})).to eq({})
    end
  end

  context '#list_applications' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications', params: nil)
        .and_return('applications' => [])
      expect(client.list_applications).to eq([])
    end

    it 'filters by service' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications', params: { service_id: 42 })
        .and_return('applications' => [])
      expect(client.list_applications(service_id: 42)).to eq([])
    end
  end


  context '#list_applications_for_account' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/accounts/42/applications')
        .and_return('applications' =>  [])
      expect(client.list_applications_for_account(42)).to eq([])
    end
  end

  context '#show_application' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { application_id: 42 })
        .and_return('application' => { 'id' => 42 })
      expect(client.show_application(42)).to eq('id' => 42)
    end
  end

  context '#find_application' do
    it 'finds by id' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { application_id: 42 })
        .and_return('application' => { 'id' => 42 })
      expect(client.find_application(id: 42)).to eq('id' => 42)
    end

    it 'finds by user_key' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { user_key: 'hex' })
        .and_return('application' => { 'user_key' => 'hex' })
      expect(client.find_application(user_key: 'hex')).to eq('user_key' => 'hex')
    end

    it 'finds by app_id' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { app_id: 'hex' })
        .and_return('application' => { 'app_id' => 'hex' })
      expect(client.find_application(application_id: 'hex')).to eq('app_id' => 'hex')
    end
  end

  context '#create_application' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/accounts/42/applications', body: {
                name: 'foo',
                description: 'foo description',
                plan_id: 21,
                user_key: 'foobar',
                applicaton_key: 'hex'
              })
        .and_return('application' => {id: 42 })
      expect(client.create_application(42,
                                       plan_id: 21,
                                       name: 'foo',
                                       description: 'foo description',
                                       user_key: 'foobar',
                                       applicaton_key: 'hex')).to eq(id: 42)
    end
  end

  context '#customize_application_plan' do
    it do
      expect(http_client).to receive(:put)
        .with('/admin/api/accounts/42/applications/21/customize_plan')
        .and_return('application_plan' => { 'id' => 11 })

      expect(client.customize_application_plan(42, 21)).to eq('id' => 11)
    end
  end

  context '#signup' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/signup', body: { org_name: 'foo',
                                           username: 'foobar',
                                           email: 'foo@example.com',
                                           password: 'pass',
                                           billing_address_country: 'Spain',
                                           billing_address_city: 'Barcelona' })
        .and_return('account' => { id: 42 })
      expect(client.sign_up(name: 'foo', username: 'foobar', password: 'pass',
                            billing_address_city: 'Barcelona', email: 'foo@example.com',
                            billing_address_country: 'Spain'))
        .to eq(id: 42)
    end
  end

  context '#list_mapping_rules' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/42/proxy/mapping_rules')
        .and_return('mapping_rules' => [{ 'mapping_rule' => {} }])
      expect(client.list_mapping_rules(42)).to eq([{}])
    end
  end

  context '#show_mapping_rule' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/42/proxy/mapping_rules/21')
        .and_return('mapping_rule' => {})
      expect(client.show_mapping_rule(42, 21)).to eq({})
    end
  end

  context '#create_mapping_rule' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services/42/proxy/mapping_rules',
              body: {  http_method: 'GET' })
        .and_return('mapping_rule' => { 'http_method' => 'GET' })
      expect(client.create_mapping_rule(42, http_method: 'GET')).to eq('http_method' => 'GET')
    end
  end

  context '#create_mapping_rule' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/services/42/proxy/mapping_rules/21')
        .and_return(' ')
      expect(client.delete_mapping_rule(42, 21)).to eq(true)
    end
  end

  context '#create_metric' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services/42/metrics', body: {})
        .and_return('metric' => {})
      expect(client.create_metric(42, {})).to eq({})
    end
  end

  context '#list_methods' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/42/metrics/21/methods')
        .and_return('methods' => [])
      expect(client.list_methods(42, 21)).to eq([])
    end
  end

  context '#create_method' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services/42/metrics/21/methods', body: { })
        .and_return('method' => {})
      expect(client.create_method(42, 21, {})).to eq({})
    end
  end

  context '#list_service_application_plans' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/42/application_plans')
        .and_return('plans' => [{ 'application_plan' => {} }])
      expect(client.list_service_application_plans(42)).to eq([{}])
    end
  end

  context '#create_application_plan' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services/42/application_plans', body: { })
        .and_return('application_plan' => {})
      expect(client.create_application_plan(42, {})).to eq({})
    end
  end

  context '#list_application_plan_limits' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/application_plans/42/limits')
        .and_return('limits' => [{ 'limit' => {} }])
      expect(client.list_application_plan_limits(42)).to eq([{}])
    end
  end

  context '#create_application_plan_limit' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/application_plans/42/metrics/21/limits', body: { })
        .and_return('limit' => {})
      expect(client.create_application_plan_limit(42, 21, {})).to eq({})
    end
  end

  context '#delete_application_plan_limit' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/application_plans/42/metrics/21/limits/10')
        .and_return(nil)
      expect(client.delete_application_plan_limit(42, 21, 10)).to eq(true)
    end
  end
end
