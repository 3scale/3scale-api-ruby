RSpec.describe 'Account API', type: :integration do
  include_context :integration_test_context

  let(:name) { SecureRandom.uuid }

  context '#signup' do
    let(:email) { "#{name}@example.com" }

    subject(:signup) do
      client.signup(name: name, username: name,
                    billing_address_city: 'Barcelona',
                    'billing_address_country' => 'Spain')
    end

    after :each do
      client.delete_account(signup['id'])
    end

    it 'creates an account' do
      expect(signup).to include('org_name' => name)
      expect(signup['billing_address']).to include('company' => name, 'city' => 'Barcelona', 'country' => 'Spain')
    end
  end

  context '#create_application' do
    let(:account_id) { @account_test.fetch('id') }
    subject(:application) do
      client.create_application(account_id,
                                plan_id: @application_plan_test['id'],
                                user_key: name,
                                application_id: name,
                                application_key: name)
    end

    after :each do
      client.delete_application(account_id, application['id'])
    end

    it 'creates an application' do
      expect(application).to include('user_key' => name, 'service_id' => @service_test['id'])
    end
  end

  context '#show_application' do
    let(:application_id) { @application_test.fetch('id') }

    subject(:show) { client.show_application(application_id) }

    it do
      expect(show).to include('id' => application_id, 'service_id' => @service_test['id'])
    end
  end

  context '#find_application' do
    let(:application_id) { @application_test.fetch('id') }
    let(:user_key) { @application_test.fetch('user_key') }

    it 'finds by id' do
      find = client.find_application(id: application_id)
      expect(find).to include('id' => application_id, 'service_id' => @service_test['id'])
    end

    it 'finds by user_key' do
      find = client.find_application(user_key: user_key)
      expect(find).to include('id' => application_id, 'user_key' => user_key)
    end

    context 'on app_id, app_key service' do
      let(:service) do
        @apiclient.create_service(
          'name' => "#{SecureRandom.hex(16)}",
          'backend_version': '2'
        )
      end
      let(:account) do
        @apiclient.signup(name: SecureRandom.hex(14), username: SecureRandom.hex(14))
      end
      let(:application_plan) do
        @apiclient.create_application_plan(service['id'],
                                           'name' => "#{SecureRandom.hex(16)}")
      end
      let(:app_id) { SecureRandom.hex(14) }
      let!(:application) do
        @apiclient.create_application(account['id'], plan_id: application_plan['id'],
                                                     application_id: app_id,
                                                     application_key: app_id)
      end

      after :each do
        @apiclient.delete_application(account['id'], application['id'])
        @apiclient.delete_service(service['id'])
        @apiclient.delete_account(account['id'])
      end

      it 'finds by app_id' do
        find = client.find_application(application_id: app_id)
        expect(find).to include('id' => application['id'], 'application_id' => app_id)
      end
    end
  end

  context '#customize_application_plan' do
    let(:application_id) { @application_test.fetch('id') }
    let(:account_id) { @account_test.fetch('id') }

    subject(:customize) { client.customize_application_plan(account_id, application_id) }

    it 'creates custom plan' do
      expect(customize).to include('custom' => true, 'default' => false, 'state' => 'hidden')
      expect(customize['name']).to match('(custom)')
      expect(customize['system_name']).to match('custom')
    end
  end
end
