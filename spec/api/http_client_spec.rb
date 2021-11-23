RSpec.describe ThreeScale::API::HttpClient do
  let(:admin_domain) { 'foo-admin.3scale.net' }
  let(:provider_key) { 'some-key' }

  describe '#initialize' do
    subject(:client) do
      described_class.new(endpoint: "https://#{admin_domain}",
                          provider_key: provider_key)
    end

    it { is_expected.to be }

    it { expect(client.admin_domain).to eq(admin_domain) }
    it { expect(client.provider_key).to eq(provider_key) }

    describe 'with unexpected format' do
      let(:client) do
        described_class.new(endpoint: 'https://foo-admin.3scale.net',
                            provider_key: 'some-key', format: 'unknown')
      end

      let!(:stub) do
        stub_request(:get,  "https://#{admin_domain}/foo.unknown")
          .with(basic_auth: ['', provider_key])
          .and_return(body: 'something')
      end

      subject { client.get('/foo') }
      it do
        expect { subject }.to raise_error(ThreeScale::API::HttpClient::UnknownFormatError)
      end
    end
  end

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

  describe '#get returns HTTPForbidden' do
    subject(:client) { described_class.new(endpoint: "https://#{admin_domain}", provider_key: provider_key) }

    let!(:stub) do
      stub_request(:get,  "https://#{admin_domain}/foo.json")
        .with(basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}',
                    headers: { 'Content-Type' => 'application/json; charset=utf-8' },
                    status: 403)
    end

    subject { client.get('/foo') }

    it do
      expect { subject }.to raise_error(ThreeScale::API::HttpClient::ForbiddenError, /bar/)
    end
  end

  describe '#get returns HTTPNotFound' do
    subject(:client) { described_class.new(endpoint: "https://#{admin_domain}", provider_key: provider_key) }

    let!(:stub) do
      stub_request(:get,  "https://#{admin_domain}/foo.json")
        .with(basic_auth: ['', provider_key])
        .and_return(body: '{"foo":"bar"}',
                    headers: { 'Content-Type' => 'application/json; charset=utf-8' },
                    status: 404)
    end

    subject { client.get('/foo') }

    it do
      expect { subject }.to raise_error(ThreeScale::API::HttpClient::NotFoundError, /bar/)
    end
  end

  describe 'keep alive connections' do
    let(:client) do
      described_class.new(endpoint: 'https://foo-admin.3scale.net',
                          provider_key: 'some-key', keep_alive: true,
                         )
    end

    it do
      expect(client.keep_alive).to be_truthy
    end

    describe '#get' do
      let!(:stub) do
        stub_request(:get, "https://#{admin_domain}/foo.json").and_return(body: '{"foo": "bar"}')
      end

      subject { client.get('/foo') }

      it 'makes a request' do
        is_expected.to be
        expect(stub).to have_been_requested
      end

      it 'returns body' do
        is_expected.to eq('foo' => 'bar')
      end
    end

    describe '#patch' do
      let!(:stub) do
        stub_request(:patch,  "https://#{admin_domain}/foo.json")
          .and_return(body: '{"foo":"bar"}')
      end

      subject { client.patch('/foo', body: nil) }

      it 'makes a request' do
        is_expected.to be
        expect(stub).to have_been_requested
      end

      it 'returns body' do
        is_expected.to eq('foo' => 'bar')
      end
    end

    describe '#post' do
      let!(:stub) do
        stub_request(:post,  "https://#{admin_domain}/foo.json")
          .and_return(body: '{"foo":"bar"}')
      end

      subject { client.post('/foo', body: nil) }

      it 'makes a request' do
        is_expected.to be
        expect(stub).to have_been_requested
      end

      it 'returns body' do
        is_expected.to eq('foo' => 'bar')
      end
    end

    describe '#put' do
      let!(:stub) do
        stub_request(:put,  "https://#{admin_domain}/foo.json")
          .and_return(body: '{"foo":"bar"}')
      end

      subject { client.put('/foo', body: nil) }

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
        stub_request(:delete,  "https://#{admin_domain}/foo.json")
          .and_return(body: '{"foo":"bar"}')
      end

      subject { client.delete('/foo') }

      it 'makes a request' do
        is_expected.to be
        expect(stub).to have_been_requested
      end

      it 'returns body' do
        is_expected.to eq('foo' => 'bar')
      end
    end
  end
end
