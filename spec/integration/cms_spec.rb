RSpec.describe 'CMS API', type: :integration do
  include_context :integration_test_context

  context '#list_cms_files' do
    it { expect(client.list_cms(:file, 1).length).to be >= 1 }
  end

  context '#list_cms_sections' do
    it { expect(client.list_cms(:section, 1).length).to be >= 1 }
  end

  context '#list_cms_partials', skip: true do
    it { expect(client.list_cms(:template, 1, 'partial').length).to be >= 1 }
  end

  context '#list_cms_pages', skip: true do
    it { expect(client.list_cms(:template, 1, :page).length).to be >= 1 }
  end
end