require '3scale/api/version'
require '3scale/api/errors'

module ThreeScale
  module API
    autoload :Client, '3scale/api/client'
    autoload :HttpClient, '3scale/api/http_client'

    def self.new(endpoint:, provider_key:, verify_ssl: true, keep_alive: false)
      http_client = HttpClient.new(endpoint: endpoint,
                                   provider_key: provider_key,
                                   verify_ssl: verify_ssl,
                                   keep_alive: keep_alive,
                                  )
      Client.new(http_client)
    end
  end
end
