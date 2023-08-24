require 'marcel'

module AdobeSign
  class Documents < Utils::Endpoint
    def base
      '/transientDocuments'
    end

    def upload(file, name)
      AdobeSign::Utils::Request.post_multipart(endpoint, build_body(file, name), headers)
    end

    private

    def build_body(file, name)
      content_type = Marcel::MimeType.for(file)
      file_part = Faraday::Multipart::FilePart.new(file, content_type, name)

      { File: file_part, 'File-Name': name }
    end
  end
end
