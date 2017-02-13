require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::ServicePlans do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#read' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/service_plans/43').and_return('service_plan' => {})
      expect(client.read(42, 43)).to eq({})
    end
  end


  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/service_plans').and_return('plans' => [])
      expect(client.list).to eq([])
    end
  end

  context '#list_for_service' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/service_plans').and_return('plans' => [])
      expect(client.list_for_service(42)).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/service_plans', body: {
                                     name: 'test-plan',
                                 })
                                 .and_return('service_plan' => {})
      expect(client.create(42, 'test-plan')).to eq({})
    end
  end

  context '#set_default' do
    it do
      expect(http_client).to receive(:put).with('/admin/api/services/42/service_plans/43/default').and_return('service_plan' => {})
      expect(client.set_default(42, 43)).to eq({})
    end
  end


end
