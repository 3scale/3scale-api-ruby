module ThreeScale
  module API
    module Managers
      class AccountPlans < DefaultManager

        # @api public
        # @return [Hash]
        def list
          response = http_client.get('/admin/api/account_plans')
          extract(collection: 'plans', entity: 'account_plan', from: response)
        end

        # @api public
        # @param [String] name
        # @param [String] system_name
        # @return [Hash]
        def create(name, system_name)
          body = { name: name, system_name: system_name }
          response = http_client.post('/admin/api/account_plans', body: body)
          extract(entity: 'account_plan', from: response)
        end

        # @api public
        # Returns the account plan by ID.
        # @param [Fixnum] id ID of the account plan.
        # @return [Hash] Account plan hash
        def read(id)
          response = http_client.get("/admin/api/account_plans/#{id}")
          extract(entity: 'account_plan', from: response)
        end

        # @api public
        # @param [Fixnum] id Id of account plan
        # @param [Object] attr Attributes that should be updated
        # @option attr [Hash] name Name of the plan
        def update(id, attr)
          response = http_client.put("/admin/api/account_plans/#{id}", body: attr)
          extract(entity: 'account_plan', from: response)
        end

        # @api public
        # @param [Fixnum] id Id of the application plan
        # @return [Hash] Application plan hash
        def delete(id)
          http_client.delete("/admin/api/account_plans/#{id}")
          true
        end

        # @api public
        # @param [Fixnum] id Application plan ID
        # @return [Hash]Application plan hash
        def set_default(id)
          response = http_client.put("/admin/api/account_plans/#{id}/default")
          extract(entity: 'account_plan', from: response)
        end

      end
    end
  end
end