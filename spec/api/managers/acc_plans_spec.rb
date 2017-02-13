require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::AccountPlans do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#read' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/account_plans/42').and_return('account_plan' => {})
      expect(client.read(42)).to eq({})
    end
  end


  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/account_plans').and_return('plans' => [])
      expect(client.list).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/account_plans', body: {
                                     name: 'test-plan',
                                     system_name: 'test-plan'
                                 })
                                 .and_return('account_plan' => {})
      expect(client.create('test-plan', 'test-plan')).to eq({})
    end
  end

  context '#update' do
    it do
      expect(http_client).to receive(:put)
                                 .with('/admin/api/account_plans/42', body: {})
                                 .and_return('account_plan' => {})
      expect(client.update(42, {})).to eq({})
    end

  end
end
