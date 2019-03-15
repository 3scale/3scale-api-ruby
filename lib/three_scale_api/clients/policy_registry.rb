# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/policy_registry'

module ThreeScaleApi
  module Clients
    # Policy resource manager wrapper for the proxy entity received by the REST API
    class PolicyRegistryClient < DefaultClient
      include DefaultStateClient
      def entity_name
        nil
      end

      def collection_name
        'policies'
      end

      # @api public
      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def url
        "#{resource.url}/registry/policies"
      end
    end
  end
end
