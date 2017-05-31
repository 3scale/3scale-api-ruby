# frozen_string_literal: true

require 'three_scale_api/clients/default'

module ThreeScaleApi
  module Clients
    # Application key resource manager wrapper for a application key entity received by the REST API
    class ApplicationKeyManager < DefaultManager
      attr_accessor :account, :application
      # @api public
      # Creates instance of the Application Key resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      # @param [Application] application Account entity
      def initialize(http_client, application)
        super(http_client, entity_name: 'key', collection_name: 'keys')
        @resource_instance = ApplicationKey
        @account = application.account
        @application = application
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/accounts/#{account['id']}/applications/#{application['id']}/keys"
      end

      # @api public
      # Creates application key
      #
      # @param [Hash] attributes
      # @option attributes [String] :key Application key
      def create(attributes)
        super(attributes)
        res = _list.find { |key| attributes[:key] == key['value'] }
        log_result res
      end

      # @api public
      # Reads application key
      #
      # @param [String] key Application key
      def read(key)
        @log.info("Read #{resource_name}: #{key}")
        res = _list.find { |k| key == k['value'] }
        log_result res
      end

      # @api public
      # Deletes Application key
      #
      # @param [String] key Application key
      def delete(key)
        @log.info("Delete #{resource_name}: #{key}")
        @http_client.delete("#{base_path}/#{key}")
        true
      end
    end

    # Application key resource wrapper for a application key entity received by the REST API
    class ApplicationKey < DefaultResource
      attr_accessor :account, :application
      # @api public
      # Creates instance of the Application key resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ApplicationKeyManager] manager Instance of the manager
      # @param [Hash] entity Application key Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @account = manager.account
        @application = manager.application
      end

      # @api public
      # Deletes key resource
      def delete
        @manager.delete(entity['value']) if @manager.respond_to?(:delete)
      end
    end
  end
end