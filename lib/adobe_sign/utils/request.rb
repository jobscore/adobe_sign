require 'httparty'

module AdobeSign
  module Utils
    module Request

      API_VERSION_PATH = '/api/rest/v6'

      def self.endpoint(base_uri, path)
        base_uri + API_VERSION_PATH + path
      end

      def self.get(endpoint, headers = {})
        HTTParty.get(
          endpoint,
          headers: headers
        )
      end

      def self.post(endpoint, body = {}, headers = {})
        puts "endpoint: #{endpoint}"
        puts "body: #{body.to_s}"

        response = HTTParty.post(endpoint, query: body, headers: headers)
        puts(response)

        format_response(response)
      end

      private

      def self.format_response(response)
        OpenStruct.new(
          status: self.status_code_symbol(response.code),
          data: JSON.parse(response.body).with_indifferent_access
        )
      end

      def self.status_code_symbol(status_code)
        Rack::Utils::SYMBOL_TO_STATUS_CODE.key(status_code)
      end
    end
  end
end
