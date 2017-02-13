require 'securerandom'
require '3scale/api'

RSpec.describe 'Account Plan API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:name) { SecureRandom.uuid }
  let(:rnd_string) { SecureRandom.hex(14) }
  let(:rnd_num) { SecureRandom.random_number(1000000000) * 1.0 }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  before(:each) do
    @account_plan = client.account_plan_create(name, name) # placeholder until we have direct access to DB
  end

  after(:each) do
    begin
      client.account_plan_delete(@account_plan['id']) # placeholder until we have direct access to DB
    rescue ThreeScale::API::HttpClient::NotFoundError
    end
  end

  context '#account_plans_crud' do
    it 'creates an account plan' do
      expect(@account_plan).to include('name' => name)
      expect(client.account_plan_create(name, name)).to include('errors' => {'system_name' => ["has already been taken"]})
      expect(client.account_plan_delete(@account_plan['id'])).to be(true)
      expect { client.account_plan_delete(@account_plan['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'list an account plan' do
      expect(client.account_plan_list.any? { |plan| plan['name'] == @account_plan['name'] }).to be(true)
      expect(client.account_plan_delete(@account_plan['id'])).to be(true)
      expect(client.account_plan_list.any? { |plan| plan['name'] == @account_plan['name'] }).to be(false)
    end

    it 'read an account plan' do
      expect(client.account_plan_read(@account_plan['id'])).to include('name' => @account_plan['name'])
      expect(client.account_plan_delete(@account_plan['id'])).to be(true)
      expect { client.account_plan_read(@account_plan['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'set an account plan to default' do
      expect(@account_plan).to include('default' => false)
      expect(client.account_plan_default(@account_plan['id'])).to include('default' => true)
      expect(client.account_plan_read(@account_plan['id'])).to include('default' => true)
    end

    it 'update an account plan' do
      expect(client.account_plan_update(@account_plan['id'],
                                        name: name,
                                        setup_fee: rnd_num,
                                        # type: 'account_plan'  #TODO try to change this to another type and try to read/list it
                                        # state: 'hidden')
                                        cost_per_month: rnd_num,
                                        trial_period_days: rnd_num,
                                        cancellation_period: rnd_num,
                                        id: rnd_num)
      ).to include(
               'name' => name,
               'setup_fee' => rnd_num,
               'state' => 'hidden',
               'cost_per_month' => rnd_num,
               'trial_period_days' => rnd_num,
               'cancellation_period' => rnd_num,
               'id' => @account_plan['id']
           )

      expect(client.account_plan_read(@account_plan['id'])).to include(
                                                                   'name' => name,
                                                                   'setup_fee' => rnd_num,
                                                                   'state' => 'hidden',
                                                                   'cost_per_month' => rnd_num,
                                                                   'trial_period_days' => rnd_num,
                                                                   'cancellation_period' => rnd_num,
                                                                   'id' => @account_plan['id']
                                                               )
    end

    it 'can\'t update system name to already exists one' do
      plan = client.account_plan_create(rnd_string, rnd_string)
      expect(client.account_plan_update(@account_plan['id'], 'system_name' => rnd_string))
          .to include('errors' => {'system_name' => ["has already been taken"]})
      client.account_plan_delete(plan['id'])
    end

    it 'delete account plan' do
      client.account_plan_delete(@account_plan['id'])
      expect { client.account_plan_read(@account_plan['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
      expect(client.account_plan_list.any? { |plan| plan['name'] == @account_plan['name'] }).to be(false)
    end
  end
end