require '3scale/api/managers'
require '3scale/api/http_client'

module ThreeScale
  module API
    class Client
      attr_reader :acc,
                  :acc_feature,
                  :acc_plan,
                  :acc_plan_feature,
                  :app_plan,
                  :app_plan_limits,
                  :http_client,
                  :applications,
                  :service_plan,
                  :services,
                  :proxy,
                  :metrics,
                  :mappings,
                  :methods

      # @param [ThreeScale::API::HttpClient] http_client

      def initialize(http_client)
        @http_client = http_client
        @acc_feature = ThreeScale::API::Managers::AccountFeatures.new(http_client)
        @applications = ThreeScale::API::Managers::Applications.new(http_client)
        @acc_plan = ThreeScale::API::Managers::AccountPlans.new(http_client)
        @acc_plan_feature = ThreeScale::API::Managers::AccountPlanFeatures.new(http_client)
        @acc = ThreeScale::API::Managers::Accounts.new(http_client)
        @service_plan = ThreeScale::API::Managers::ServicePlans.new(http_client)
        @services = ThreeScale::API::Managers::Services.new(http_client)
        @proxy = ThreeScale::API::Managers::Proxy.new(http_client)
        @app_plan = ThreeScale::API::Managers::ApplicationPlans.new(http_client)
        @metrics = ThreeScale::API::Managers::Metrics.new(http_client)
        @mappings = ThreeScale::API::Managers::Mappings.new(http_client)
        @methods = ThreeScale::API::Managers::Methods.new(http_client)
        @app_plan_limits = ThreeScale::API::Managers::ApplicationPlanLimits.new(http_client)
      end

      ####################################
      #         Account features         #
      ####################################

      # @api public
      # Create an account feature. The features of the account are globally scoped.
      # Creating a feature does not associate the feature with an account plan.
      # @param [String] name Name of the feature.
      # @param [String] system_name System Name of the object to be created. System names cannot be modified after
      #                             creation, they are used as the key to identify the objects.
      # @return [Hash] of created feature
      def account_feature_create(name, system_name)
        @acc_feature.create(name, system_name)
      end

      # @api public
      # Returns an account feature.
      # @param [String] id ID of the feature.
      # @return [Hash] of feature
      def account_feature_read(id)
        @acc_feature.read(id)
      end

      # @api public
      # Updates an account feature.
      # @param [String] id ID of the feature.
      # @param [String] attr attributes to be updated
      # @return [Hash] of updated feature
      def account_feature_update(id, attr)
        @acc_feature.update(id, attr)
      end

      # @api public
      # Deletes an account feature.
      # @param [String] id ID of the feature.
      # @return [bool] if features was deleted
      def account_feature_delete(id)
        @acc_feature.delete(id)
      end

      # @api public
      # Returns the list of the features available to accounts. Account features are globally scoped.
      # @return [Hash] of features
      def account_feature_list
        @acc_feature.list
      end

      ####################################
      #          Account plans           #
      ####################################

      # @api public
      # Returns the list of all available account plans.
      # @return [Hash]
      def account_plan_list
        @acc_plan.list
      end

      # @api public
      # Creates an account plan.
      # @param [String] name Name of the account plan.
      # @param [String] system_name System Name of the object to be created. System names cannot be modified after
      #                             creation, they are used as the key to identify the objects.
      # @return [Hash]
      def account_plan_create(name, system_name)
        @acc_plan.create(name, system_name)
      end

      # @api public
      # Returns the account plan by ID.
      # @param [Fixnum] id ID of the account plan.
      # @return [Hash] Account plan hash
      def account_plan_read(id)
        @acc_plan.read(id)
      end

      # @api public
      # @param [Fixnum] id Id of the application plan
      # @return [Hash] Application plan hash
      def account_plan_show(id)
        @acc_plan.read(id)
      end

      # @api public
      # @param [Fixnum] id Id of account plan
      # @param [Object] attr Attributes that should be updated
      # @option attr [Hash] name Name of the plan
      def account_plan_update(id, attr)
        @acc_plan.update(id, attr)
      end

      # @api public
      # @param [Fixnum] id Id of the application plan
      # @return [Hash] Application plan hash
      def account_plan_delete(id)
        @acc_plan.delete(id)
      end

      # @api public
      # @param [Fixnum] id Application plan ID
      # @return [Hash]Application plan hash
      def account_plan_default(id)
        @acc_plan.set_default(id)
      end

      ####################################
      #      Accounts plan features      #
      ####################################

      # @api public
      # Associate an account feature to an account plan.
      # @param [String] acc_plan_id ID of the account plan.
      # @param [String] acc_feature_id ID of the feature.
      # @return [Hash] of created account plan feature
      def account_plan_feature_create(acc_plan_id, acc_feature_id)
        @acc_plan_feature.create(acc_plan_id, acc_feature_id)
      end

      # @api public
      # Returns the list of the features associated to an account plan.
      # @param [String] acc_plan_id ID of the account plan.
      # @return [Hash] of account plan feature
      def account_plan_feature_list(acc_plan_id)
        @acc_plan_feature.list(acc_plan_id)
      end

      # @api public
      # Deletes the association of an account feature to an account plan.
      # @param [String] acc_plan_id ID of the account plan.
      # @param [String] acc_feature_id ID of the feature.
      # @return [bool]
      def account_plan_feature_delete(acc_plan_id, acc_feature_id)
        @acc_plan_feature.delete(acc_plan_id, acc_feature_id)
      end

      ####################################
      #              Accounts            #
      ####################################

      # @api public
      # @return [Hash] an Account
      # @param [String] name Account Name
      # @param [String] username User Username
      # @param [Hash] attributes User and Account Attributes
      # @option attributes [String] :email User Email
      # @option attributes [String] :password User Password
      # @option attributes [String] :account_plan_id Account Plan ID
      # @option attributes [String] :service_plan_id Service Plan ID
      # @option attributes [String] :application_plan_id Application Plan ID
      def signup(attributes = {}, name:, username:, **rest)
        sign_up(attributes, name: name, username: username, **rest)
      end

      # @api public
      # @return [Hash] an Account
      # @param [String] name Account Name
      # @param [String] username User Username
      # @param [Hash] attributes User and Account Attributes
      # @option attributes [String] :email User Email
      # @option attributes [String] :password User Password
      # @option attributes [String] :account_plan_id Account Plan ID
      # @option attributes [String] :service_plan_id Service Plan ID
      # @option attributes [String] :application_plan_id Application Plan ID
      def sign_up(attributes = {}, name:, username:, **rest)
        @acc.sign_up(attributes, name: name, username: username, **rest)
      end

      # @api public
      # @return [Hash]
      def provider_account_show
        @acc.show_provider
      end

      # @api public
      # @return [Array<Hash>]
      def account_find(attr)
        @acc.find(attr)
      end

      # @api public
      # @return [Array<Hash>]
      def account_list(attr = nil)
        @acc.list(attr)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Account id
      def account_read(id)
        @acc.read(id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Account id
      def account_show(id)
        @acc.read(id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Account id
      def account_delete(id)
        @acc.delete(id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Account id
      # @param [Hash] attr Attributes to be updated
      # @options attr [String] org_name  Organization name
      def account_update(id, attr)
        @acc.update(id, attr)
      end

      # @api public 
      # @param [Fixnum] id Account Id
      # @param [Fixnum] plan_id Account plan Id
      def account_change_plan(id, plan_id)
        @acc.set_plan(id, plan_id)
      end

      # @api public 
      # @param [Fixnum] id Account id
      def account_approve(id)
        @acc.approve(id)
      end

      # @api public 
      # @param [Fixnum] id Account id
      def account_reject(id)
        @acc.reject(id)
      end

      # @api public 
      # @param [Fixnum] id Account id
      def account_pending(id)
        @acc.pending(id)
      end

      ####################################
      #         Service plans            #
      ####################################

      # @api public
      # @return [Array<Hash>] List of services
      def service_plans_list
        @service_plan.list
      end

      # @api public
      # @return [Array<Hash>] List of services
      def service_plans_list_for_service(service_id)
        @service_plan.list_for_service(service_id)
      end

      # @api public
      # @param [Fixnum] service_id Service Id
      # @param [Fixnum] plan_id Service plan Id
      def service_plans_set_default(service_id, plan_id)
        @service_plan.set_default(service_id, plan_id)
      end

      ####################################
      #              Services            #
      ####################################

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Service ID
      def show_service(id)
        @services.read(id)
      end

      # @api public
      # @return [Array<Hash>]
      def list_services
        @services.list
      end

      # @api public
      # @return [Hash]
      # @param [Hash] attr Service Attributes
      # @option attributes [String] :name Service Name
      def create_service(attr)
        @services.create(attr)
      end

      # @api public
      # @param [Fixnum] id Service Id
      def delete_service(id)
        @services.delete(id)
      end

      ####################################
      #              Proxy               #
      ####################################

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def show_proxy(service_id)
        read_proxy(service_id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def read_proxy(service_id)
        @proxy.read(service_id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def update_proxy(service_id, attributes)
        @proxy.update(service_id, attributes)
      end

      ####################################
      #         Applications             #
      ####################################

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_applications(service_id: nil)
        @applications.list(service_id: service_id)
      end


      def list_applications_for_account(account_id)
        @applications.list_for_account(account_id)
      end


      # @api public
      # @return [Hash]
      # @param [Fixnum] id Application ID
      def show_application(id)
        @applications.show(id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Application ID
      # @param [String] user_key Application User Key
      # @param [String] application_id Application App ID
      def find_application(id: nil, user_key: nil, application_id: nil, service_id: nil)
        @applications.find(id: id, user_key: user_key, application_id: application_id, service_id: service_id)

      end

      # @api public
      # @return [Hash] an Application
      # @param [Fixnum] plan_id Application Plan ID
      # @param [Hash] attributes Application Attributes
      # @option attributes [String] :name Application Name
      # @option attributes [String] :description Application Description
      # @option attributes [String] :user_key Application User Key
      # @option attributes [String] :application_id Application App ID
      # @option attributes [String] :application_key Application App Key(s)
      def create_application(account_id, attributes= {}, plan_id:, **rest)
        @applications.create(account_id, attributes: attributes, plan_id: plan_id, **rest)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] id Application id
      # @param [Hash] attributes Application attributes to be updated 
      def update_application(account_id, id, attributes)
        @applications.update(account_id, id, attributes)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] id Application id
      def delete_application(account_id, id)
        @applications.delete(account_id, id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      # @param [String] key Application key
      def create_application_key(account_id, application_id, key)
        @applications.key_create(account_id, application_id, key)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      def list_applications_keys(account_id, application_id)
        @applications.keys_list(account_id, application_id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      # @param [String] key Application key
      def delete_application_key(account_id, application_id, key)
        @applications.key_delete(account_id, application_id, key)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      def list_application_referrer_filter(account_id, application_id)
        @applications.referrer_filter_list(account_id, application_id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      # @param [String] key Application key           
      def create_application_referrer_filter(account_id, application_id, key)
        @applications.referrer_filter_create(account_id, application_id, key)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      # @param [Fixnum] id Referrer id      
      def delete_application_referrer_filter(account_id, application_id, id)
        @applications.referrer_filter_delete(account_id, application_id, id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      # @param [Fixnum] plan_id Application plan id 
      def change_application_plan(account_id, application_id, plan_id)
        @applications.change_plan(account_id, application_id, plan_id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      def create_application_plan_customization(account_id, application_id)
        @applications.create_plan_customization(account_id, application_id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] application_id Application id
      def delete_application_plan_customization(account_id, application_id)
        @applications.delete_plan_customization(account_id, application_id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] id Application id
      def suspend_application(account_id, id)
        @applications.suspend(account_id, id)
      end

      # @api public
      # @param [Fixnum] account_id Account id
      # @param [Fixnum] id Application id
      def resume_application(account_id, id)
        @applications.resume(account_id, id)
      end


      ####################################
      #          Application plans       #
      ####################################

      # @api public
      # Returns the list of all application plans across services
      # @return [Array<Hash>]
      def list_all_application_plans
        @app_plan.list_all
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_service_application_plans(service_id)
        @app_plan.list(service_id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Application Plan Name
      def create_application_plan(service_id, attributes)
        @app_plan.create(service_id, attributes)
      end

      # @api public
      # Returns the application plan by ID.
      # @param [Fixnum] id ID of the application plan.
      # @return [Hash] Application plan hash
      def read_application_plan(service_id, id)
        @app_plan.read(service_id, id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Application plan ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Application Plan Name
      def update_application_plan(service_id, id, attributes)
        @app_plan.update(service_id, id, attributes)
      end

      # @api public
      # @param [Fixnum] service_id
      # @param [Fixnum] id
      # @return [Boolean]
      def delete_application_plan(service_id, id)
        @app_plan.delete(service_id, id)
      end

      def application_plan_default(service_id, id)
        @app_plan.set_default(service_id, id)
      end

      # @api public
      # @return [Hash] a Plan
      # @param [Fixnum] account_id Account ID
      # @param [Fixnum] application_id Application ID
      def customize_application_plan(account_id, application_id)
        @app_plan.customize(account_id, application_id)
      end

      ####################################
      #             Metrics              #
      ####################################

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_metrics(service_id)
        @metrics.list(service_id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Metric Name
      def create_metric(service_id, attributes)
        @metrics.create(service_id, attributes)
      end

      # @api public
      # Returns the metric by ID.
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Id of metric
      # @return [Hash] Metric hash
      def read_metric(service_id, id)
        @metrics.read(service_id, id)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Id of metric
      # @param [Hash] attributes Metric Attributes
      # @return [Hash] Metric hash
      def update_metric(service_id, id, attributes)
        @metrics.update(service_id, id, attributes)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Id of metric
      # @return [Boolean]
      def delete_metric(service_id, id)
        @metrics.delete(service_id, id)
      end

      ####################################
      #             Mappings             #
      ####################################

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_mapping_rules(service_id)
        @mappings.list(service_id)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      def show_mapping_rule(service_id, id)
        @mappings.read(service_id, id)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Mapping Rule Attributes
      # @option attributes [String] :http_method HTTP Method
      # @option attributes [String] :pattern Pattern
      # @option attributes [Fixnum] :delta Increase the metric by delta.
      # @option attributes [Fixnum] :metric_id Metric ID
      def create_mapping_rule(service_id, attributes)
        @mappings.create(service_id, attributes)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      def delete_mapping_rule(service_id, id)
        @mappings.delete(service_id, id)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      # @param [Hash] attributes Mapping Rule Attributes
      # @option attributes [String] :http_method HTTP Method
      # @option attributes [String] :pattern Pattern
      # @option attributes [Fixnum] :delta Increase the metric by delta.
      # @option attributes [Fixnum] :metric_id Metric ID
      def update_mapping_rule(service_id, id, attributes)
       @mappings.update(service_id, id, attributes)
      end


      ####################################
      #             Methods              #
      ####################################

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Method Name
      def create_method(service_id, metric_id, attributes)
        @methods.create(service_id, metric_id, attributes)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      def list_methods(service_id, metric_id)
        @methods.list(service_id, metric_id)
      end

      # @api public
      # @param [Fixnum] service_id Service id
      # @param [Fixnum] metric_id Metric id
      # @param [Fixnum] id Method id
      def read_method(service_id, metric_id, id)
        @methods.read(service_id, metric_id, id)
      end

      # @api public
      # @param [Fixnum] service_id Service id
      # @param [Fixnum] metric_id Metric id
      # @param [Fixnum] id Method id
      def delete_method(service_id, metric_id, id)
        @methods.delete(service_id, metric_id, id)
      end

      ####################################
      #    Application plan limits       #
      ####################################

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] application_plan_id Application Plan ID
      def list_application_plan_limits(application_plan_id)
        @app_plan_limits.list(application_plan_id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Hash] attributes Metric Attributes
      # @param [Fixnum] metric_id Metric ID
      # @option attributes [String] :period Usage Limit period
      # @option attributes [String] :value Usage Limit value
      def create_application_plan_limit(application_plan_id, metric_id, attributes)
        @app_plan_limits.create(application_plan_id, metric_id, attributes)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Fixnum] id Limit ID
      def read_application_plan_limit(application_plan_id, metric_id, id)
        @app_plan_limits.read(application_plan_id, metric_id, id)
      end

      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Fixnum] limit_id Usage Limit ID
      def delete_application_plan_limit(application_plan_id, metric_id, limit_id)
        @app_plan_limits.delete(application_plan_id, metric_id, limit_id)
      end

      protected

      def extract(collection: nil, entity:, from:)
        from = from.fetch(collection) if collection

        case from
        when Array then from.map { |e| e.fetch(entity) }
        when Hash then from.fetch(entity) { from }
        when nil then nil # raise exception?
        else
          raise "unknown #{from}"
        end
      end
    end
  end
end
