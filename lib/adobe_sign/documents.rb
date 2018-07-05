module AdobeSign
  class Documents < Utils::Endpoint
    def base
      '/transientDocuments'
    end

    def upload(file, name)
      query = {
        'File-Name' => name,
        'File' => file
      }

      AdobeSign::Utils::Request.post_multiparty(endpoint, query, headers)
    end
  end
end
