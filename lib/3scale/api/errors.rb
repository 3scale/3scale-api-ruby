module ThreeScale
  module API
    class ResponseError < StandardError
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def to_s
        response.to_s
      end

      def inspect
        response.inspect
      end
    end
  end
end
