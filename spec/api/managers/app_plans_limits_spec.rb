require '3scale/api/managers'
require '3scale/api'
require 'webmock/rspec'

RSpec.describe ThreeScale::API::Managers::ApplicationPlanLimits do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#list' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/application_plans/42/limits').and_return('limits' => [])
      expect(client.list(42)).to eq([])
    end
  end

  context '#create' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/application_plans/42/metrics/43/limits', body: {})
                                 .and_return('limit' => {})
      expect(client.create(42, 43, {})).to eq({})
    end
  end

end
