require 'httmultiparty'

module AdobeSign
  module Utils
    module Request
      def self.get(endpoint, headers = {}, full = false)
        # puts "endpoint: #{endpoint}"
        # puts "headers: #{headers}"

        response = HTTParty.get(endpoint, headers: headers)
        format_response(response, full)
      end

      def self.get_file(endpoint, headers = {}, filename = 'download')
        response = HTTParty.get(endpoint, headers: headers)

        return nil unless status_code_symbol(response.code) == :ok

        extension = content_type_extension(response.headers['content-type'])
        return nil if extension.blank?

        tempfile = Tempfile.new([filename, extension])
        tempfile.binmode
        tempfile.write(response.body)
        tempfile.rewind
        tempfile
      end

      def self.post(endpoint, body = {}, headers = {})
        response = HTTParty.post(endpoint, query: body, headers: headers)
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
        # puts(response)

        format_response(response)
      end

      def self.put_json(endpoint, body = {}, headers = {})
        headers['Content-Type'] = 'application/json'

        response = HTTMultiParty.put(endpoint, body: body.to_json, headers: headers)
        puts(response)

        format_response(response)
      end

      def self.delete(endpoint, headers = {})
        headers['Content-Type'] = 'application/json'

        response = HTTParty.delete(endpoint, headers: headers)
        # puts(response)

        format_response(response)
      end

      private

      def self.content_type_extension(content_type)
        extension = nil
        content_type.split(';').each do |mime_type|
          extension ||= Rack::Mime::MIME_TYPES.invert[mime_type]
        end

        extension
      end

      def self.format_response(response, full = false)
        body = response.body.present? ? JSON.parse(response.body).with_indifferent_access : {}
        data = {
          status: status_code_symbol(response.code),
          data: body
        }

        data[:headers] = response.headers.with_indifferent_access if full

        OpenStruct.new(data)
      end

      def self.status_code_symbol(status_code)
        Rack::Utils::SYMBOL_TO_STATUS_CODE.key(status_code)
      end
    end
  end
end
