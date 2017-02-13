module ThreeScale
  module API
    module Managers
      class Proxy < DefaultManager
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        def read(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/proxy")
          extract(entity: 'proxy', from: response)
        end

        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        def update(service_id, attributes)
          response = http_client.patch("/admin/api/services/#{service_id}/proxy",
                                       body: attributes)
          extract(entity: 'proxy', from: response)
        end
      end
    end
  end
end