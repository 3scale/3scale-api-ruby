# frozen_string_literal: true

require 'three_scale_api/clients/default'

module ThreeScaleApi
  module Clients
    # Application plan limit resource manager wrapper for an application plan limit entity
    # received by the REST API
    class ApplicationPlanLimitManager < DefaultManager
      attr_accessor :service, :application_plan, :metric

      # @api public
      # Creates instance of the application plan resource manager
      #
      # @param [ThreeScaleQE::HttpClient] http_client Instance of http client
      # @param [ThreeScaleQE::Clients::ApplicationPlan] app_plan Service resource
      def initialize(http_client, app_plan = nil, metric: nil)
        super(http_client, entity_name: 'limit', collection_name: 'limits')
        @service = app_plan.service
        @application_plan = app_plan
        @metric = metric
        @resource_instance = ApplicationPlanLimit
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/application_plans/#{application_plan['id']}/metrics/#{metric['id']}/limits"
      end

      # @api public
      # Binds metric to Application plan limit
      #
      # @param [Metric] metric Metric resource
      def set_metric(metric)
        @metric = metric
      end
    end

    # Application plan limit resource wrapper for an application plan limit entity
    class ApplicationPlanLimit < DefaultResource
      attr_accessor :service, :metric

      # @api public
      # Construct an application plan limit resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ApplicationPlanLimitManager] manager Instance of the manager
      # @param [Hash] entity Entity Hash from API client of the application plan limit
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
        @metric = manager.metric
        @application_plan = manager.application_plan
      end
    end
  end
end