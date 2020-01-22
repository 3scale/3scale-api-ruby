module ThreeScale
  module API
    class ResponseError < StandardError
      attr_reader :response

      def initialize(response, message = response.to_s)
        super(message)
        @response = response
      end
    end
  end
end
