module ThreeScale
  module API
    module Managers
      class ApplicationPlanLimits < DefaultManager

        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] application_plan_id Application Plan ID
        def list(application_plan_id)
          response = http_client.get("/admin/api/application_plans/#{application_plan_id}/limits")
          extract(collection: 'limits', entity: 'limit', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] application_plan_id Application Plan ID
        # @param [Hash] attributes Metric Attributes
        # @param [Fixnum] metric_id Metric ID
        # @option attributes [String] :period Usage Limit period
        # @option attributes [String] :value Usage Limit value
        def create(application_plan_id, metric_id, attributes)
          response = http_client.post("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits",
                                      body: attributes)
          extract(entity: 'limit', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] application_plan_id Application Plan ID
        # @param [Fixnum] metric_id Metric ID
        # @param [Fixnum] id Limit ID
        def read(application_plan_id, metric_id, id)
          response = http_client.get(
              "/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits/#{id}")
          extract(entity: 'limit', from: response)
        end

        # @param [Fixnum] application_plan_id Application Plan ID
        # @param [Fixnum] metric_id Metric ID
        # @param [Fixnum] limit_id Usage Limit ID
        def delete(application_plan_id, metric_id, limit_id)
          http_client.delete("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits/#{limit_id}")
          true
        end

      end
    end
  end
end