module ThreeScale
  module API
    module Managers
      class Mappings < DefaultManager
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules")
          extract(entity: 'mapping_rule', collection: 'mapping_rules', from: response)
        end

        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Mapping Rule ID
        def read(service_id, id)
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
        def create(service_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/proxy/mapping_rules",
                                      body: attributes)
          extract(entity: 'mapping_rule', from: response)
        end

        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Mapping Rule ID
        def delete(service_id, id)
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
        def update(service_id, id, attributes)
          response = http_client.patch("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}",
                                       body: { mapping_rule: attributes })
          extract(entity: 'mapping_rule', from: response)
        end
      end
    end
  end
end