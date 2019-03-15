# frozen_string_literal: true

require 'three_scale_api/http_client'
require 'three_scale_api/tools'
require 'three_scale_api/logging_support'

require 'three_scale_api/clients'

# Base module for the 3Scale client API
module ThreeScaleApi
  # Base class that is supposed to be used for communication with the REST API
  class Client
    attr_accessor :rest

    APIResponseError = Tools::APIResponseError

    # @api public
    # Initializes base client instance for manipulation with the REST API and resources
    #
    # @param [String] endpoint 3Scale admin pages url
    # @param [String] provider_key Provider access token
    # @param [String] log_level Log level ['debug', 'info', 'warning', 'error']
    # @param [Bool] verify_ssl Default value is true
    def initialize(endpoint:, provider_key:, log_level: 'info', verify_ssl: true)
      LoggingSupport.set_level(log_level)
      @rest = HttpClient.new(endpoint:     endpoint,
                             provider_key: provider_key,
                             verify_ssl:   verify_ssl)
    end

    def default_client
      self
    end

    def url
      '/admin/api'
    end

    # @api public
    # Gets services manager instance
    #
    # @return [ThreeScaleApi::Clients::ServiceClient] Service manager instance
    def services
      @services ||= Clients::ServiceClient.new(self)
    end

    # @api public
    # Gets accounts manager instance
    #
    # @return [ThreeScaleApi::Clients::AccountClient] Account manager instance
    def accounts
      @accounts ||= Clients::AccountClient.new(self)
    end

    # @api public
    # Gets providers manager instance
    #
    # @return [ThreeScaleApi::Clients::ProviderClient] Provider manager instance
    def providers
      @providers ||= Clients::ProviderClient.new(self)
    end

    # @api public
    # Gets account plans manager instance
    #
    # @return [ThreeScaleApi::Clients::AccountPlanClient] Account plans manager instance
    def account_plans
      @account ||= Clients::AccountPlanClient.new(self)
    end

    # @api public
    # Gets active docs manager instance
    #
    # @return [ThreeScaleApi::Clients::ActiveDocClient] active docs manager instance
    def active_docs
      @active ||= Clients::ActiveDocClient.new(self)
    end

    # @api public
    # Gets webhooks manager instance
    #
    # @return [ThreeScaleApi::Clients::WebHookClient] WebHooks manager instance
    def webhooks
      @webhooks ||= Clients::WebHookClient.new(self)
    end

    # @api public
    # Gets settings manager instance
    #
    # @return [ThreeScaleApi::Clients::SettingsClient] Settings manager instance
    def settings
      @settings ||= Clients::SettingsClient.new(self)
    end

    # @api public
    # Gets analytics manager instance
    #
    # @return [ThreeScaleApi::Clients::AnalyticsClient] Settings manager instance
    def analytics
      @analytics ||= Clients::AnalyticsClient.new(self)
    end

    def invoices
      @invoices ||= Clients::InvoiceClient.new(self)
    end

    # @api public
    # Gets tenants manager instance
    #
    # @return [ThreeScaleApi::Clients::TenantClient] Tenants manager instance
    def tenants
      @tenants ||= Clients::TenantClient.new(self)
    end

    # @api public
    # Gets OAuth Admin portal client instance
    #
    # @return [ThreeScaleApi::Clients::OAuthAdminPortalClient] Tenants manager instance
    def oauth_admin_portal
      @tenants ||= Clients::OAuthAdminPortalClient.new(self)
    end

    # @api public
    # Gets OAuth Admin portal client instance
    #
    # @return [ThreeScaleApi::Clients::OAuthDevPortalClient] Tenants manager instance
    def oauth_dev_portal
      @tenants ||= Clients::OAuthDevPortalClient.new(self)
    end

    # @api public
    # Gets policy registry manager instance
    #
    # @return [ThreeScaleApi::Clients::PolicyRegistryClient] Policy Registry manager instance
    def policy_registry
      @policy_registry ||= Clients::PolicyRegistryClient.new(self)
    end
  end

  def self.new(**params)
    ThreeScaleApi::Client.new(**params)
  end
end
