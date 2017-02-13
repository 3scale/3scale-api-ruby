module ThreeScale
  module API
    module Managers
      class ServicePlans < DefaultManager
        # @api public
        # @return [Array<Hash>] List of services
        def list
          response = http_client.get('/admin/api/service_plans')
          extract(collection: 'plans', entity: 'service_plan', from: response)
        end

        # @api public
        # @return [Array<Hash>] List of services
        def list_for_service(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/service_plans")
          extract(collection: 'plans', entity: 'service_plan', from: response)
        end

        # @api public
        # @param [Fixnum] service_id Service Id
        # @param [Fixnum] plan_id Service plan Id
        def set_default(service_id, plan_id)
          response = http_client.put("/admin/api/services/#{service_id}/service_plans/#{plan_id}/default")
          extract(entity: 'service_plan', from: response)
        end

        # @api public
        # Gets default service plan
        # @param [Fixnum] service_id
        # @return [Hash] Default service plan hash
        def get_default(service_id)
          self.list_for_service(service_id).each do |plan|
            if plan['default']
              return plan
            end
          end
          nil
        end

        # @api public
        # Creates a service plan
        # @param [Fixnum] service_id Service id
        # @param [String] name Service plan name
        def create(service_id, name)
          response = http_client.post("/admin/api/services/#{service_id}/service_plans",
                                      body: {
                                            name: name
                                      })
          extract(entity: 'service_plan', from: response)
        end

        # @api public
        # Reads a service plan
        # @param [Fixnum] service_id Service id
        # @param [Fixnum] service_plan_id Service plan id
        def read(service_id, service_plan_id)
          response = http_client.get("/admin/api/services/#{service_id}/service_plans/#{service_plan_id}")
          extract(entity: 'service_plan', from: response)
        end

        # @api public 
        # Gets service plan by its name
        # @param [Fixnum] service_id
        # @param [String] plan_name
        def get_by_name(service_id, plan_name)
          self.list_for_service(service_id).each do |plan|
            if plan['name'] == plan_name
              return plan
            end
          end
          nil
        end

        # @api public 
        # Deletes service plan 
        # @param [Fixnum] service_id
        # @param [String] plan_name
        def delete(service_id, service_plan_id)
          http_client.delete("/admin/api/services/#{service_id}/service_plans/#{service_plan_id}")
          true
        end
      end
    end
  end
end