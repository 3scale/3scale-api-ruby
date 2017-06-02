# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/clients/default'
require 'three_scale_api/resources/provider'


module ThreeScaleApi
  module Clients
    # Provider resource manager wrapper for the provider entity received by the REST API
    class ProviderClient < DefaultClient
      include DefaultUserClient

      # @api public
      # Creates instance of the Provider resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'user')
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/users'
      end
    end
  end
end
