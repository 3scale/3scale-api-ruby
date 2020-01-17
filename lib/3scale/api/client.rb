module ThreeScale
  module API
    class Client
      attr_reader :http_client

      # @param [ThreeScale::API::HttpClient] http_client

      def initialize(http_client)
        @http_client = http_client
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Service ID
      def show_service(id)
        response = http_client.get("/admin/api/services/#{id}")
        extract(entity: 'service', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      def list_services
        response = http_client.get('/admin/api/services')
        extract(collection: 'services', entity: 'service', from: response)
      end

      # @api public
      # @param [Fixnum] id Service ID
      def delete_service(id)
        http_client.delete("/admin/api/services/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] plan_id Application Plan ID
      # @return [Array<Hash>]
      def list_applications(service_id: nil, plan_id: nil)
        params = { service_id: service_id, plan_id: plan_id }.compact
        response = http_client.get('/admin/api/applications', params: params)
        extract(collection: 'applications', entity: 'application', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Application ID
      def show_application(id)
        find_application(id: id)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Application ID
      # @param [String] user_key Application User Key
      # @param [String] application_id Application app_id
      def find_application(id: nil, user_key: nil, application_id: nil, service_id: nil)
        params = {
          application_id: id,
          user_key: user_key,
          app_id: application_id,
          service_id: service_id,
        }.compact
        response = http_client.get('/admin/api/applications/find', params: params)
        extract(entity: 'application', from: response)
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
      def create_application(account_id, attributes = {}, plan_id:, **rest)
        body = { plan_id: plan_id }.merge(attributes).merge(rest)
        response = http_client.post("/admin/api/accounts/#{account_id}/applications", body: body)
        extract(entity: 'application', from: response)
      end

      # @api public
      # @param [Fixnum] account_id Account ID
      # @param [Fixnum] id Application ID
      # @param [Hash] attrs Application Attributes
      # @return [Hash] an Application
      def update_application(account_id, id, attrs)
        response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}", body: attrs)
        extract(entity: 'application', from: response)
      end

      # @api public
      # @return [Hash] a Plan
      # @param [Fixnum] account_id Account ID
      # @param [Fixnum] application_id Application ID
      def customize_application_plan(account_id, application_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/customize_plan")
        extract(entity: 'application_plan', from: response)
      end

      # @api public
      # @return [Hash] a Plan
      # @param [Fixnum] account_id Account ID
      # @param [Fixnum] application_id Application ID
      def delete_application_plan_customization(account_id, application_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/decustomize_plan")
        extract(entity: 'application_plan', from: response)
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
      def signup(attributes = {}, name:, username:, **rest)
        body = { org_name: name,
                 username: username }.merge(attributes).merge(rest)
        response = http_client.post('/admin/api/signup', body: body)
        extract(entity: 'account', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Hash] attributes Service Attributes
      # @option attributes [String] :name Service Name
      def create_service(attributes)
        response = http_client.post('/admin/api/services', body: { service: attributes })
        extract(entity: 'service', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Service Attributes
      # @option attributes [String] :name Service Name
      def update_service(service_id, attributes)
        response = http_client.put("/admin/api/services/#{service_id}", body: { service: attributes })
        extract(entity: 'service', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def show_proxy(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy")
        extract(entity: 'proxy', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [String] environment. Must be 'sandbox' or 'production'
      def proxy_config_list(service_id, environment = 'sandbox')
        response = http_client.get("/admin/api/services/#{service_id}/proxy/configs/#{environment}")
        extract(collection: 'proxy_configs', entity: 'proxy_config', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [String] environment. Must be 'sandbox' or 'production'
      def proxy_config_latest(service_id, environment = 'sandbox')
        response = http_client.get("/admin/api/services/#{service_id}/proxy/configs/#{environment}/latest")
        extract(entity: 'proxy_config', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [String] environment. Must be 'sandbox' or 'production'
      # @param [Fixnum] version Proxy configuration version
      def show_proxy_config(service_id, environment, version)
        response = http_client.get("/admin/api/services/#{service_id}/proxy/configs/#{environment}/#{version}")
        extract(entity: 'proxy_config', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [String] environment Must be 'sandbox' or 'production'
      # @param [Fixnum] version Version to promote
      # @param [Fixnum] to To which the specified proxy configuration will be promoted to
      def promote_proxy_config(service_id, environment, version, to)
        response = http_client.post("/admin/api/services/#{service_id}/proxy/configs/#{environment}/#{version}/promote",
                                    body: { to: to })
        extract(entity: 'proxy_config', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def update_proxy(service_id, attributes)
        response = http_client.patch("/admin/api/services/#{service_id}/proxy",
                                     body: { proxy: attributes })
        extract(entity: 'proxy', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_mapping_rules(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules")
        extract(entity: 'mapping_rule', collection: 'mapping_rules', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      def show_mapping_rule(service_id, id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}")
        extract(entity: 'mapping_rule', from: response)
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
        response = http_client.post("/admin/api/services/#{service_id}/proxy/mapping_rules",
                                    body: { mapping_rule: attributes })
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      def delete_mapping_rule(service_id, id)
        http_client.delete("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}")
        true
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
        response = http_client.patch("/admin/api/services/#{service_id}/mapping_rules/#{id}",
                                     body: { mapping_rule: attributes })
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Metric ID
      # @return [Hash]
      def show_metric(service_id, id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics/#{id}")
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_metrics(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics")
        extract(collection: 'metrics', entity: 'metric', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Metric Name
      def create_metric(service_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/metrics", body: { metric: attributes })
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :friendly_name Metric Name
      # @option attributes [String] :unit Metric unit
      # @option attributes [String] :description Metric description
      def update_metric(service_id, metric_id, attributes)
        response = http_client.put("/admin/api/services/#{service_id}/metrics/#{metric_id}",
                                   body: { metric: attributes })
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @return [Bool]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      def delete_metric(service_id, metric_id)
        http_client.delete("/admin/api/services/#{service_id}/metrics/#{metric_id}")
        true
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] parent_id Parent metric ID
      # @param [Fixnum] id Method ID
      # @return [Hash]
      def show_method(service_id, parent_id, id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics/#{parent_id}/methods/#{id}")
        extract(entity: 'method', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] parent_id Parent metric ID
      # @param [Fixnum] id Method ID
      # @param [Hash] attributes Method Attributes
      def update_method(service_id, parent_id, id, attributes)
        response = http_client.put("/admin/api/services/#{service_id}/metrics/#{parent_id}/methods/#{id}",
                                   body: { metric: attributes })
        extract(entity: 'method', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      def list_methods(service_id, metric_id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods")
        extract(collection: 'methods', entity: 'method', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Method Name
      def create_method(service_id, metric_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods",
                                    body: { metric: attributes })
        extract(entity: 'method', from: response)
      end

      # @api public
      # @return [Bool]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] parent_id Parent metric ID
      # @param [Fixnum] id Metric ID
      def delete_method(service_id, parent_id, id)
        http_client.delete("/admin/api/services/#{service_id}/metrics/#{parent_id}/methods/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @return [Hash]
      def list_metric_limits(application_plan_id, metric_id)
        response = http_client.get("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits")
        extract(collection: 'limits', entity: 'limit', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_service_application_plans(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/application_plans")

        extract(collection: 'plans', entity: 'application_plan', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Application Plan Name
      def create_application_plan(service_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/application_plans",
                                    body: { application_plan: attributes })
        extract(entity: 'application_plan', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Application Plan ID
      # @return [Hash]
      def show_application_plan(service_id, id)
        response = http_client.get("/admin/api/services/#{service_id}/application_plans/#{id}")
        extract(entity: 'application_plan', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Application Plan ID
      # @param [Hash] attributes Application Plan Attributes
      # @return [Hash]
      def update_application_plan(service_id, id, attributes)
        response = http_client.patch("/admin/api/services/#{service_id}/application_plans/#{id}",
                                     body: { application_plan: attributes })
        extract(entity: 'application_plan', from: response)
      end

      # @api public
      # @return [Bool]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] application_plan_id Application Plan ID
      def delete_application_plan(service_id, application_plan_id)
        http_client.delete("/admin/api/services/#{service_id}/application_plans/#{application_plan_id}")
        true
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] application_plan_id Application Plan ID
      # @return [Hash]
      def application_plan_as_default(service_id, application_plan_id)
        response = http_client.put("/admin/api/services/#{service_id}/application_plans/#{application_plan_id}/default")
        extract(entity: 'application_plan', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] application_plan_id Application Plan ID
      def list_application_plan_limits(application_plan_id)
        response = http_client.get("/admin/api/application_plans/#{application_plan_id}/limits")

        extract(collection: 'limits', entity: 'limit', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Hash] attributes Limit Attributes
      def create_application_plan_limit(application_plan_id, metric_id, attributes)
        response = http_client.post("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits",
                                    body: { usage_limit: attributes })
        extract(entity: 'limit', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Fixnum] limit_id Usage Limit ID
      # @param [Hash] attributes Limit Attributes
      def update_application_plan_limit(application_plan_id, metric_id, limit_id, attributes)
        response = http_client.put("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits/#{limit_id}",
                                   body: { usage_limit: attributes })
        extract(entity: 'limit', from: response)
      end

      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Fixnum] limit_id Usage Limit ID
      def delete_application_plan_limit(application_plan_id, metric_id, limit_id)
        http_client.delete("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits/#{limit_id}")
        true
      end

      # @api public
      # @param [Hash] criteria Search parameters
      # @return [Hash]
      def find_account(criteria)
        response = http_client.get('/admin/api/accounts/find', params: criteria)
        extract(entity: 'account', from: response)
      end

      # @api public
      # @param [Fixnum] id Account Id
      # @return [Hash]
      def show_account(id)
        response = http_client.get("/admin/api/accounts/#{id}")
        extract(entity: 'account', from: response)
      end

      # @api public
      # @return [Array]
      # @param [Fixnum] id Service ID
      def show_policies(id)
        response = http_client.get("/admin/api/services/#{id}/proxy/policies")
        extract(entity: 'policies_config', from: response)
      end

      # @api public
      # @return [Array]
      # @param [Fixnum] id Service ID
      def update_policies(id, policies_config)
        response = http_client.put("/admin/api/services/#{id}/proxy/policies", body: policies_config)
        extract(entity: 'policies_config', from: response)
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @return [Array<Hash>]
      def list_pricingrules_per_metric(application_plan_id, metric_id)
        response = http_client.get("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/pricing_rules")
        extract(collection: 'pricing_rules', entity: 'pricing_rule', from: response)
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @return [Array<Hash>]
      def list_pricingrules_per_application_plan(application_plan_id)
        response = http_client.get("/admin/api/application_plans/#{application_plan_id}/pricing_rules")
        extract(collection: 'pricing_rules', entity: 'pricing_rule', from: response)
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @return [Array<Hash>]
      def create_pricingrule(application_plan_id, metric_id, attributes)
        response = http_client.post("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/pricing_rules", body: attributes)
        extract(entity: 'pricing_rule', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      def list_activedocs
        response = http_client.get('/admin/api/active_docs')
        extract(collection: 'api_docs', entity: 'api_doc', from: response)
      end

      # @api public
      # @param [Hash] attributes ActiveDocs attributes
      # @return [Hash]
      def create_activedocs(attributes)
        response = http_client.post('/admin/api/active_docs', body: attributes)
        extract(entity: 'api_doc', from: response)
      end

      # @api public
      # @param [Fixnum] id ActiveDocs ID
      # @param [Hash] attributes ActiveDocs attributes
      # @return [Hash]
      def update_activedocs(id, attributes)
        response = http_client.put("/admin/api/active_docs/#{id}", body: attributes)
        extract(entity: 'api_doc', from: response)
      end

      # @api public
      # @return [Hash]
      def delete_activedocs(id)
        http_client.delete("/admin/api/active_docs/#{id}")
        true
      end

      # @api public
      # @return [Array<Hash>]
      def list_accounts
        response = http_client.get('/admin/api/accounts')
        extract(collection: 'accounts', entity: 'account', from: response)
      end

      # @api public
      # @param [Fixnum] id Account ID
      # @return [Bool]
      def delete_account(id)
        http_client.delete("/admin/api/accounts/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] account_id Account ID
      # @param [Fixnum] id Application ID
      # @return [Bool]
      def delete_application(account_id, id)
        http_client.delete("/admin/api/accounts/#{account_id}/applications/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @return [Array<Hash>]
      def show_oidc(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy/oidc_configuration")
        extract(entity: 'oidc_configuration', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @return [Hash]
      def update_oidc(service_id, attributes)
        response = http_client.patch("/admin/api/services/#{service_id}/proxy/oidc_configuration",
                                     body: { oidc_configuration: attributes })
        extract(entity: 'oidc_configuration', from: response)
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @return [Array<Hash>]
      def list_features_per_application_plan(application_plan_id)
        response = http_client.get("/admin/api/application_plans/#{application_plan_id}/features")
        extract(collection: 'features', entity: 'feature', from: response)
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] id Feature ID
      # @return [Hash]
      def create_application_plan_feature(application_plan_id, id)
        response = http_client.post("/admin/api/application_plans/#{application_plan_id}/features",
                                    body: { feature_id: id })
        extract(entity: 'feature', from: response)
      end

      # @api public
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] id Feature ID
      # @return [Boolean]
      def delete_application_plan_feature(application_plan_id, id)
        http_client.delete("/admin/api/application_plans/#{application_plan_id}/features/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] id Service ID
      # @return [Array<Hash>]
      def list_service_features(id)
        response = http_client.get("/admin/api/services/#{id}/features")
        extract(collection: 'features', entity: 'feature', from: response)
      end

      # @api public
      # @param [Fixnum] id Service ID
      # @param [Hash] attributes Feature Attributes
      # @return [Hash]
      def create_service_feature(id, attributes)
        response = http_client.post("/admin/api/services/#{id}/features",
                                    body: { feature: attributes })
        extract(entity: 'feature', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Feature ID
      # @return [Hash]
      def show_service_feature(service_id, id)
        response = http_client.get("/admin/api/services/#{service_id}/features/#{id}")
        extract(entity: 'feature', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Feature ID
      # @param [Hash] attributes Feature Attributes
      # @return [Hash]
      def update_service_feature(service_id, id, attributes)
        response = http_client.put("/admin/api/services/#{service_id}/features/#{id}",
                                   body: { feature: attributes })
        extract(entity: 'feature', from: response)
      end

      # @api public
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Feature ID
      # @return [Boolean]
      def delete_service_feature(service_id, id)
        http_client.delete("/admin/api/services/#{service_id}/features/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] account_id Account ID
      # @param [String] state State
      # @param [String] role Role
      # @return [Array<Hash>]
      def list_users(account_id, state: nil, role: nil)
        params = { state: state, role: role }.reject { |_, value| value.nil? }
        response = http_client.get("/admin/api/accounts/#{account_id}/users", params: params)
        extract(collection: 'users', entity: 'user', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] email User email
      # @param [String] username User Username
      # @param [String] password User password
      # @param [Hash] attributes User Attributes
      # @return [Hash]
      def create_user(account_id:, email:, username:, password:, **rest)
        body = { email: email, username: username, password: password }.merge(rest)
        response = http_client.post("/admin/api/accounts/#{account_id}/users", body: body)
        extract(entity: 'user', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] user_id User ID
      # @return [Hash]
      def activate_user(account_id, user_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/users/#{user_id}/activate")
        extract(entity: 'user', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @return [Hash]
      def approve_account(account_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/approve")
        extract(entity: 'account', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @return [Array<Hash>]
      def list_account_applications(account_id)
        response = http_client.get("/admin/api/accounts/#{account_id}/applications")
        extract(collection: 'applications', entity: 'application', from: response)
      end

      # @api public
      # @return [Array<Hash]
      def list_application_plans
        response = http_client.get("/admin/api/application_plans")
        extract(collection: 'plans', entity: 'application_plan', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] application_id Application ID
      # @return [Array<Hash>]
      def list_application_keys(account_id, application_id)
        response = http_client.get("/admin/api/accounts/#{account_id}/applications/#{application_id}/keys")
        extract(collection: 'keys', entity: 'key', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] application_id Application ID
      # @param [String] key Key
      # @return [Hash]
      def create_application_key(account_id, application_id, key)
        response = http_client.post("/admin/api/accounts/#{account_id}/applications/#{application_id}/keys", body: {key: key})
        extract(entity: 'application', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] application_id Application ID
      # @return [Hash] application Application
      def accept_application(account_id, application_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/accept")
        extract(entity: 'application', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] application_id Application ID
      # @return [Hash] application Application
      def suspend_application(account_id, application_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/suspend")
        extract(entity: 'application', from: response)
      end

      # @api public
      # @param [String] account_id Account ID
      # @param [String] application_id Application ID
      # @return [Hash] application Application
      def resume_application(account_id, application_id)
        response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/resume")
        extract(entity: 'application', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      def list_policy_registry
        response = http_client.get('/admin/api/registry/policies')
        extract(collection: 'policies', entity: 'policy', from: response)
      end

      # @api public
      # @param [Hash] attributes Policy Registry Attributes
      # @return [Hash]
      def create_policy_registry(attributes)
        response = http_client.post('/admin/api/registry/policies', body: attributes)
        extract(entity: 'policy', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Policy Registry Id
      def show_policy_registry(id)
        response = http_client.get("/admin/api/registry/policies/#{id}")
        extract(entity: 'policy', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Policy Registry Id
      # @param [Hash] attributes Policy Registry Attributes
      def update_policy_registry(id, attributes)
        response = http_client.put("/admin/api/registry/policies/#{id}", body: attributes)
        extract(entity: 'policy', from: response)
      end

      # @api public
      # @param [Fixnum] id Policy Registry Id
      def delete_policy_registry(id)
        http_client.delete("/admin/api/registry/policies/#{id}")
        true
      end

      # @api public
      # @return [Hash]
      def show_provider
        response = http_client.get('/admin/api/provider')
        extract(entity: 'account', from: response)
      end

      # @api public
      # @return [List]
      def list_backends
        response = http_client.get('/admin/api/backend_apis')
        extract(collection: 'backend_apis', entity: 'backend_api', from: response)
      end

      # @api public
      # @param [Hash] attributes Backend attributes
      # @return [Hash]
      def create_backend(attributes)
        response = http_client.post('/admin/api/backend_apis', body: attributes)
        extract(entity: 'backend_api', from: response)
      end

      # @api public
      # @param [Fixnum] id Backend ID
      def delete_backend(id)
        http_client.delete("/admin/api/backend_apis/#{id}")
        true
      end

      # @api public
      # @param [Fixnum] id Backend ID
      # @return [Hash]
      def backend(id)
        response = http_client.get("/admin/api/backend_apis/#{id}")
        extract(entity: 'backend_api', from: response)
      end

      # @api public
      # @param [Fixnum] id Backend ID
      # @param [Hash] attributes Backend attributes
      # @return [Hash]
      def update_backend(id, attributes)
        response = http_client.put("/admin/api/backend_apis/#{id}", body: attributes)
        extract(entity: 'backend_api', from: response)
      end

      # @api public
      # @param [Fixnum] id Backend ID
      # @return [List]
      def list_backend_metrics(id)
        response = http_client.get("/admin/api/backend_apis/#{id}/metrics")
        extract(collection: 'metrics', entity: 'metric', from: response)
      end

      # @api public
      # @param [Fixnum] id Backend ID
      # @param [Hash] attributes Metric attributes
      # @return [Hash]
      def create_backend_metric(id, attrs)
        response = http_client.post("/admin/api/backend_apis/#{id}/metrics", body: attrs)
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      def delete_backend_metric(backend_id, metric_id)
        http_client.delete("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}")
        true
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @return [Hash]
      def backend_metric(backend_id, metric_id)
        response = http_client.get("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}")
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @param [Hash] attributes Backend attributes
      # @return [Hash]
      def update_backend_metric(backend_id, metric_id, attributes)
        response = http_client.put("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}", body: attributes)
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @return [List]
      def list_backend_methods(backend_id, metric_id)
        response = http_client.get("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}/methods")
        extract(collection: 'methods', entity: 'method', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @param [Hash] attributes Metric attributes
      # @return [Hash]
      def create_backend_method(backend_id, metric_id, attrs)
        response = http_client.post("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}/methods",
                                    body: attrs)
        extract(entity: 'method', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @param [Fixnum] method_id Backend Method ID
      def delete_backend_method(backend_id, metric_id, method_id)
        http_client.delete("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}/methods/#{method_id}")
        true
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @param [Fixnum] method_id Backend Method ID
      # @return [Hash]
      def backend_method(backend_id, metric_id, method_id)
        response = http_client.get("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}/methods/#{method_id}")
        extract(entity: 'method', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] metric_id Backend Metric ID
      # @param [Fixnum] method_id Backend Method ID
      # @param [Hash] attributes Backend attributes
      # @return [Hash]
      def update_backend_method(backend_id, metric_id, method_id, attributes)
        response = http_client.put("/admin/api/backend_apis/#{backend_id}/metrics/#{metric_id}/methods/#{method_id}",
                                   body: attributes)
        extract(entity: 'method', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @return [List]
      def list_backend_mapping_rules(backend_id)
        response = http_client.get("/admin/api/backend_apis/#{backend_id}/mapping_rules")
        extract(collection: 'mapping_rules', entity: 'mapping_rule', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Hash] attributes Metric attributes
      # @return [Hash]
      def create_backend_mapping_rule(backend_id, attrs)
        response = http_client.post("/admin/api/backend_apis/#{backend_id}/mapping_rules",
                                    body: attrs)
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] mapping_rule_id MappingRule ID
      def delete_backend_mapping_rule(backend_id, mapping_rule_id)
        http_client.delete("/admin/api/backend_apis/#{backend_id}/mapping_rules/#{mapping_rule_id}")
        true
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] mapping_rule_id MappingRule ID
      # @return [Hash]
      def backend_mapping_rule(backend_id, mapping_rule_id)
        response = http_client.get("/admin/api/backend_apis/#{backend_id}/mapping_rules/#{mapping_rule_id}")
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @param [Fixnum] backend_id Backend ID
      # @param [Fixnum] mapping_rule_id MappingRule ID
      # @param [Hash] attributes Backend attributes
      # @return [Hash]
      def update_backend_mapping_rule(backend_id, mapping_rule_id, attributes)
        response = http_client.put("/admin/api/backend_apis/#{backend_id}/mapping_rules/#{mapping_rule_id}",
                                   body: attributes)
        extract(entity: 'mapping_rule', from: response)
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
