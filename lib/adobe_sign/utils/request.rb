require 'httmultiparty'

module AdobeSign
  module Utils
    module Request
      def self.get(endpoint, headers = {})
        # puts "endpoint: #{endpoint}"
        # puts "headers: #{headers}"

        response = HTTParty.get(
          endpoint,
          headers: headers
        )
        # puts(response)

        format_response(response)
      end

      def self.post(endpoint, body = {}, headers = {})
        response = HTTMultiParty.post(endpoint, query: body, headers: headers)
        format_response(response)
      end

      def self.post_multiparty(endpoint, body = {}, headers = {})
        # puts "endpoint: #{endpoint}"
        # puts "body: #{body.to_s}"

        response = HTTMultiParty.post(endpoint, query: body, headers: headers)
        # puts(response)

        format_response(response)
      end

      def self.post_json(endpoint, body = {}, headers = {})
        headers['Content-Type'] = 'application/json'

        response = HTTMultiParty.post(endpoint, body: body.to_json, headers: headers)
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
