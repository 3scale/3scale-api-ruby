require 'json'
require 'uri'
require 'net/http'
require 'openssl'

module ThreeScale
  module API
    class HttpClient
      attr_reader :endpoint, :admin_domain, :provider_key, :headers, :format

      def initialize(endpoint:, provider_key:, format: :json, verify_ssl: true)
        @endpoint = URI(endpoint).freeze
        @admin_domain = @endpoint.host.freeze
        @provider_key = provider_key.freeze
        @http = Net::HTTP.new(admin_domain, @endpoint.port)
        @http.use_ssl = @endpoint.is_a?(URI::HTTPS)
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless verify_ssl

        @headers = {
          'Accept' => "application/#{format}",
          'Content-Type' => "application/#{format}",
          'Authorization' => 'Basic ' + [":#{@provider_key}"].pack('m').delete("\r\n")
        }

        if debug?
          @http.set_debug_output($stdout)
          @headers['Accept-Encoding'] = 'identity'
        end

        @headers.freeze

        @format = format
      end

      def get(path, params: nil)
        parse @http.get(format_path_n_query(path, params), headers)
      end

      def patch(path, body:, params: nil)
        parse @http.patch(format_path_n_query(path, params), serialize(body), headers)
      end

      def post(path, body:, params: nil)
        parse @http.post(format_path_n_query(path, params), serialize(body), headers)
      end

      def put(path, body: nil, params: nil)
        parse @http.put(format_path_n_query(path, params), serialize(body), headers)
      end

      def delete(path, params: nil)
        parse @http.delete(format_path_n_query(path, params), headers)
      end

      # @param [::Net::HTTPResponse] response
      def parse(response)
        case response
        when Net::HTTPUnprocessableEntity, Net::HTTPSuccess then parser.decode(response.body)
        when Net::HTTPForbidden then forbidden!(response)
        when Net::HTTPNotFound then notfound!(response)
        else unexpected!(response)
        end
      end

      class ForbiddenError < ResponseError; end

      class UnexpectedResponseError < ResponseError; end

      class NotFoundError < ResponseError; end

      def forbidden!(response)
        raise ForbiddenError.new(response)
      end

      def notfound!(response)
        raise NotFoundError.new(response)
      end

      def unexpected!(response)
        raise UnexpectedResponseError.new(response)
      end

      def serialize(body)
        case body
        when nil then nil
        when String then body
        else parser.encode(body)
        end
      end

      def parser
        case format
        when :json then JSONParser
        else "unknown format #{format}"
        end
      end

      protected

      def debug?
        ENV.fetch('THREESCALE_DEBUG', '0') == '1'
      end

      # Helper to create a string representing a path plus a query string
      def format_path_n_query(path, params)
        path = "#{path}.#{format}"
        path << "?#{URI.encode_www_form(params)}" unless params.nil?
        path
      end

      module JSONParser
        module_function

        def decode(string)
          case string
          when nil, ' '.freeze, ''.freeze then nil
          else ::JSON.parse(string)
          end
        end

        def encode(query)
          ::JSON.generate(query)
        end
      end
    end
  end
end
