module AdobeSign
  class Agreements < Utils::Endpoint
    def base
      '/agreements'
    end

    def post(data)
      AdobeSign::Utils::Request.post_json(endpoint, data, headers)
    end

    def signing_urls(agreement_id)
      AdobeSign::Utils::Request.get(endpoint("/#{agreement_id}/signingUrls"), headers)
    end
  end
end
