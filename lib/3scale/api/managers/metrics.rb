module ThreeScale
  module API
    module Managers
      class Metrics < DefaultManager
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/metrics")
          extract(collection: 'metrics', entity: 'metric', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Metric Name
        def create(service_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/metrics", body: attributes)
          extract(entity: 'metric', from: response)
        end


        # @api public
        # Returns the metric by ID.
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Id of metric
        # @return [Hash] Metric hash
        def read(service_id, id)
          response = http_client.get("/admin/api/services/#{service_id}/metrics/#{id}")
          extract(entity: 'metric', from: response)
        end

        # @api public
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Id of metric
        # @param [Hash] attributes Metric Attributes
        # @return [Hash] Metric hash
        def update(service_id, id, attributes)
          response = http_client.put("/admin/api/services/#{service_id}/metrics/#{id}", body: {metric: attributes})
          extract(entity: 'metric', from: response)
        end

        # @api public
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Id of metric
        # @return [Boolean]
        def delete(service_id, id)
          http_client.delete("/admin/api/services/#{service_id}/metrics/#{id}")
          true
        end
    
      end
    end
  end
end