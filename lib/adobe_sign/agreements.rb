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

    def state(agreement_id, data)
      custom_headers = headers
      custom_headers['If-Match'] = etag(agreement_id)

      AdobeSign::Utils::Request.put_json(endpoint("/#{agreement_id}/state"), data, custom_headers.compact)
    end

    def get(agreement_id, full = false)
      AdobeSign::Utils::Request.get(endpoint("/#{agreement_id}"), headers, full)
    end

    def etag(agreement_id)
      data = get(agreement_id, true)
      data.status == :ok ? data.headers[:etag] : nil
    end

    def documents(agreement_id)
      AdobeSign::Utils::Request.get(endpoint("/#{agreement_id}/documents"), headers)
    end

    def document(agreement_id, document_id)
      AdobeSign::Utils::Request.get_file(endpoint("/#{agreement_id}/documents/#{document_id}"), headers)
    end
  end
end
