module ThreeScale
  module API
    module Managers
      class ApplicationPlans < DefaultManager

        # @api public
        # Returns the list of all application plans across services
        # @return [Array<Hash>]
        def list_all
          response = http_client.get("/admin/api/application_plans")
          extract(collection: 'plans', entity: 'application_plan', from: response)
        end

        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/application_plans")
          extract(collection: 'plans', entity: 'application_plan', from: response)
        end

        # @api public
        # Gets Application plan
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] plan_id Application plan ID
        # @return [Array<Hash>]
        def read(service_id, plan_id)
          response = http_client.get("/admin/api/services/#{service_id}/application_plans/#{plan_id}")
          extract(entity: 'application_plan', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Application Plan Name
        def create(service_id, attributes)
          body = attributes
          response = http_client.post("/admin/api/services/#{service_id}/application_plans",
                                      body: body)
          extract(entity: 'application_plan', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Application plan ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Application Plan Name
        def update(service_id, id, attributes)
          body = {application_plan: attributes}
          response = http_client.put("/admin/api/services/#{service_id}/application_plans/#{id}", body: body)
          extract(entity: 'application_plan', from: response)
        end

        # @api public
        # @param [Fixnum] service_id
        # @return [Boolean]
        def delete(service_id, id)
          http_client.delete("/admin/api/services/#{service_id}/application_plans/#{id}")
          true
        end

        def set_default(service_id, id)
          response = http_client.put("/admin/api/services/#{service_id}/application_plans/#{id}/default")
          extract(entity: 'application_plan', from: response)
        end

        # @api public
        # @return [Hash] a Plan
        # @param [Fixnum] account_id Account ID
        # @param [Fixnum] application_id Application ID
        def customize(account_id, application_id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/customize_plan")
          extract(entity: 'application_plan', from: response)
        end

      end
    end
  end
end