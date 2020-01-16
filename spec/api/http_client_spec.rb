RSpec.describe ThreeScale::API::HttpClient do
  describe '#initialize' do
    subject(:client) do
      described_class.new(endpoint: 'https://foo-admin.3scale.net',
                          provider_key: 'some-key')
    end

    it { is_expected.to be }

    it { expect(client.admin_domain).to eq('foo-admin.3scale.net') }
    it { expect(client.provider_key).to eq('some-key') }
  end

  let(:admin_domain) { 'foo-admin.3scale.net' }
  let(:provider_key) { 'some-key' }

  subject(:client) { described_class.new(endpoint: "https://#{admin_domain}", provider_key: provider_key) }

  describe '#get' do
    let!(:stub) do
      stub_request(:get,  "https://#{admin_domain}/foo.json")
        .with(basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.get('/foo') }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end

    it_behaves_like 'fair error handler'
  end

  describe '#post' do
    let!(:stub) do
      stub_request(:post, "https://#{admin_domain}/foo.json?one=1&two=2")
        .with(body: '{"bar":"baz"}', basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.post('/foo', body: { bar: 'baz' }, params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end

    it_behaves_like 'fair error handler'
  end

  describe '#put' do
    let(:body) { '' }
    let!(:stub) do
      stub_request(:put, "https://#{admin_domain}/foo.json?one=1&two=2")
        .with(body: body, basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.put('/foo', params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end

    context 'with body' do
      let(:body) { 'foobar' }
      subject { client.put('/foo', body: body, params: { one: 1, two: 2 }) }

      it 'makes a request' do
        is_expected.to be
        expect(stub).to have_been_requested
      end
    end

    it_behaves_like 'fair error handler'
  end

  describe '#patch' do
    let!(:stub) do
      stub_request(:patch,  "https://#{admin_domain}/foo.json?one=1&two=2")
        .with(body: '{"bar":"baz"}', basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.patch('/foo', body: { bar: 'baz' }, params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end

  describe '#delete' do
    let!(:stub) do
      stub_request(:delete, "https://#{admin_domain}/foo.json?one=1&two=2")
        .with(basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.delete('/foo', params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end

    it_behaves_like 'fair error handler'
  end
end
