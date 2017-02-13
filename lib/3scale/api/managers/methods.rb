module ThreeScale
  module API
    module Managers
      class Methods < DefaultManager
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] metric_id Metric ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Method Name
        def create(service_id, metric_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods",
                                      body: attributes)
          extract(entity: 'method', from: response)
        end

        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] metric_id Metric ID
        def list(service_id, metric_id)
          response = http_client.get("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods")
          extract(collection: 'methods', entity: 'method', from: response)
        end

        # @api public
        # @param [Fixnum] service_id Service id
        # @param [Fixnum] metric_id Metric id
        # @param [Fixnum] method_id Method id
        def read(service_id, metric_id, method_id)
          response = http_client.get("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods/#{method_id}")
          extract(entity: 'method', from: response)
        end

        def delete(service_id, metric_id, id)
          http_client.delete("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods/#{id}")
          true
        end

      end
    end
  end
end