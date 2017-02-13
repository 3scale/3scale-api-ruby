module ThreeScale
  module API
    module Managers
      class DefaultManager

        attr_reader :http_client
        
        # Initializes managers
        # @param [ThreeScale::API::HttpClient] http_client Http client instance
        def initialize(http_client)
          @http_client = http_client
        end


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
end