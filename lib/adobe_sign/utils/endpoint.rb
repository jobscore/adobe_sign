module AdobeSign
  module Utils
    class Endpoint
      API_VERSION_PATH = 'api/rest/v6'

      attr_accessor :base_path, :token, :header

      def initialize(base_path, token)
        @base_path = base_path
        @token = token
      end

      protected

      def base
        ''
      end

      def headers
        return @header if @token.blank?

        @header ||= {
          'Authorization' => 'Bearer ' + token
        }
      end

      def endpoint(path = '')
        base_path + API_VERSION_PATH + base + path
      end
    end
  end
end
