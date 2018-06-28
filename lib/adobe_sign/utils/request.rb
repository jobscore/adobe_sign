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

        JSON.parse(response.body)
      end
    end
  end
end
