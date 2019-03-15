# frozen_string_literal: true

require 'three_scale_api/resources/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/clients/method'

module ThreeScaleApi
  module Resources
    # Policy Registry resource wrapper for the metric entity received by the REST API
    class PolicyRegistry < DefaultResource
      def policy_registry
        client.resource
      end
    end
  end
end
