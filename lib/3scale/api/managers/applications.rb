module ThreeScale
  module API
    module Managers
      class Applications < DefaultManager
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list(service_id: nil)
          params = service_id ? {service_id: service_id} : nil
          response = http_client.get('/admin/api/applications', params: params)
          extract(collection: 'applications', entity: 'application', from: response)
        end

        def list_for_account(account_id)
          response = http_client.get("/admin/api/accounts/#{account_id}/applications")
          extract(collection: 'applications', entity: 'application', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] id Application ID
        def show(id)
          find(id: id)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] id Application ID
        # @param [String] user_key Application User Key
        # @param [String] application_id Application App ID
        def find(id: nil, user_key: nil, application_id: nil, service_id: nil)
          params = {service_id: service_id, application_id: id, user_key: user_key, app_id: application_id}.reject { |_, value| value.nil? }
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
        def create(account_id, attributes: {}, plan_id:, **rest)
          body = {plan_id: plan_id}.merge(attributes).merge(rest)
          response = http_client.post("/admin/api/accounts/#{account_id}/applications", body: body)
          extract(entity: 'application', from: response)
        end

        def update(account_id, id, attributes)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}",  body: attributes )
          extract(entity: 'application', from: response)
        end

        def delete(account_id, id)
          http_client.delete("/admin/api/accounts/#{account_id}/applications/#{id}")
          true
        end

        def key_create(account_id, application_id, key)
          body = {account_id: account_id, application_id: application_id, key: key}
          response = http_client.post("/admin/api/accounts/#{account_id}/applications/#{application_id}/keys", body: body)
          extract(entity: 'key', from: response)
        end

        def keys_list(account_id, application_id)
          response = http_client.get("/admin/api/accounts/#{account_id}/applications/#{application_id}/keys")
          extract(collection: 'keys', entity: 'key', from: response)
        end

        def key_delete(account_id, application_id, key)
          http_client.delete("/admin/api/accounts/#{account_id}/applications/#{application_id}/keys/#{key}")
          true
        end

        def referrer_filter_list(account_id, application_id)
          response = http_client.get("/admin/api/accounts/#{account_id}/applications/#{application_id}/referrer_filters")
          extract(collection: 'referrer_filters', entity: 'referrer_filter', from: response)
        end

        def referrer_filter_create(account_id, application_id, key)
          body = {account_id: account_id, application_id: application_id, referrer_filter: key}
          response = http_client.post(
              "/admin/api/accounts/#{account_id}/applications/#{application_id}/referrer_filters", body: body)
          extract(entity: 'referrer_filter', from: response)
        end

        def referrer_filter_delete(account_id, application_id, id)
          http_client.delete("/admin/api/accounts/#{account_id}/applications/#{application_id}/referrer_filters/#{id}")
          true
        end

        def change_plan(account_id, id, plan_id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}/change_plan",
                                     body: {plan_id: plan_id})
          extract(entity: 'application_plan', from: response)
        end

        def create_plan_customization(account_id, id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}/customize_plan")
          extract(entity: 'application_plan', from: response)
        end

        def delete_plan_customization(account_id, id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}/decustomize_plan")
          extract(entity: 'application_plan', from: response)
        end

        def accept(account_id, id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}/accept")
          extract(entity: 'application', from: response)
        end

        def suspend(account_id, id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}/suspend")
          extract(entity: 'application', from: response)
        end

        def resume(account_id, id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{id}/resume")
          extract(entity: 'application', from: response)
        end

      end
    end
  end
end