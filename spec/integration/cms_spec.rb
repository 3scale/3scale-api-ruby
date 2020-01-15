RSpec.describe 'CMS API', type: :integration do
  include_context :integration_test_context

  context '#list_cms_files' do
    it { expect(client.list_cms(:file, 1).length).to be >= 1 }
  end
end
