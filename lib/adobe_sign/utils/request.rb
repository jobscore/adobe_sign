require 'faraday'
require 'faraday/multipart'

module AdobeSign
  module Utils
    module Request
      def self.get(endpoint, headers = {}, full = false)
        response = Faraday.get(endpoint, nil, headers)
        format_response(response, full)
      end

      def self.get_file(endpoint, headers = {}, filename = 'download')
        response = Faraday.get(endpoint, nil, headers)

        return nil unless status_code_symbol(response.status) == :ok

        extension = content_type_extension(response.headers['content-type'])
        return nil if extension.blank?

        tempfile = Tempfile.new([filename, extension])
        tempfile.binmode
        tempfile.write(response.body)
        tempfile.rewind
        tempfile
      end

      def self.post(endpoint, body = {}, headers = {})
        response = Faraday.post(endpoint, body, headers)
        format_response(response)
      end

      def self.post_multipart(endpoint, body = {}, headers = {})
        connection = Faraday.new do |builder|
          builder.request :multipart
        end
        response = connection.post(endpoint, body, headers)

        format_response(response)
      end

      def self.post_json(endpoint, body = {}, headers = {})
        headers['Content-Type'] = 'application/json'

        response = Faraday.post(endpoint, body.to_json, headers)

        format_response(response)
      end

      def self.put_json(endpoint, body = {}, headers = {})
        headers['Content-Type'] = 'application/json'

        response = Faraday.put(endpoint, body.to_json, headers)

        format_response(response)
      end

      def self.delete(endpoint, headers = {})
        headers['Content-Type'] = 'application/json'

        response = Faraday.delete(endpoint, nil, headers)

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
        body = response.body.present? ? JSON.parse(response.body).try(:with_indifferent_access) || {} : {}
        # binding.pry
        data = {
          status: status_code_symbol(response.status),
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
