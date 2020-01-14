require 'securerandom'

RSpec.shared_context :integration_test_context do
  subject(:client) do
    ThreeScale::API.new(endpoint: @endpoint, provider_key: @provider_key, verify_ssl: @verify_ssl)
  end

  before :context do
    @endpoint = ENV.fetch('ENDPOINT')
    @provider_key = ENV.fetch('PROVIDER_KEY')
    @verify_ssl = !(ENV.fetch('VERIFY_SSL', 'true').to_s =~ /(true|t|yes|y|1)$/i).nil?
    @apiclient = ThreeScale::API.new(endpoint: @endpoint, provider_key: @provider_key,
                                     verify_ssl: @verify_ssl)
    @service_test = @apiclient.create_service('name' => "#{SecureRandom.hex(16)}")
    account_name = SecureRandom.hex(14)
    @account_test = @apiclient.signup(name: account_name, username: account_name)
    @application_plan_test = @apiclient.create_application_plan(@service_test['id'], 'name' => "#{SecureRandom.hex(16)}")
    app_id = SecureRandom.hex(14)
    @application_test = @apiclient.create_application(@account_test['id'],
                                                      plan_id: @application_plan_test['id'],
                                                      user_key: app_id)
    @metric_test = @apiclient.create_metric(@service_test['id'],
                                            'friendly_name' => SecureRandom.uuid, 'unit' => 'foo')
    @mapping_rule_test = @apiclient.create_mapping_rule(@service_test['id'],
                                                        http_method: 'PUT',
                                                        pattern: '/',
                                                        metric_id: @metric_test['id'],
                                                        delta: 2)
    @hits_metric_test = @apiclient.list_metrics(@service_test['id']).find do |metric|
      metric['system_name'] == 'hits'
    end

    @method_test = @apiclient.create_method(@service_test['id'], @hits_metric_test['id'],
                                            'friendly_name' => SecureRandom.uuid, 'unit' => 'bar')
  end

  after :context do
    return if @apiclient == nil
    @apiclient.delete_application(@account_test['id'], @application_test['id']) if @account_test != nil && @application_test != nil
    @apiclient.delete_service(@service_test['id']) if @service_test
    @apiclient.delete_account(@account_test['id']) if @account_test
  end
end
