require 'securerandom'
require '3scale/api'

RSpec.describe 'Account API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:application_plan_id) { ENV.fetch('APPLICATION_PLAN_ID').to_i }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  context '#signup' do
    let(:name) { SecureRandom.hex(14) }
    let(:email) { "#{name}@example.com" }



    context 'account plan' do
      subject(:acc_plan) do
        client.account_plan_create(name, name)
      end

      after(:each) do
        begin
          client.account_plan_delete(acc_plan['id']) # placeholder until we have direct access to DB
        end
      end

      context 'sign up' do
        subject(:sign_up) do
          client.sign_up(name: name, username: name, account_plan_id: acc_plan['id'])
        end

        after(:each) do
          begin
            client.account_delete(sign_up['id']) # placeholder until we have direct access to DB
          end
        end

        it 'creates an account' do
          expect(sign_up).to include('org_name' => name)
        end

        context '#account_list' do
          it do
            expect(client.account_list.length).to be >= 1
          end
        end

        context '#account_show' do
          let(:account_id) { sign_up.fetch('id') }
          subject(:read) do
            client.account_show(account_id)
          end
          it do
            expect(read).to include('id' => account_id)
          end
        end

        context '#create_application' do
          let(:account_id) { sign_up.fetch('id') }
          subject(:create) do
            client.create_application(account_id,
                                      plan_id: application_plan_id,
                                      user_key: name,
                                      application_id: name,
                                      application_key: name)
          end

          it 'creates an application' do
            expect(create).to include('user_key' => name, 'service_id' => service_id)
          end

          context '#show_application' do
            let(:application_id) { create.fetch('id') }

            subject(:read) { client.show_application(application_id) }

            it do
              expect(read).to include('id' => application_id, 'service_id' => service_id)
            end
          end

          context '#find_application' do
            let(:application_id) { create.fetch('id') }
            let(:user_key) { create.fetch('user_key') }

            it 'finds by id' do
              find = client.find_application(id: application_id)
              expect(find).to include('id' => application_id, 'service_id' => service_id)
            end

            it 'finds by user_key' do
              find = client.find_application(user_key: user_key)
              expect(find).to include('id' => application_id, 'user_key' => user_key)
            end
          end

          context '#customize_application_plan' do
            let(:application_id) { create.fetch('id') }

            subject(:customize) { client.customize_application_plan(account_id, application_id) }

            it 'creates custom plan' do
              expect(customize).to include('custom' => true, 'default' => false, 'state' => 'hidden')
              expect(customize['name']).to match('(custom)')
              expect(customize['system_name']).to match('custom')
            end
          end
        end
      end
    end
  end
end
