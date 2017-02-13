require 'securerandom'
require '3scale/api'

RSpec.describe 'Account API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:application_plan_id) { ENV.fetch('APPLICATION_PLAN_ID').to_i }
  let(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }
  let(:name) { SecureRandom.uuid }
  let(:rnd_string) { SecureRandom.hex(14) }
  let(:email) { "#{name}@example.com" }

  before(:each) do
    @acc_plan = client.account_plan_create(name, name)
    @account = client.sign_up(name: name, username: name, account_plan_id: @acc_plan['id'])
  end

  after(:each) do
    begin
      client.account_delete(@account['id'])
      rescue ThreeScale::API::HttpClient::NotFoundError
    end
    begin
      client.account_plan_delete(@acc_plan['id'])
      rescue ThreeScale::API::HttpClient::NotFoundError
    end
  end

  context '#account_crud' do
    it 'create an account' do
      expect(@account).to include('org_name' => name)
      expect(client.sign_up(name: name, username: name, account_plan_id: @acc_plan['id'])['errors']).to include('username' => ["has already been taken"])
      expect(client.account_delete(@account['id'])).to be(true)
      expect { client.account_plan_delete(@account['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'list an account' do
      expect(client.account_list.any? { |acc| acc['org_name'] == @account['org_name'] }).to be(true)
      expect(client.account_delete(@account['id'])).to be(true)
      expect(client.account_list.any? { |acc| acc['name'] == @account['org_name'] }).to be(false)
    end

    it 'find an account' do
      expect(client.account_find({username: name, email: email, user_id: @account['id']})).to include('org_name' => name, 'id' => @account['id'])
      expect(client.account_delete(@account['id'])).to be(true)
      expect { client.account_find({username: name, email: email, user_id: @account['id']}) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'read an account' do
      expect(client.account_read(@account['id'])).to include('org_name' => @account['org_name'], 'id' => @account['id'])
      expect(client.account_delete(@account['id'])).to be(true)
      expect { client.account_read(@account['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'update an account' do
      expect(client.account_update(@account['id'], org_name: rnd_string)).to include('org_name' => rnd_string)
      expect(client.account_delete(@account['id'])).to be(true)
      expect { client.account_update(@account['id'], org_name: rnd_string)}.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
    end

    it 'delete an account' do
      expect(client.account_delete(@account['id'])).to be(true)
      expect { client.account_read(@account['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
      expect(client.account_list.any? { |acc| acc['name'] == @account['org_name'] }).to be(false)
    end

    it 'change a plan' do
      new_plan = client.account_plan_create(rnd_string, rnd_string)

      expect(client.account_change_plan(@account['id'], new_plan['id'])['account_plan']).to include('id' => new_plan['id'])
      expect(client.account_delete(@account['id'])).to be(true)
      expect { client.account_change_plan(@account['id'], @acc_plan['id']) }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)

      client.account_plan_delete(new_plan['id'])
    end

    it 'approve an account' do
      expect(client.account_read(@account['id'])).to include('state' => 'created')
      expect(client.account_approve(@account['id'])).to include('state' => 'approved')
      expect(client.account_read(@account['id'])).to include('state' => 'approved')
      end

    it 'reject an account' do
      expect(client.account_read(@account['id'])).to include('state' => 'created')
      expect(client.account_reject(@account['id'])).to include('state' => 'rejected')
      expect(client.account_read(@account['id'])).to include('state' => 'rejected')
    end

    it 'reset an account to pending' do
      expect(client.account_read(@account['id'])).to include('state' => 'created')
      expect(client.account_pending(@account['id'])).to include('state' => 'pending')
      expect(client.account_read(@account['id'])).to include('state' => 'pending')
    end
  end
end
