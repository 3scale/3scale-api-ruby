RSpec.shared_examples 'fair error handler' do
  context 'Net::HTTPForbidden as response' do
    let!(:stub) do
      stub_request(:any,  /#{admin_domain}/)
        .with(basic_auth: ['', provider_key])
        .and_return(status: 403, body: '{"error":"some error"}')
    end

    it 'parsed' do
      expect { subject }.to raise_error(ThreeScale::API::HttpClient::ForbiddenError)
      expect(stub).to have_been_requested
    end
  end

  context 'Net::HTTPNotFound as response' do
    let!(:stub) do
      stub_request(:any,  /#{admin_domain}/)
        .with(basic_auth: ['', provider_key])
        .and_return(status: 404, body: '{"error":"not found"}')
    end

    it 'parsed' do
      expect { subject }.to raise_error(ThreeScale::API::HttpClient::NotFoundError)
      expect(stub).to have_been_requested
    end
  end

  context 'Unexpected HTTP response' do
    let!(:stub) do
      stub_request(:any,  /#{admin_domain}/)
        .with(basic_auth: ['', provider_key])
        .and_return(status: 500, body: '{"error":"not found"}')
    end

    it 'parsed' do
      expect { subject }.to raise_error(ThreeScale::API::HttpClient::UnexpectedResponseError)
      expect(stub).to have_been_requested
    end
  end
end
